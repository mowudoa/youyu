//
//  HZDSIntegralViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/13.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSIntegralViewController.h"
#import "HZDSingegralListViewController.h"
#import "HZDSintegralCashViewController.h"
#import "HZDScashHistoryViewController.h"

@interface HZDSIntegralViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *meichantID;
@property (weak, nonatomic) IBOutlet UILabel *integralCurrent;
@property (weak, nonatomic) IBOutlet UILabel *totalIntegral;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayIntegral;
@property (weak, nonatomic) IBOutlet UILabel *todayIntegral;

@end

@implementation HZDSIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"商家积分";
    
    _headerIcon.layer.cornerRadius = _headerIcon.frame.size.height/2;
    
    _headerIcon.layer.masksToBounds = YES;
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:MERCHANT_INTEGRAL parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商家积分详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            
            [strongSelf.headerIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"SHOP"][@"photo"]]]];
            
            strongSelf.meichantID.text = [NSString stringWithFormat:@"ID:%@", dic[@"datas"][@"SHOP"][@"shop_id"]];
            
            strongSelf.integralCurrent.text = [NSString stringWithFormat:@"当前余额:%.2f积分",[dic[@"datas"][@"MEMBER"][@"shop_integral"] doubleValue]];
            
            strongSelf.totalIntegral.text = [NSString stringWithFormat:@"%.2f",[dic[@"datas"][@"counts"][@"money"] doubleValue]];
            
            strongSelf.yesterdayIntegral.text = [NSString stringWithFormat:@"%.2f",[dic[@"datas"][@"counts"][@"money_day_yesterday"] doubleValue]];
            
            strongSelf.todayIntegral.text = [NSString stringWithFormat:@"%.2f",[dic[@"datas"][@"counts"][@"money_day"] doubleValue]];
            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
- (IBAction)integralListButton:(UIButton *)sender {

    if (sender.tag == 101) {
    
        HZDSingegralListViewController *list = [[HZDSingegralListViewController alloc] init];
        
        
        list.myLogType = integralLogType;
        list.logUrl = INTEGRAL_LIST;
        
        [self.navigationController pushViewController:list animated:YES];
        
    }else if (sender.tag == 102){
     
        HZDScashHistoryViewController *cash = [[HZDScashHistoryViewController alloc] init];
        
        cash.myCashLogType = integralCashType;
        
        cash.logUrl = INTEGRSL_CASH_LIST;
        
        [self.navigationController pushViewController:cash animated:YES];
    }else if (sender.tag == 103){
        HZDSintegralCashViewController *cash = [[HZDSintegralCashViewController alloc] init];
        
        cash.myCashType = integralCashType;
        [self.navigationController pushViewController:cash animated:YES];
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
