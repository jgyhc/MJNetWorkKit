//
//  MJAppDelegate.m
//  MJNetWorkKit
//
//  Created by 刘聪 on 12/25/2018.
//  Copyright (c) 2018 刘聪. All rights reserved.
//

#import "MJAppDelegate.h"
#import <Bugly/Bugly.h>
#import <UMCommon/UMCommon.h>//友盟
//#import <UMCommonLog/UMCommonLogHeaders.h>
@interface MJAppDelegate ()<BuglyDelegate>

@end

@implementation MJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
        BuglyConfig *buglyConfig = [[BuglyConfig alloc] init];
        buglyConfig.debugMode = YES;
        buglyConfig.blockMonitorEnable = YES;
        buglyConfig.delegate = self;
        buglyConfig.reportLogLevel = BuglyLogLevelWarn;


        [Bugly startWithAppId:@"1b7b26f079" developmentDevice:YES config:buglyConfig];
    #pragma mark -- 友盟
//    [UMConfigure initWithAppkey:@"596c25581061d24e37000211" channel:@"App Store"];
    //开发者需要显式的调用此函数，日志系统才能工作
//    [UMCommonLogManager setUpUMCommonLogManager];
    return YES;
}

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
