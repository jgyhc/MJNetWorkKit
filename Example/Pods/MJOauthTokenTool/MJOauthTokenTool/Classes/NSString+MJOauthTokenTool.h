//
//  NSString+MJOauthTokenTool.h
//  MJOauthTokenTool_Example
//
//  Created by manjiwang on 2019/4/23.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MJOauthTokenTool)

- (NSString *)base64decode;

- (NSDictionary *)stringToDictionary;


@end

NS_ASSUME_NONNULL_END
