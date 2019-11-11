//
//  MJViewController.m
//  MJNetWorkKit
//
//  Created by 刘聪 on 12/25/2018.
//  Copyright (c) 2018 刘聪. All rights reserved.
//

#import "MJViewController.h"
#import "UserLoginAPI.h"

@interface MJViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (nonatomic, strong) UserLoginAPI * userLoginAPI;
@end

@implementation MJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    [self.userLoginAPI loadData];
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSLog(@"data = %@", data);
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return @{
      @"password" : @"n1zYau34qdJux4toawlDBTw4tC9QcQk\/M6na\/jBtK+wLLWVCiHqHcNPSScn6I5xGBWKLENMlU4SyLUNoDxo2zs29fadZtyJhLSi5F2DKmr7wvP8lwEXkgrA24B5E2aQ9a3CqgI56eWEMrGuZrPd0pVYgA40oMhHFSk+BTg361Rc=",
      @"code" : @"3333",
      @"mobile" : @"15923694353",
      @"device" : @"6.15.10",
      @"shareCode" : @""
    };
}

- (UserLoginAPI *)userLoginAPI {
    if (!_userLoginAPI) {
        _userLoginAPI = [[UserLoginAPI alloc] init];
        _userLoginAPI.mj_delegate = self;
        _userLoginAPI.paramSource = self;
    }
    return _userLoginAPI;
}

@end
