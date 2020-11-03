//
//  MJService.m
//  CTNetworking
//
//  Created by Zgmanhui on 2017/8/25.
//  Copyright © 2017年 Long Fan. All rights reserved.
//

#import "MJService.h"
#import <AFNetworking/AFNetworking.h>
#import "CTNetworking.h"
#import <CTMediator/CTMediator.h>
//#import "TTUserInstance.h"

@interface MJService ()<CTServiceProtocol>

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@property (nonatomic, weak) id<CTServiceProtocol> child;
@end

@implementation MJService
@dynamic apiEnvironment;

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(CTServiceProtocol)]) {
            self.child = (id<CTServiceProtocol>)self;
        }
    }
    return self;
}

#pragma mark - CTServiceProtocal
- (NSString *)apiBaseUrl {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"apiBaseUrl" params:nil shouldCacheTarget:YES];
}

- (NSString *)apiGatewayKey {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"gatewayKey" params:nil shouldCacheTarget:YES];
}

- (NSString *)publicKey {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"publicKey" params:nil shouldCacheTarget:YES];
}

- (NSString *)privateKey {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"privateKey" params:nil shouldCacheTarget:YES];
}

//为某些Service需要拼凑额外字段到URL处
//- (NSDictionary *)extraParmas {
//    return nil;
//}

//为某些Service需要拼凑额外的HTTPToken，如accessToken
- (NSDictionary *)extraHttpHeadParmas {
    NSDictionary *dic = [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"extraHttpHeadParmas" params:nil shouldCacheTarget:YES];
    return dic;
}

- (NSInteger)loginFailureCode {
    NSInteger code = [[[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"loginFailureCode" params:nil shouldCacheTarget:YES] integerValue];
    return code;
}

- (NSInteger)normalResultsCode {
    return [[[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"normalResultsCode" params:nil shouldCacheTarget:YES] integerValue];
}

/** 状态码默认的key */
- (NSString *)codeString {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"codeString" params:nil shouldCacheTarget:YES];
}

/** 结果说明 默认的key*/
- (NSString *)descString {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"messageString" params:nil shouldCacheTarget:YES];
}

/** 数据默认的key */
- (NSString *)dataString {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"dataString" params:nil shouldCacheTarget:YES];
}

/** cer证书的路径 */
- (NSString *)certificatesPath {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"certificatesPath" params:nil shouldCacheTarget:YES];
}

- (NSString *)clientAuthenticationPath {
    return [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"clientAuthenticationPath" params:nil shouldCacheTarget:YES];
}

- (BOOL)isAddSecurityPolicy {
    return [[[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"isAddSecurityPolicy" params:nil shouldCacheTarget:YES] boolValue];
}

#pragma mark - public methods
- (NSURLRequest *)requestWithParams:(NSDictionary *)params methodName:(NSString *)methodName requestType:(CTAPIManagerRequestType)requestType {
    NSString *urlString = [self urlGeneratingRuleByMethodName:methodName];
    NSString *method = @"POST";
    switch (requestType) {
        case CTAPIManagerRequestTypePost:
            method = @"POST";
            break;
        case CTAPIManagerRequestTypeGet:
            method = @"GET";
            break;
        case CTAPIManagerRequestTypePut:
            method = @"PUT";
            break;
        case CTAPIManagerRequestTypeDelete:
            method = @"DELETE";
            break;
        default:
            break;
    }

    NSDictionary *httpHeadParmas = [self extraHttpHeadParmas];
    if (httpHeadParmas) {
        [httpHeadParmas enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.httpRequestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:method
                                                                       URLString:urlString
                                                                      parameters:params
                                                                           error:nil];
    
    if (![method isEqualToString:@"GET"]) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    }
    request.actualRequestParams = params;
//    request.originRequestParams = params;
    return request;
}

- (NSString *)urlGeneratingRuleByMethodName:(NSString *)methodName {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.apiBaseUrl, methodName];
    if (self.apiGatewayKey.length > 0) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@", self.apiBaseUrl, self.apiGatewayKey, methodName];
    }
    return urlString;
}

- (NSDictionary *)resultWithResponseObject:(id)responseObject response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError **)error {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if (!responseObject) {
        return result;
    }
    if ([responseObject isKindOfClass:[NSData class]]) {
        result[kCTApiProxyValidateResultKeyResponseString] = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        result[kCTApiProxyValidateResultKeyResponseObject] = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
    } else {
        //这里的kCTApiProxyValidateResultKeyResponseString是用作打印日志用的，实际使用时可以把实际类型的对象转换成string用于日志打印
        //        result[kCTApiProxyValidateResultKeyResponseString] = responseObject;
        result[kCTApiProxyValidateResultKeyResponseObject] = responseObject;
    }
    NSInteger code = [[responseObject objectForKey:[self codeString]] integerValue];
    if (code == [self loginFailureCode]) {
        [[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"resetLogin" params:nil shouldCacheTarget:YES];
    }
    return result;
}

- (BOOL)handleCommonErrorWithResponse:(CTURLResponse *)response manager:(CTAPIBaseManager *)manager errorType:(CTAPIManagerErrorType)errorType {
    NSInteger code = [[response.content objectForKey:[self codeString]] integerValue];
    if (code == [self loginFailureCode]) {
        return [[[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"resetLogin" params:nil shouldCacheTarget:YES] boolValue];
    }else {
        return [[[CTMediator sharedInstance] performTarget:@"networkconfiguration" action:@"otherFailure" params:nil shouldCacheTarget:YES] boolValue];
    }
    return YES;
}

- (AFSecurityPolicy*)getSecurityPolicy {
    NSString *cerPath = [self certificatesPath];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    if (certData) {
        NSSet *certSet = [NSSet setWithObject:certData];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        policy.pinnedCertificates = certSet;
        return policy;
    }
    /**** SSL Pinning ****/
    return nil;
}

- (AFHTTPSessionManager *)sessionManager {
    AFHTTPSessionManager *manager = nil;
    NSURL *baseURL = [NSURL URLWithString:[self apiBaseUrl]];
    if (baseURL) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }else {
        manager = [AFHTTPSessionManager manager];
    }
    if ([[self apiBaseUrl] containsString:@"https"] && [self isAddSecurityPolicy]) {
        manager.securityPolicy = [self getSecurityPolicy];
    }
    return manager;
}



- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _httpRequestSerializer;
}

- (CTServiceAPIEnvironment)apiEnvironment {
    return CTServiceAPIEnvironmentRelease;
}

@end
