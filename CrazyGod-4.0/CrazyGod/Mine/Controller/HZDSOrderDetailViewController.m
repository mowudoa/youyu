//
//  HZDSOrderDetailViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSOrderDetailViewController.h"

@interface HZDSOrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderID;

@property (weak, nonatomic) IBOutlet UILabel *orderTimer;

@property (weak, nonatomic) IBOutlet UILabel *orderPrice;

@property (weak, nonatomic) IBOutlet UILabel *orderTotalPrice;

@property (weak, nonatomic) IBOutlet UILabel *orderNeedPay;

@property (weak, nonatomic) IBOutlet UILabel *orderName;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@end

@implementation HZDSOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"订单详情";
    
    [WYFTools viewLayer:5 withView:_orderStatusLabel];
    
    [self initData];
}
-(void)initData
{
    
    NSDictionary *dic = @{@"order_id":_orderId};

    __weak typeof(self) weakSelf = self;

    [CrazyNetWork CrazyRequest_Post:MY_ORDER_DETAIL parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (SUCCESS) {
            
            strongSelf.orderID.text = dic[@"datas"][@"detail"][@"order_id"];
            
            strongSelf.orderTimer.text = [WYFTools ConvertStrToTime:dic[@"datas"][@"detail"][@"create_time"] dateModel:@"yyyy-MM-dd HH:mm:ss" withDateMultiple:1];
            
            strongSelf.orderName.text = dic[@"datas"][@"detail"][@"tuan_title"];

            strongSelf.orderPrice.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"tuan_price"] stringValue]];

            strongSelf.orderNum.text = dic[@"datas"][@"detail"][@"num"];

            strongSelf.orderTotalPrice.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"total_price"] stringValue]];

            strongSelf.orderNeedPay.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"need_pay"] stringValue]];

            [self initStatusLabel:dic[@"datas"][@"detail"][@"status"]];
            
        }else{
          
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}

-(void)initStatusLabel:(NSString *)orderStatus
{
    
    if ([orderStatus isEqualToString:@"0"]) {
        
        _orderStatusLabel.text = @"待付款";
        
    }else if ([orderStatus isEqualToString:@"1"]){
        
        _orderStatusLabel.text = @"已付款";
        
    }else if ([orderStatus isEqualToString:@"8"]){
        
        _orderStatusLabel.text = @"已完成";
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
