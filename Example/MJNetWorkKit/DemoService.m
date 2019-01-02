//
//  DemoService.m
//  MJNetWorkKit_Example
//
//  Created by manjiwang on 2019/1/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "DemoService.h"

@implementation DemoService

/** baseUrl */
- (NSString *)apiBaseUrl {
    return @"http://192.168.0.30:8769";
}

/** 网关 */
- (NSString *)apiGatewayKey {
    return @"apphomepage";
}

/** 正常结果的code值 */
- (NSInteger)normalResultsCode {
    return 1;
}

/** 状态码默认的key */
- (NSString *)codeString {
    return @"code";
}

/** 结果说明 默认的key*/
- (NSString *)descString {
    return @"desc";
}

/** 数据默认的key */
- (NSString *)dataString {
    return @"data";
}

@end
