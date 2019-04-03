//
//  HZDSGoPayViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSGoPayViewController.h"
#import "HZDSOrderDetailViewController.h"
#import "WXApi.h"

@interface HZDSGoPayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *payId;

@property (weak, nonatomic) IBOutlet UILabel *payReason;

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *payMoney;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation HZDSGoPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
-(void)initUI
{
    _payId.text = _payTypeID;

    _payMoney.text = _payTypeMoney;
    
    _payTypeLabel.text = _payTypeName;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifuchonggong:) name:@"zhifuchenggong" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifushibai:) name:@"zhifushibai" object:nil];

    [WYFTools viewLayer:_payButton.height/16*3 withView:_payButton];
    
    self.navigationItem.title = @"确认支付";
    
}
- (IBAction)goPay:(UIButton *)sender {

    if ([_payTypeLabel.text isEqualToString:@"微信支付"]){
        
        NSDictionary *dict = @{@"log_id":_payTypeID
                               };
        
        [CrazyNetWork CrazyRequest_Post:PAY_WCHAT parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"微信支付", dic);
            
            if (SUCCESS) {
                
             //   [JKToast showWithText:dic[@"datas"][@"msg"]];
                
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
                    
                    [USER_DEFAULT setObject:@"0" forKey:@"payGoodsOrMall"];
                    
                    [USER_DEFAULT synchronize];
                    
                }
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
    
}
-(void)zhifuchonggong:(NSNotification*)userinfo
{
    [JKToast showWithText:@"支付成功"];
    
    HZDSOrderDetailViewController *detail = [[HZDSOrderDetailViewController alloc] init];
    
    detail.orderId = _OrderID;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}
-(void)zhifushibai:(NSNotification*)userinfo
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
