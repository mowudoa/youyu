//
//  HZDSMerchantViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMerchantViewController.h"
#import "HZDSMallManagementViewController.h"
#import "HZDSmerchantMoneyViewController.h"
#import "HZDSmerchantOrderViewController.h"
#import "HZDScouponCheckViewController.h"
#import "HZDSmerchantSetViewController.h"
#import "HZDSNewMessageViewController.h"
#import "HZDSIntegralViewController.h"

@interface HZDSMerchantViewController ()

@property (weak, nonatomic) IBOutlet UILabel *merchangtMoney;

@property (weak, nonatomic) IBOutlet UILabel *todayMoney;

@property (weak, nonatomic) IBOutlet UILabel *yesterdayMoney;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *merchantName;

@property (weak, nonatomic) IBOutlet UIView *mallManageView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

@implementation HZDSMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"商户中心";
    
    [WYFTools viewLayer:_messageLabel.height/3 withView:_messageLabel];
    
    [WYFTools viewLayer:_headerImage.height/2 withView:_headerImage];
    
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;

    [CrazyNetWork CrazyRequest_Post:MERCHANT_CENTER parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商户中心", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (SUCCESS) {
            
            [strongSelf.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"SHOP"][@"logo"]]] placeholderImage:[UIImage imageNamed:@"1213per"]];

            strongSelf.merchantName.text = dic[@"datas"][@"SHOP"][@"shop_name"];
            
            
            strongSelf.merchangtMoney.text =[dic[@"datas"][@"gold"] stringValue];
            
            strongSelf.todayMoney.text =[dic[@"datas"][@"counts"][@"money_day"] stringValue];

            strongSelf.yesterdayMoney.text =[dic[@"datas"][@"counts"][@"money_day_yesterday"] stringValue];

            if ([dic[@"datas"][@"msg_day"] integerValue] > 0) {
                
                strongSelf.messageLabel.text = [NSString stringWithFormat:@"%@条",[dic[@"datas"][@"msg_day"] stringValue]];
             
                strongSelf.messageLabel.hidden = NO;
            }
            
        }
            
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
- (IBAction)merchantClick:(UIButton *)sender {

    if (sender.tag == 101) {
        
        HZDSmerchantSetViewController *set = [[HZDSmerchantSetViewController alloc] init];
        
        [self.navigationController pushViewController:set animated:YES];
        
    }else if (sender.tag == 102){
        
        HZDSNewMessageViewController *message = [[HZDSNewMessageViewController alloc] init];
        
        message.messageUrl = MERCHANT_MESSAGE;

        [self.navigationController pushViewController:message animated:YES];
        
    }else if (sender.tag == 103){
      
        HZDScouponCheckViewController *coupon = [[HZDScouponCheckViewController alloc] init];
        
        coupon.checkUrl = MERCHANT_COUPON_CHECK;
        
        [self.navigationController pushViewController:coupon animated:YES];
        
    }else if (sender.tag == 104){
     
        HZDSIntegralViewController *integral = [[HZDSIntegralViewController alloc] init];
        
        [self.navigationController pushViewController:integral animated:YES];
    
    }else if (sender.tag == 105){
       
        HZDSmerchantOrderViewController *order = [[HZDSmerchantOrderViewController alloc] init];
        
        order.OrderUrl = MERCHANT_ORDER;
        
        [self.navigationController pushViewController:order animated:YES];
       
    }
    
}
//商户资金
- (IBAction)businessMoney:(UIButton *)sender {
   
    HZDSmerchantMoneyViewController *money = [[HZDSmerchantMoneyViewController alloc] init];
    
    [self.navigationController pushViewController:money animated:YES];
    
}
//线上商家管理
- (IBAction)mallInfo:(UIButton *)sender {

    HZDSMallManagementViewController *management = [[HZDSMallManagementViewController alloc] init];
    
    [self.navigationController pushViewController:management animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[USER_DEFAULT objectForKey:@"xianshang"] isEqualToString:@"1"]) {
        
        _mallManageView.hidden = NO;
        
    }else{
        
        _mallManageView.hidden = YES;
    }
    
}
-(void)viewDidLayoutSubviews
{
    UIView* conView = (UIView*)[_myScrollView viewWithTag:2048];
    
    _myScrollView.contentSize = CGSizeMake(0, conView.frame.origin.y+conView.height + 10);
    
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
