//
//  Target_networkconfiguration.h
//  MJNetWorkKit_Example
//
//  Created by manjiwang on 2018/12/28.
//  Copyright © 2018 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_networkconfiguration : NSObject

- (id)Action_apiBaseUrl:(NSDictionary *)params;

- (id)Action_gatewayKey:(NSDictionary *)params;

- (id)Action_publicKey:(NSDictionary *)params;

- (id)Action_privateKey:(NSDictionary *)params;

- (id)Action_extraParmas:(NSDictionary *)params;

- (id)Action_extraHttpHeadParmas:(NSDictionary *)params;

- (id)Action_loginFailureCode:(NSDictionary *)params;

- (id)Action_resetLogin:(NSDictionary *)params;

- (id)Action_codeString:(NSDictionary *)params;

- (id)Action_messageString:(NSDictionary *)params;

- (id)Action_dataString:(NSDictionary *)params;

- (id)Action_normalResultsCode:(NSDictionary *)params;

- (id)Action_otherFailure:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
