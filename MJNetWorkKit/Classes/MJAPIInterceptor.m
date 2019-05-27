//
//  MJAPIInterceptor.m
//  AFNetworking
//
//  Created by manjiwang on 2019/4/23.
//

#import "MJAPIInterceptor.h"
#import "MJAPIBaseManager.h"
#import "MJOauthTokenTool.h"

@interface MJAPIInterceptor ()

@property (nonatomic, strong) NSMutableArray * apiPool;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation MJAPIInterceptor

+ (instancetype)sharedInstance {
    static MJAPIInterceptor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MJAPIInterceptor alloc] init];
    });
    return instance;
}

- (BOOL)manager:(CTAPIBaseManager *_Nonnull)manager shouldCallAPIWithParams:(NSDictionary *_Nullable)params {
    MJAPIBaseManager *mjManager = (MJAPIBaseManager *)manager;
    if ([mjManager isCheckToken]) {
        __weak typeof(self) wself = self;
        MJOauthTokenToolTokenStatus status = [[MJOauthTokenTool sharedInstance] isShouldRefreshWithAccessToken:@"" refreshToken:@""];
        [self.apiPool removeAllObjects];
        if (status == MJOauthTokenToolTokenNormal) {
            return YES;
        }else if (status == MJOauthTokenToolTokenReLogin) {
            return NO;
        }else {
            [self.apiPool addObject:manager];
            if (self.isLoading) {
                return NO;
            }
            [[MJOauthTokenTool sharedInstance] updateTokenWithRefreshToken:@"" success:^(id  _Nullable obj) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MJRefreshTokenNotificationKey" object:obj userInfo:nil];
                for (CTAPIBaseManager *api in wself.apiPool) {
                    [api loadData];
                }
            } failure:^(NSError * _Nullable error) {
                
            }];
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)apiPool {
    if (!_apiPool) {
        _apiPool = [NSMutableArray array];
    }
    return _apiPool;
}

@end
