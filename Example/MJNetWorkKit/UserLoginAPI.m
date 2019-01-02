//
//  UserLoginAPI.m
//  MJNetWorkKit_Example
//
//  Created by manjiwang on 2019/1/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "UserLoginAPI.h"

@implementation UserLoginAPI

#pragma mark - CTAPIManager
- (NSString *)methodName {
    return @"api/appHome/queryAppHome";
}

- (NSString *_Nonnull)serviceIdentifier {
    return @"DemoService";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (id)dataProcessing:(id)data {
    return data;
}

- (NSDictionary *)dealParams:(NSDictionary *)params {
    return @{@"cityCode":@"500105",
             @"sessionId":@"e389daa9-6ca6-4971-93ff-2f3f11b98733"};
}


@end
