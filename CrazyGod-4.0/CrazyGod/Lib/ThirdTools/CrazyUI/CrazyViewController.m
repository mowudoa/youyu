//
//  CrazyViewController.m
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "CrazyViewController.h"
#import "CrazyConfiguration.h"
#import "MJRefresh.h"
@interface CrazyViewController ()

@end

@implementation CrazyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
-(void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBlock:(CrazyBackBlock)block{
    self.backBlock = block;
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = [CrazyConfiguration sharedManager].backBtnImage_FRAME;
    [backBtn setImage:[UIImage imageNamed:[CrazyConfiguration sharedManager].backBtnImage_NAME]  forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(TBackAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
-(void)TBackAction{
    [CrazyNetWork CrazyHiddenHUD];
    self.backBlock();
}

-(void)pushNaviHiddenController:(UIViewController *)vc animated:(bool)animated{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:animated];
}
-(void)pushNaviShowController:(UIViewController *)vc animated:(bool)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:animated];
}
-(void)popNaviHiddenController:(bool)animated{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:animated];
}
-(void)popNaviShowController:(bool)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:animated];
}


@end
