//
//  HZDSUserInfoViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSUserInfoViewController.h"
#import "HZDSUploadHeadImageViewController.h"
#import "HZDSChangeUserNameViewController.h"
#import "HZDSshopAddressViewController.h"

@interface HZDSUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation HZDSUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"账户信息";
    
    [self initData];
}
-(void)initData
{
    NSString *userStr = [NSString stringWithFormat:@"%@ ID:%@",[USER_DEFAULT objectForKey:@"nickname"],[USER_DEFAULT objectForKey:@"User_ID"]];
    
    _userName.text = userStr;
    
}
- (IBAction)uploadHeadImage:(UIButton *)sender {


    HZDSUploadHeadImageViewController *upload = [[HZDSUploadHeadImageViewController alloc] init];
    
    [self.navigationController pushViewController:upload animated:YES];
}
- (IBAction)changeNickName:(UIButton *)sender {

    HZDSChangeUserNameViewController *name = [[HZDSChangeUserNameViewController alloc] init];
    
    [self.navigationController pushViewController:name animated:YES];
}
- (IBAction)shopAddress:(UIButton *)sender {

    HZDSshopAddressViewController *address = [[HZDSshopAddressViewController alloc] init];
    
    [self.navigationController pushViewController:address animated:YES];
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
