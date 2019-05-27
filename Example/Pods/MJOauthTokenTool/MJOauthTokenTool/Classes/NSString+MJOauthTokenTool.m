//
//  NSString+MJOauthTokenTool.m
//  MJOauthTokenTool_Example
//
//  Created by manjiwang on 2019/4/23.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "NSString+MJOauthTokenTool.h"

@implementation NSString (MJOauthTokenTool)

- (NSString *)base64decode {
    NSString *str = self;
    if (self.length == 0) {
        return @"";
    }
    str = [str stringByReplacingOccurrencesOfString:@"-"withString:@"+"];
    str = [str stringByReplacingOccurrencesOfString:@"_"withString:@"/"];
    switch (str.length  % 4) {
            case 2:
            str = [str stringByAppendingString:@"=="];
            break;
            case 3:
            str = [str stringByAppendingString:@"="];
            break;
            
        default:
            break;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}



- (NSDictionary *)stringToDictionary {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
