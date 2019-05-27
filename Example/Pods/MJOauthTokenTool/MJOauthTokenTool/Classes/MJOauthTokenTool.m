//
//  MJOauthTokenTool.m
//  MJOauthTokenTool_Example
//
//  Created by manjiwang on 2019/4/22.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJOauthTokenTool.h"
#import "CTMediator.h"
#import "AFNetworking.h"
#import "YYCache/YYCache.h"
#import "NSString+MJOauthTokenTool.h"
#import "NSDate+MJOauthTokenTool.h"

@interface MJOauthTokenTool ()

@property (nonatomic, copy) NSString * clientId;

@property (nonatomic, copy) NSString * scope;

@property (nonatomic, copy) NSString * clientVersion;
@end

@implementation MJOauthTokenTool

+ (instancetype)sharedInstance {
    static MJOauthTokenTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MJOauthTokenTool alloc] init];
        instance.scope = [[CTMediator sharedInstance] performTarget:@"MJOauthTokenConfiger" action:@"scope" params:nil shouldCacheTarget:YES];
        instance.clientVersion = [[CTMediator sharedInstance] performTarget:@"MJOauthTokenConfiger" action:@"clientVersion" params:nil shouldCacheTarget:YES];
    });
    return instance;
}

- (void)initConfigerWithlCientId:(NSString *)clientId {
    _clientId = clientId;
}


- (void)updateTokenWithRefreshToken:(NSString *)refreshToken success:(MJSuccessBlock)success failure:(MJFailureBlock)failure {
    NSString *url = [[CTMediator sharedInstance] performTarget:@"MJOauthTokenConfiger" action:@"refreshTokenUrl" params:nil shouldCacheTarget:YES];
    NSDictionary *params = @{@"refresh_token": refreshToken?refreshToken:@"",
                             @"grant_type":@"refresh_token"
                             };
    [self loadDataWithUrl:url params:params success:success failure:failure];
}

- (void)getTokenWithUserName:(NSString *)userName password:(NSString *)password success:(MJSuccessBlock)success failure:(MJFailureBlock)failure {
    
    NSString *publicKey = [[CTMediator sharedInstance] performTarget:@"MJOauthTokenConfiger" action:@"publicKey" params:nil shouldCacheTarget:YES];
    NSString *rsaPassword = [[CTMediator sharedInstance] performTarget:@"security" action:@"encrypt" params:@{@"string": password?password:@"", @"publicKey": publicKey} shouldCacheTarget:YES];
    
    NSDictionary *params = @{@"username": userName?userName:@"",
                             @"password": rsaPassword?rsaPassword:@"",
                             @"grant_type":@"password"
                             };
    [self getTokenWithParams:params success:success failure:failure];
}

- (void)getTokenWithParams:(NSDictionary *)params success:(MJSuccessBlock)success failure:(MJFailureBlock)failure {
    NSString *url = [[CTMediator sharedInstance] performTarget:@"MJOauthTokenConfiger" action:@"getTokenUrl" params:nil shouldCacheTarget:YES];
    [self loadDataWithUrl:url params:params success:success failure:failure];
}

- (void)loadDataWithUrl:(NSString *)url params:(NSDictionary *)params success:(MJSuccessBlock)success failure:(MJFailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    if (!_clientId) {
        _clientId = [[CTMediator sharedInstance] performTarget:@"MJOauthTokenConfiger" action:@"cientId" params:nil shouldCacheTarget:YES];
    }
    
    [parameters setObject:_clientId?_clientId:@"" forKey:@"client_id"];
    [parameters setObject:_scope?_scope:@"" forKey:@"scope"];
    NSLog(@"%@", parameters);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:nil error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html",@"text/javascript", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:self.clientVersion?self.clientVersion:@"" forHTTPHeaderField:@"ClientVersion"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else {
            success(responseObject);
        }
    }];
    [task resume];
}



- (MJOauthTokenToolTokenStatus)isShouldRefreshWithAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken {
    BOOL accessResult = [self parsingWithToken:accessToken];//
    if (accessResult) {//accessToken 已经过期
        BOOL refreshResult = [self parsingWithToken:refreshToken];
        if (refreshResult) {//refreshToken 已经过期 必须要要重新登录了
            return MJOauthTokenToolTokenReLogin;
        }else {//refreshToken没有过期这个时候就得去刷新
            return MJOauthTokenToolTokenRefresh;
        }
    }
    return MJOauthTokenToolTokenNormal;
}

/** 结果表示 是否已经过期 yes 表示过期  no表示m未过期 */
- (BOOL)parsingWithToken:(NSString *)token {
    NSArray *stringsArray = [token componentsSeparatedByString:@"."];
    if (stringsArray.count != 3) {
        NSLog(@"token不合法");
        return NO;
    }
    BOOL result = NO;
    NSString *validationString = [stringsArray[1] base64decode];
    NSDictionary *json = [validationString stringToDictionary];
    NSNumber *exp = [json objectForKey:@"exp"];
    if (exp) {
        NSDate *expirationTime = [NSDate convertStrToTimeWithDateString:[exp stringValue]];
        NSDate *befor5MintMinutes = [expirationTime getBeforMinuteTimeWith:5];
        NSDate *currentDate = [NSDate stringToDateWithString:@"2019-04-24 06:37:55"];
        NSComparisonResult comparisonResult = [currentDate compare:befor5MintMinutes];
//        NSLog(@"当前时间：%@   过期时间：%@", currentDate, befor5MintMinutes);
        if (comparisonResult == NSOrderedDescending) {
            return YES;
        }else {
            result = NO;
        }
    }
    return result;
}





@end
