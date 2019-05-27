//
//  MJAPIInterceptor.h
//  AFNetworking
//
//  Created by manjiwang on 2019/4/23.
//

#import <Foundation/Foundation.h>
#import "CTNetworkingDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJAPIInterceptor : NSObject<CTAPIManagerInterceptor>

+ (instancetype)sharedInstance;



@end

NS_ASSUME_NONNULL_END
