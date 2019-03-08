//
//  HZDSmerchantMoneyViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/13.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmerchantMoneyViewController.h"
#import "HZDSintegralCashViewController.h"
#import "HZDSingegralListViewController.h"
#import "HZDScashHistoryViewController.h"

@interface HZDSmerchantMoneyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *merchantIcon;

@property (weak, nonatomic) IBOutlet UILabel *merchantID;

@property (weak, nonatomic) IBOutlet UILabel *merchantglod;

@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@property (weak, nonatomic) IBOutlet UILabel *todayMoney;

@property (weak, nonatomic) IBOutlet UILabel *yesterdayMoney;

@end

@implementation HZDSmerchantMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self initUI];

    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"商家资金";
    
    [WYFTools viewLayer:_merchantIcon.height/2 withView:_merchantIcon];
    
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:MERCHANT_MONEY parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商家资金详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
           
           
            [strongSelf.merchantIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"SHOP"][@"logo"]]]];
  
            strongSelf.merchantID.text = [NSString stringWithFormat:@"ID:%@", dic[@"datas"][@"SHOP"][@"shop_id"]];
            
            strongSelf.merchantglod.text = [NSString stringWithFormat:@"当前余额:%@元",[dic[@"datas"][@"MEMBER"][@"gold"] stringValue]];

            strongSelf.totalMoney.text = [dic[@"datas"][@"counts"][@"money"] stringValue];

            strongSelf.yesterdayMoney.text = [dic[@"datas"][@"counts"][@"money_day_yesterday"] stringValue];

            strongSelf.todayMoney.text = [dic[@"datas"][@"counts"][@"money_day"] stringValue];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
- (IBAction)clickBtn:(UIButton *)sender {

    if (sender.tag == 101) {
        
        HZDSingegralListViewController *list = [[HZDSingegralListViewController alloc] init];
        
        list.myLogType = moneyLogType;
        
        list.logUrl = MERCHANT_MONEY_LIST;
        
        [self.navigationController pushViewController:list animated:YES];
        
    }else if (sender.tag == 102){
     
        HZDScashHistoryViewController *cash = [[HZDScashHistoryViewController alloc] init];
        
        cash.myCashLogType = moneyCashLogType;
        
        cash.logUrl = MERCHANT_MONEY_CASH_LIST;
        
        [self.navigationController pushViewController:cash animated:YES];
        
    }else if (sender.tag == 103){
        
        HZDSintegralCashViewController *cash = [[HZDSintegralCashViewController alloc] init];
        
        cash.myCashType = moneyCashType;
        
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
