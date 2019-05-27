//
//  NSDate+MJOauthTokenTool.h
//  MJOauthTokenTool_Example
//
//  Created by manjiwang on 2019/4/23.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MJOauthTokenTool)

/** 时间戳转时间 */
+ (NSDate *)convertStrToTimeWithDateString:(NSString *)dateString;

/** 字符串转时间 */
+ (NSDate *)stringToDateWithString:(NSString *)string;

/** 两个时间比较 anotherDate表示过期时间  date为标准时间  通常为当前时间 */
+ (BOOL)compareWithOneDate:(NSDate *)date anotherDate:(NSDate *)anotherDate;

/** 获取几分钟前的时间 */
- (NSDate *)getBeforMinuteTimeWith:(NSInteger)minute;
@end

NS_ASSUME_NONNULL_END
