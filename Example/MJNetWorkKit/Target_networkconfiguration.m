//
//  Target_networkconfiguration.m
//  MJNetWorkKit_Example
//
//  Created by manjiwang on 2018/12/28.
//  Copyright © 2018 刘聪. All rights reserved.
//

#import "Target_networkconfiguration.h"

@implementation Target_networkconfiguration

- (id)Action_apiBaseUrl:(NSDictionary *)params {
    return @"https://zuul.manjiwangtest.com";
}

- (id)Action_gatewayKey:(NSDictionary *)params {
    return @"";
}

- (id)Action_publicKey:(NSDictionary *)params {
    return @"";
}

- (id)Action_privateKey:(NSDictionary *)params {
    return @"";
}

- (id)Action_extraParmas:(NSDictionary *)params {
    return @"";
}

- (id)Action_extraHttpHeadParmas:(NSDictionary *)params {
    return @{@"Content-Type":@"application/json", @"Accept": @"application/json"};
}

- (id)Action_loginFailureCode:(NSDictionary *)params {
    return @101;
}

- (id)Action_codeString:(NSDictionary *)params {
    return @"Code";
}

- (id)Action_messageString:(NSDictionary *)params {
    return @"Desc";
}

- (id)Action_dataString:(NSDictionary *)params {
    return @"Data";
}

- (id)Action_normalResultsCode:(NSDictionary *)params {
    return @1;
}

- (id)Action_resetLogin:(NSDictionary *)params {
    return @(NO);
}

- (id)Action_otherFailure:(NSDictionary *)params {
    return @(NO);
}

- (id)Action_certificatesPath:(NSDictionary *)params {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    return path;
}

- (id)Action_clientAuthenticationPath:(NSDictionary *)params {
    return [[NSBundle mainBundle] pathForResource:@"manjiwangtest" ofType:@"p12"];
}



@end
