//
//  HZDSMallManagementViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/28.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMallManagementViewController.h"
#import "HZDSMallGoodsManageViewController.h"
#import "HZDSMallOrderManageViewController.h"

@interface HZDSMallManagementViewController ()

@end

@implementation HZDSMallManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"商城管理";
}
- (IBAction)orderManage:(UIButton *)sender {

    HZDSMallOrderManageViewController *order = [[HZDSMallOrderManageViewController alloc] init];
    
    [self.navigationController pushViewController:order animated:YES];
}
- (IBAction)goodsManage:(UIButton *)sender {

    HZDSMallGoodsManageViewController *mallGoods = [[HZDSMallGoodsManageViewController alloc] init];
    
    [self.navigationController pushViewController:mallGoods animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
