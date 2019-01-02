//
//  Target_apiHelp.h
//  MJNetWorkKit_Example
//
//  Created by manjiwang on 2019/1/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_apiHelp : NSObject

- (id)Action_fieldPublicKey:(NSDictionary *)params;

- (id)Action_RSAEncryptor:(NSDictionary *)params;

- (id)Action_encryptorFields:(NSDictionary *)params;

- (id)Action_cacheData:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
