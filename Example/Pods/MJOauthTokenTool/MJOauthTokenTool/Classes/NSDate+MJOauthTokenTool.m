//
//  NSDate+MJOauthTokenTool.m
//  MJOauthTokenTool_Example
//
//  Created by manjiwang on 2019/4/23.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "NSDate+MJOauthTokenTool.h"

@implementation NSDate (MJOauthTokenTool)


/** 获取一个时间前几分钟的时间 */
- (NSDate *)getBeforMinuteTimeWith:(NSInteger)minute {
    //  先定义一个遵循某个历法的日历对象
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  定义一个NSDateComponents对象，设置一个时间段
    NSDateComponents *dateComponentsAsTimeQantum = [[NSDateComponents alloc] init];
    [dateComponentsAsTimeQantum setMinute:minute * -1];
    //  在当前历法下，获取一段时间段之后的时间
    NSDate *dateFromDateComponentsAsTimeQantum = [greCalendar dateByAddingComponents:dateComponentsAsTimeQantum toDate:self options:0];
    return dateFromDateComponentsAsTimeQantum;
}

- (NSDate *)dateComponentWithDate:(NSDate *)theDate {
    NSDate *currentDate = theDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    NSDate *date = [calendar dateFromComponents:dateComponent];
    return date;
}


+ (NSDate *)stringToDateWithString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:string];
    return datestr;
}

//时间戳变为格式时间
+ (NSDate *)convertStrToTimeWithDateString:(NSString *)dateString {
    long long time = [dateString longLongValue];
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    //    long long time=[timeStr longLongValue] / 1000;
    return [[NSDate alloc]initWithTimeIntervalSince1970:time];
}

+ (BOOL)compareWithOneDate:(NSDate *)date anotherDate:(NSDate *)anotherDate {
    NSComparisonResult result = [date compare:anotherDate];
    NSLog(@"date : %@, anotherDate : %@", date, anotherDate);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return YES;
    }
    return NO;
}

@end
