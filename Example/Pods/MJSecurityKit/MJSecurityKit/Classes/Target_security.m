//
//  Target_security.m
//  MJSecurityKit
//
//  Created by manjiwang on 2019/4/9.
//

#import "Target_security.h"
#import "MJRSAEncryptor.h"

@implementation Target_security

- (id)Action_encrypt:(NSDictionary *)params {
    NSString *str = [params objectForKey:@"string"];
    NSString *publicKey = [params objectForKey:@"publicKey"];
    return [MJRSAEncryptor encryptString:str publicKey:publicKey];
}

- (id)Action_decrypt:(NSDictionary *)params {
    NSString *str = [params objectForKey:@"string"];
    NSString *privKey = [params objectForKey:@"privKey"];
    return [MJRSAEncryptor decryptString:str privateKey:privKey];
}

@end
