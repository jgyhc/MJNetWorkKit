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
    return nil;
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
