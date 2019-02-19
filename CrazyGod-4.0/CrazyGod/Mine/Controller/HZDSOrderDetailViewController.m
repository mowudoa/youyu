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

@end

@implementation HZDSOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"订单详情";
    
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
            
            strongSelf.orderTimer.text = [self ConvertStrToTime:dic[@"datas"][@"detail"][@"create_time"]];

            strongSelf.orderName.text = dic[@"datas"][@"detail"][@"tuan_title"];

            strongSelf.orderPrice.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"tuan_price"] stringValue]];

            strongSelf.orderNum.text = dic[@"datas"][@"detail"][@"num"];

            strongSelf.orderTotalPrice.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"total_price"] stringValue]];

            strongSelf.orderNeedPay.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"need_pay"] stringValue]];

        }else{
          
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
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
