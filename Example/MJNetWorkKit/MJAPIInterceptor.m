//
//  MJAPIInterceptor.m
//  AFNetworking
//
//  Created by manjiwang on 2019/4/23.
//

#import "MJAPIInterceptor.h"
#import "MJAPIBaseManager.h"
#import "MJService.h"
#import <Bugly/Bugly.h>
#import "CTMediator.h"
//#import "MJOauthTokenTool.h"
#import <UMCommon/UMCommon.h>//友盟
#import <UMAnalytics/MobClick.h>

@interface MJAPIInterceptor ()

@property (nonatomic, strong) NSMutableArray * apiPool;

@property (nonatomic, assign) BOOL isLoading;

@end



@implementation MJAPIInterceptor

+ (instancetype)sharedInstance {
    static MJAPIInterceptor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MJAPIInterceptor alloc] init];
    });
    return instance;
}

- (void)manager:(MJAPIBaseManager *_Nonnull)manager afterPerformFailWithResponse:(CTURLResponse *_Nonnull)response {
    if (manager.progress) {
        if ([manager isShowProgressHUDWhenFailed]) {
            [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressShow" params:@{@"progress": manager.progress, @"content":@"请求失败", @"view": [manager progressSuperView]} shouldCacheTarget:YES];
        }else {
            [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressHide" params:@{@"progress": manager.progress} shouldCacheTarget:YES];
        }
    }
    //记录异常
     #if RELEASE
                   //记录异常
        NSString *name = [manager methodName];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

        NSDictionary*jsonDict = [NSJSONSerialization JSONObjectWithData:response.request.HTTPBody options:NSJSONReadingMutableLeaves error:nil];

        [userInfo setObject:jsonDict?jsonDict:@"" forKey:@"requestJson"];
        [userInfo setObject:response.request.URL.absoluteString forKey:@"url"];
        [userInfo setObject:data?data:@"" forKey:@"responseJson"];

        //                [Bugly reportExceptionWithCategory:3 name:name reason:msg callStack:@[] extraInfo:userInfo terminateApp:NO];
        [Bugly reportException:[NSException exceptionWithName:name reason:msg userInfo:userInfo]];
        msg = @"网络异常";
    #endif
    
}

- (BOOL)manager:(MJAPIBaseManager *_Nonnull)manager shouldCallAPIWithParams:(NSDictionary *_Nullable)params {
//    MJAPIBaseManager *mjManager = (MJAPIBaseManager *)manager;
//    if ([mjManager isCheckToken]) {
//        __weak typeof(self) wself = self;
//        MJOauthTokenToolTokenStatus status = [[MJOauthTokenTool sharedInstance] isShouldRefreshWithAccessToken:@"" refreshToken:@""];
//        [self.apiPool removeAllObjects];
//        if (status == MJOauthTokenToolTokenNormal) {
//            return YES;
//        }else if (status == MJOauthTokenToolTokenReLogin) {
//            return NO;
//        }else {
//            [self.apiPool addObject:manager];
//            if (self.isLoading) {
//                return NO;
//            }
//            [[MJOauthTokenTool sharedInstance] updateTokenWithRefreshToken:@"" success:^(id  _Nullable obj) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"MJRefreshTokenNotificationKey" object:obj userInfo:nil];
//                for (CTAPIBaseManager *api in wself.apiPool) {
//                    [api loadData];
//                }
//            } failure:^(NSError * _Nullable error) {
//                
//            }];
//            return NO;
//        }
//    }
//    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([manager isShowProgressHUD] && manager.progress) {
        [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressLoadingShow" params:@{@"progress": manager.progress, @"content":[manager loadingText]} shouldCacheTarget:YES];
    }
    //是否需要对个别字段进行RSA加密
    if ([manager isNeedFieldEncrypted]) {
        NSMutableDictionary *mutabkeParams = [manager dealParams:params].mutableCopy;
        NSArray *keys = [manager encryptedFields];
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
    
    
    
    return YES;
}

- (BOOL)manager:(MJAPIBaseManager *_Nonnull)manager beforePerformSuccessWithResponse:(CTURLResponse *_Nonnull)response {
    id data = [manager fetchDataWithReformer:nil];
    MJService *service = [[NSClassFromString([manager serviceIdentifier]) alloc] init];
    NSNumber *code = [data objectForKey:[service codeString]];
    NSString *msg = [data objectForKey:[service descString]];
    if ([msg isKindOfClass:[NSString class]] && msg.length == 0) {
       msg = @"请求失败";
    }
    if ([code integerValue] == [service normalResultsCode]) {//请求到 服务器认为的正常结果
       if ([manager isYyCache] && data && [service dataString]) {//如果需要使用yycacha 缓存数据
           if (!manager.cache) {
               manager.cache = [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"cacheData" params:@{@"dataString": [service dataString], @"data": data, @"isCachePath": @([manager isCachePath]), @"cachePath": [manager cachePath], @"cacheName": [manager cacheName]} shouldCacheTarget:YES];
           }else {
               [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"cacheData" params:@{@"dataString": [service dataString], @"data": data, @"isCachePath": @([manager isCachePath]), @"cachePath": [manager cachePath], @"cacheName": [manager cacheName], @"cache": manager.cache} shouldCacheTarget:YES];
           }
       }
       if (manager.progress) {
           if ([manager isHideProgressHUDWhenSuccess]) {
               [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressHide" params:@{@"progress": manager.progress} shouldCacheTarget:YES];
           }else {
               [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressShow" params:@{@"progress": manager.progress, @"content":msg?msg:@"", @"view": [manager progressSuperView]} shouldCacheTarget:YES];
           }
       }
    }else {
        if ([code integerValue] > 10000) {
            NSInteger value = [code integerValue] / 10000 % 10000;
            BOOL isSystemError = value == 1;
            if (!isSystemError) {
                #if RELEASE
                //记录异常
                    NSString *name = [manager methodName];
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    
                    NSDictionary*jsonDict = [NSJSONSerialization JSONObjectWithData:response.request.HTTPBody options:NSJSONReadingMutableLeaves error:nil];

                    [userInfo setObject:jsonDict?jsonDict:@"" forKey:@"requestJson"];
                    [userInfo setObject:response.request.URL.absoluteString forKey:@"url"];
                    [userInfo setObject:data?data:@"" forKey:@"responseJson"];
                    
    //                [Bugly reportExceptionWithCategory:3 name:name reason:msg callStack:@[] extraInfo:userInfo terminateApp:NO];
                    [Bugly reportException:[NSException exceptionWithName:name reason:msg userInfo:userInfo]];
                    msg = @"网络异常";
                #endif
                
            }
        }
       if (manager.progress) {
           if ([manager isShowProgressHUDWhenFailed]) {
               [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressShow" params:@{@"progress": manager.progress, @"content":msg?msg:@"", @"view": [manager progressSuperView]} shouldCacheTarget:YES];
           }else {
               [[CTMediator sharedInstance] performTarget:@"apiHelp" action:@"progressHide" params:@{@"progress": manager.progress} shouldCacheTarget:YES];
           }
       }
    }
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
           return NO;
    }
    return YES;
}


- (NSMutableArray *)apiPool {
    if (!_apiPool) {
        _apiPool = [NSMutableArray array];
    }
    return _apiPool;
}



@end
