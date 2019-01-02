//
//  Target_apiHelp.m
//  MJNetWorkKit_Example
//
//  Created by manjiwang on 2019/1/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "Target_apiHelp.h"
#import <YYCache/YYCache.h>
#import <MJProgressHUD/LCProgressHUD.h>

@implementation Target_apiHelp

- (id)Action_fieldPublicKey:(NSDictionary *)params {
    return @"";
}

- (id)Action_RSAEncryptor:(NSDictionary *)params {
    NSString *value = [params objectForKey:@"value"];
    NSString *publicKey = [params objectForKey:@"publicKey"];
    
//    [MJRSAEncryptor encryptString:value publicKey:publicKey]
    return @"";
}

- (id)Action_encryptorFields:(NSDictionary *)params {
    return @[@"password", @"payPassword", @"oldPassword", @"newPassword", @"newPayPassword", @"PayPassword", @"payWord"];
}

- (id)Action_cacheData:(NSDictionary *)params {
    id data = [params objectForKey:@"data"];
    NSString *dataString = [params objectForKey:@"dataString"];
    YYCache *cache = [params objectForKey:@"cache"];
    if (!cache) {
        BOOL isCachePath = [[params objectForKey:@"isCachePath"] boolValue];
        if (isCachePath) {
            NSString *cachePath = [params objectForKey:@"cachePath"];
            cache = [[YYCache alloc] initWithPath:cachePath];
        }else {
            NSString *cacheName = [params objectForKey:@"cacheName"];
            cache = [[YYCache alloc] initWithName:cacheName?cacheName:@"Base"];
        }
    }
    [cache setObject:data forKey:dataString];
    return cache;
}

- (id)Action_progress:(NSDictionary *)params {
    return [[LCProgressHUD alloc] init];
}


- (id)Action_progressHide:(NSDictionary *)params {
    LCProgressHUD *progress = [params objectForKey:@"progress"];
    [progress hide];
    return nil;
}

- (id)Action_progressShow:(NSDictionary *)params {
    LCProgressHUD *progress = [params objectForKey:@"progress"];
    if (!progress) {
        progress = [[LCProgressHUD alloc] init];
    }
    UIView *view = [params objectForKey:@"view"];
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    NSString *content = [params objectForKey:@"content"];
    if (content) {
        [LCProgressHUD showWithView:view content:content];
    }
    return progress;
}

- (id)Action_progressLoadingShow:(NSDictionary *)params {
    LCProgressHUD *progress = [params objectForKey:@"progress"];
    if (!progress) {
        progress = [[LCProgressHUD alloc] init];
    }
    UIView *view = [params objectForKey:@"view"];
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    NSString *content = [params objectForKey:@"content"];
    [LCProgressHUD showLoadingWithView:view content:content]
    return progress;
}


@end
