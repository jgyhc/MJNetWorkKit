//
//  MJService.h
//  CTNetworking
//
//  Created by Zgmanhui on 2017/8/25.
//  Copyright © 2017年 Long Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJService : NSObject 

/** baseUrl */
- (NSString *)apiBaseUrl;

/** 网关 */
- (NSString *)apiGatewayKey;

/** 公钥 */
- (NSString *)publicKey;

/** 私钥 */
- (NSString *)privateKey;

/** 请求方需要添加的字段 */
- (NSDictionary *)extraHttpHeadParmas;

/** 是否需要重新登录 */
- (BOOL)isNeedReLoginWithCode:(NSInteger)code;

/** 是否需要刷新token */
- (BOOL)isRefreshTokenWithCode:(NSInteger)code;

/** 需要刷新token的错误码 */
- (NSInteger)refreshTokenCode;

/** 正常结果的code值 */
- (NSInteger)normalResultsCode;

/** 状态码默认的key */
- (NSString *)codeString;

/** 结果说明 默认的key*/
- (NSString *)descString;

/** 数据默认的key */
- (NSString *)dataString;

/** cer证书的路径 */
- (NSString *)certificatesPath;


@end
