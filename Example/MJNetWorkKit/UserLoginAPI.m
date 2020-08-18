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
- (NSString *)methodName
{
    return @"api/User/UserRegister";
}

- (NSString *_Nonnull)serviceIdentifier
{
    return @"DemoService";
}

- (CTAPIManagerRequestType)requestType
{
    return CTAPIManagerRequestTypePost;
}

- (BOOL)isShowProgressHUD {
    return NO;
}


@end
