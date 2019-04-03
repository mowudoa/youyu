//
//  XTBaseBackViewController.m
//  StarGroupBuying
//
//  Created by 英峰 on 2018/12/17.
//  Copyright © 2018年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"

@interface XTBaseBackViewController ()

@end

@implementation XTBaseBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBackButton];
}
-(void)initBackButton
{
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [backBtn setFrame:CGRectMake(0, 0, 25, 25)];
    
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setImage:[UIImage imageNamed:@"小于号"] forState:UIControlStateNormal];
    
    UIBarButtonItem* im = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = im;
    
}
-(void)backBtn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [YY_APPDELEGATE.tabBarControll.tabBar setHidden:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [YY_APPDELEGATE.tabBarControll.tabBar setHidden:NO];
    
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
