//
//  HZDSGoRechargeViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/15.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSGoRechargeViewController.h"
#import "WXApi.h"

@interface HZDSGoRechargeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderId;

@property (weak, nonatomic) IBOutlet UILabel *orderMoney;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation HZDSGoRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifuchonggongWithRecharge:) name:@"zhifuchenggongWithRecharge" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifushibaiWithRecharge:) name:@"zhifushibaiWithRecharge" object:nil];
}
-(void)initUI
{
    [WYFTools viewLayer:_payButton.height/16*3 withView:_payButton];
    
    _orderId.text = [_payInfo[@"log_id"] stringValue];
    
    _orderMoney.text = [NSString stringWithFormat:@"￥%@",[_payInfo[@"need_pay"] stringValue]];
    
    self.navigationItem.title = @"余额充值";
    
}
- (IBAction)goPay:(UIButton *)sender {


    NSDictionary *dict = @{@"log_id":[_payInfo[@"log_id"] stringValue]
                           };
    
    [CrazyNetWork CrazyRequest_Post:PAY_WCHAT parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"微信支付", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            PayReq *req  = [[PayReq alloc] init];
            
            req.openID = dic[@"datas"][@"pay"][@"appid"];
            
            req.partnerId = dic[@"datas"][@"pay"][@"partnerid"];
            
            req.prepayId = dic[@"datas"][@"pay"][@"prepayid"];
            
            req.package = dic[@"datas"][@"pay"][@"package"];
            
            req.nonceStr = dic[@"datas"][@"pay"][@"noncestr"];
            
            req.timeStamp = [dic[@"datas"][@"pay"][@"timestamp"] intValue];
            
            req.sign = dic[@"datas"][@"pay"][@"sign"];
            
            //调起微信支付
            if ([WXApi sendReq:req]) {
                NSLog(@"吊起成功");
                
                [USER_DEFAULT setObject:@"3" forKey:@"payGoodsOrMall"];
            }
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

    
}
-(void)zhifuchonggongWithRecharge:(NSNotification*)userinfo
{
    [JKToast showWithText:@"支付成功"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)zhifushibaiWithRecharge:(NSNotification*)userinfo
{
    [JKToast showWithText:@"支付失败"];
        
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
