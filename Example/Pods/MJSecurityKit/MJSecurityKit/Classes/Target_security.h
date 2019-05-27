//
//  Target_security.h
//  MJSecurityKit
//
//  Created by manjiwang on 2019/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_security : NSObject

- (id)Action_encrypt:(NSDictionary *)params;

- (id)Action_decrypt:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
