//
//  MJOauthTokenTool.h
//  MJOauthTokenTool_Example
//
//  Created by manjiwang on 2019/4/22.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MJFailureBlock)(NSError * _Nullable error);
typedef void(^MJSuccessBlock)(id _Nullable obj);

//定义枚举类型
typedef enum NSUInteger {
    MJOauthTokenToolTokenNormal = 0,//正常
    MJOauthTokenToolTokenRefresh, //需要刷新
    MJOauthTokenToolTokenReLogin //需要重新授权
} MJOauthTokenToolTokenStatus;

@interface MJOauthTokenTool : NSObject

+ (instancetype)sharedInstance;

/**
 刷新token

 @param refreshToken refreshToken
 @param success success
 @param failure failure
 */
- (void)updateTokenWithRefreshToken:(NSString *)refreshToken success:(MJSuccessBlock)success failure:(MJFailureBlock)failure;


/**
 用户名密码方式获取token

 @param userName userName
 @param password password
 @param success success
 @param failure failure
 */
- (void)getTokenWithUserName:(NSString *)userName password:(NSString *)password success:(MJSuccessBlock)success failure:(MJFailureBlock)failure;


/**
 判断是否需要刷新token

 @param accessToken accessToken
 @param refreshToken refreshToken
 @return 需要处理状态 MJOauthTokenToolTokenNormal 表示token未过期不需要任何操作 MJOauthTokenToolTokenRefresh表示需要异步更新token token更新结果在success里  MJOauthTokenToolTokenReLogin表示需要用户重新授权不需要异步操作
 */
- (MJOauthTokenToolTokenStatus)isShouldRefreshWithAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;


@end

NS_ASSUME_NONNULL_END
