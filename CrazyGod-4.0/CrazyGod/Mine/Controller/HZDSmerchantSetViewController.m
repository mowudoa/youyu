//
//  HZDSmerchantSetViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmerchantSetViewController.h"
#import "HZDSmerchantBaseInfoViewController.h"
#import "HZDSmerchantInameSetViewController.h"
#import "HZDSEmployeeViewController.h"

@interface HZDSmerchantSetViewController ()

@end

@implementation HZDSmerchantSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"商户设置";
}
- (IBAction)merchantSet:(UIButton *)sender {

    if (sender.tag == 200) {
        
        HZDSmerchantBaseInfoViewController *base = [[HZDSmerchantBaseInfoViewController alloc] init];
        
        [self.navigationController pushViewController:base animated:YES];
    
    }else if (sender.tag == 201){
       
        HZDSEmployeeViewController *employee = [[HZDSEmployeeViewController alloc] init];
        
        [self.navigationController pushViewController:employee animated:YES];
        
    }else{
        
        HZDSmerchantInameSetViewController *imageSet = [[HZDSmerchantInameSetViewController alloc] init];
        
        [self.navigationController pushViewController:imageSet animated:YES];
    }
    

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
