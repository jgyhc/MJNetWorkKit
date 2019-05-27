//
//  MJAPIBaseManager.m
//  ManJi
//
//  Created by Zgmanhui on 2017/8/25.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "MJAPIBaseManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "MJService.h"
#import <CTNetworking/CTServiceFactory.h>
#import <CTMediator/CTMediator.h>
#import "MJAPIInterceptor.h"

@interface MJAPIBaseManager ()<CTAPIManagerValidator, CTAPIManagerCallBackDelegate, CTAPIManagerParamSource>

@property (nonatomic, strong) id progress;

@property (nonatomic, strong) id cache;

@property (nonatomic, strong) MJService * service;
@end

@implementation MJAPIBaseManager

- (void)dealloc {
    [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressHide" params:@{@"progress": self.progress} shouldCacheTarget:YES];
    self.progress = nil;
}

#pragma mark - CTAPIManagerParamSource method
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    return nil;
}

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.validator = self;
        self.delegate = self;
        self.interceptor = [MJAPIInterceptor sharedInstance];
    }
    return self;
}

#pragma mark - CTAPIManager
- (NSString *)methodName {
    return @"";
}

- (MJService *)service {
    if (!_service) {
        _service = [[NSClassFromString([self serviceIdentifier]) alloc] init];
    }
    return _service;
}

- (NSString *)serviceIdentifier {
    return @"MJService";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}

- (BOOL)isShowProgressHUD {
    return YES;
}

- (BOOL)isHideProgressHUDWhenSuccess {
    return YES;
}

- (BOOL)isShowProgressHUDWhenFailed {
    return YES;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([self isShowProgressHUD]) {
        [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressLoadingShow" params:@{@"progress": self.progress, @"content":[self loadingText]} shouldCacheTarget:YES];
    }
    //是否需要对个别字段进行RSA加密
    if ([self isNeedFieldEncrypted]) {
        NSMutableDictionary *mutabkeParams = [self dealParams:params].mutableCopy;
        NSArray *keys = [self encryptedFields];
        [keys enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = [mutabkeParams objectForKey:key];
            if (value && [value isKindOfClass:[NSString class]]) {
                NSString *publicKey = [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"fieldPublicKey" params:nil shouldCacheTarget:YES];
                
                [mutabkeParams setObject:[[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"RSAEncryptor" params:@{@"value": value,
                                                                                                                               @"publicKey":publicKey
                                                                                                                               } shouldCacheTarget:YES] forKey:key];
            }
        }];
        return mutabkeParams;
    }
    
    return [self dealParams:json];
}

- (NSDictionary *)dealParams:(NSDictionary *)params {
//    NSString *serviceIdentifier = self.child.serviceIdentifier;
//    MJService *service = (MJService *)[[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
//    [service.httpHeadParmas setObject:@"" forKey:@"roundNumber"];
    return params;
}

- (id)dataProcessing:(id)data {
    return data;
}

- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    id data = [manager fetchDataWithReformer:nil];
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSNumber *code = [data objectForKey:[self.service codeString]];
    NSString *msg = [data objectForKey:[self.service descString]];
    if ([msg isKindOfClass:[NSString class]] && msg.length == 0) {
        msg = @"请求失败";
    }
    if ([code integerValue] == [self.service normalResultsCode]) {//请求到 服务器认为的正常结果
        if ([self isYyCache] && data && [self.service dataString]) {//如果需要使用yycacha 缓存数据
            if (!_cache) {
                _cache = [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"cacheData" params:@{@"dataString": [self.service dataString], @"data": data, @"isCachePath": @([self isCachePath]), @"cachePath": [self cachePath], @"cacheName": [self cacheName]} shouldCacheTarget:YES];
            }else {
                [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"cacheData" params:@{@"dataString": [self.service dataString], @"data": data, @"isCachePath": @([self isCachePath]), @"cachePath": [self cachePath], @"cacheName": [self cacheName], @"cache": _cache} shouldCacheTarget:YES];
            }
        }
        if ([self isHideProgressHUDWhenSuccess]) {
            [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressHide" params:@{@"progress": self.progress} shouldCacheTarget:YES];
        }else {
            [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressShow" params:@{@"progress": self.progress, @"content":msg?msg:@"", @"view": [self progressSuperView]} shouldCacheTarget:YES];
        }
    }else {
        if ([self isShowProgressHUDWhenFailed]) {
            [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressShow" params:@{@"progress": self.progress, @"content":msg?msg:@"", @"view": [self progressSuperView]} shouldCacheTarget:YES];
        }else {
            [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressHide" params:@{@"progress": self.progress} shouldCacheTarget:YES];
        }
    }
    id afterData = [self dataProcessing:data];
    if (self.mj_delegate &&[self.mj_delegate respondsToSelector:@selector(manager:callBackData:)]) {
        [self.mj_delegate manager:self callBackData:afterData];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (self.mj_delegate && [self.mj_delegate respondsToSelector:@selector(failManager:)]) {
        [self.mj_delegate failManager:manager];
    }
    if ([self isShowProgressHUDWhenFailed]) {
        [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressShow" params:@{@"progress": self.progress, @"content":@"请求失败", @"view": [self progressSuperView]} shouldCacheTarget:YES];
    }else {
        [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressHide" params:@{@"progress": self.progress} shouldCacheTarget:YES];
    }
}

- (UIView *)progressSuperView {
    return [[UIApplication sharedApplication] keyWindow];
}

#pragma mark - CTAPIManagerValidator
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *_Nonnull)manager isCorrectWithCallBackData:(NSDictionary *_Nullable)data {
    return CTAPIManagerErrorTypeNoError;
}

- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *_Nonnull)manager isCorrectWithParamsData:(NSDictionary *_Nullable)data {
    return CTAPIManagerErrorTypeNoError;
}

- (NSString *)loadingText {
    return @"";
}

/** 原框架的缓存  这里默认NO 因为这里外层用了YYCache */
- (BOOL)shouldCache {
    return NO;
}

- (NSString *)cacheName {
    return @"Base";
}

- (BOOL)isCachePath {
    return NO;
}

- (BOOL)isYyCache {
    return NO;
}

- (BOOL)isReturnCacheDataWhenFailed {
    return NO;
}

- (NSString *)cachePath {
    return [self getDocumentPathWithFirstName:@"Base"];
}

- (BOOL)isCheckToken {
    return NO;
}

- (BOOL)isNeedFieldEncrypted {
    return NO;
}

- (NSArray *)encryptedFields {
    return [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"encryptorFields" params:nil shouldCacheTarget:YES];
}

- (id)progress {
    if (!_progress) {
        _progress = [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progress" params:nil shouldCacheTarget:YES];
    }
    return _progress;
}

- (NSString *)getDocumentPathWithFirstName:(NSString *)firstName {
    NSString *path = [self getDocumentPath];
    if (firstName) {
        return [NSString stringWithFormat:@"%@/%@", path, firstName];
    }
    return path;
}

- (NSString *)getDocumentPath {
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [userPaths objectAtIndex:0];
}



@end
