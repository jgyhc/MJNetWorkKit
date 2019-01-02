//
//  Target_DemoService.m
//  MJNetWorkKit_Example
//
//  Created by manjiwang on 2019/1/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "Target_DemoService.h"
#import "DemoService.h"

@implementation Target_DemoService

- (DemoService *)Action_DemoService:(NSDictionary *)params {
    return [[DemoService alloc] init];
}


@end
