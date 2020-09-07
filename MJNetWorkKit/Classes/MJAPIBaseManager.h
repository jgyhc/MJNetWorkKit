//
//  MJAPIBaseManager.h
//  ManJi
//
//  Created by Zgmanhui on 2017/8/25.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import <CTNetworking/CTAPIBaseManager.h>
#import <CTNetworking/CTNetworkingDefines.h>


@protocol MJAPIBaseManagerDelegate <NSObject>

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data;

- (void)failManager:(CTAPIBaseManager *)manager;
@end

@interface MJAPIBaseManager : CTAPIBaseManager <CTAPIManager>

@property (nonatomic, weak) id<MJAPIBaseManagerDelegate> mj_delegate;

/** 是否加载 ShowProgressHUD   默认有的*/
- (BOOL)isShowProgressHUD;

/** 请求结果成功后  是否隐藏ProgressHUD  默认隐藏*/
- (BOOL)isHideProgressHUDWhenSuccess;

/** 请求结果失败后  是否提示ProgressHUD  默认提示 */
- (BOOL)isShowProgressHUDWhenFailed;

/** 请求参数加工 */
- (NSDictionary *)dealParams:(NSDictionary *)params;

/** 如果需要添加文字在loading上 */
- (NSString *)loadingText;

/** 数据加工 不建议在这里进行数据转模型的操作 */
- (id)dataProcessing:(id)data;

/** 缓存名 */
- (NSString *)cacheName;

/** 是否使用路径缓存 默认NO */
- (BOOL)isCachePath;

/** 缓存路径 */
- (NSString *)cachePath;

/** 是否用yycache缓存接口数据 */
- (BOOL)isYyCache;

/** 请求失败 或者返回结果异常时 是否返回缓存数据   该功能暂不实现 */
- (BOOL)isReturnCacheDataWhenFailed;

/** ProgressHUD的父视图  默认是window */
- (UIView *)progressSuperView;

/** 是否检查token是否有效 默认不检查 */
- (BOOL)isCheckToken;

/** rsa参数加密的公钥 */
- (NSString *)rsaPublicKey;

/** 是否要对参数进行rsa加密 */
- (BOOL)isNeedFieldEncrypted;

- (NSArray *)encryptedFields;

@property (nonatomic, strong) id cache;

@property (nonatomic, strong) id progress;


@end
