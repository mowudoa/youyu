//
//  HZDSMallOrderDetailViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/24.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMallOrderDetailViewController.h"

@interface HZDSMallOrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderCode;

@property (weak, nonatomic) IBOutlet UILabel *orderMoney;

@property (weak, nonatomic) IBOutlet UILabel *sendMoney;

@property (weak, nonatomic) IBOutlet UILabel *needPay;

@property (weak, nonatomic) IBOutlet UILabel *orderTime;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *sendAddress;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *expressLabel;

@end

@implementation HZDSMallOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initUI];
}
-(void)initUI
{
    
    if ([_order_Url isEqualToString:MALL_MANAGE_ORDERDETAIL]) {
        
        [self initMallOrder];
        
    }else if ([_order_Url isEqualToString:SHOPPING_MALL_ORDER_DETAIL]){
        
        [self iniData];
        
    }
    
    self.navigationItem.title = @"订单详情";

    [WYFTools viewLayer:_statusLabel.height/16*3 withView:_statusLabel];
}

-(void)iniData
{
  
    NSDictionary *dic = @{@"order_id":_order_Id};
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:_order_Url parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.statusLabel.text = dic[@"datas"][@"type"];
            
            strongSelf.orderTime.text = dic[@"datas"][@"detail"][@"create_time"];
            
            strongSelf.orderCode.text = dic[@"datas"][@"detail"][@"order_id"];
            
            strongSelf.orderMoney.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"total_price"] stringValue]];
            
            strongSelf.sendMoney.text = [dic[@"datas"][@"detail"][@"express_price"] stringValue];
            
            strongSelf.needPay.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"need_pay"] stringValue]];
            
            strongSelf.userName.text = dic[@"datas"][@"addarres"][@"xm"];
            
            strongSelf.phoneNum.text = dic[@"datas"][@"addarres"][@"tel"];
            
            strongSelf.sendAddress.text = [NSString stringWithFormat:@"%@%@",dic[@"datas"][@"addarres"][@"area_str"],dic[@"datas"][@"addarres"][@"info"]];

            NSString *expressName = nil;
       
            NSString *expressNum = nil;

            
            if (dic[@"datas"][@"express_name"] == NULL || dic[@"datas"][@"express_name"] == nil ||dic[@"datas"][@"express_name"] == [NSNull null]) {
                
                
            }else{
                
                expressName = dic[@"datas"][@"express_name"];

            }
            
            if (dic[@"datas"][@"express_number"] == NULL || dic[@"datas"][@"express_number"] == nil ||dic[@"datas"][@"express_number"] == [NSNull null]) {
                
                
            }else{
                
                expressNum = dic[@"datas"][@"express_number"];
            }
            
            if (expressName != nil) {
                
                strongSelf.expressLabel.text  =[NSString stringWithFormat:@"快递公司:%@ 快递单号:%@",expressName,expressNum];
            }
            
            strongSelf.sendAddress.adjustsFontSizeToFitWidth = YES;
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)initMallOrder
{
    
    NSDictionary *dic = @{@"order_id":_order_Id};
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:_order_Url parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.statusLabel.text = dic[@"datas"][@"types"][@"status"];
            
            strongSelf.orderTime.text = [self ConvertStrToTime:dic[@"datas"][@"detail"][@"create_time"]];
            
            strongSelf.orderCode.text = dic[@"datas"][@"detail"][@"order_id"];
            
            strongSelf.orderMoney.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"total_price"] stringValue]];
            
            strongSelf.sendMoney.text = [dic[@"datas"][@"detail"][@"express_price"] stringValue];
            
            strongSelf.needPay.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"detail"][@"need_pay"] stringValue]];
            
            strongSelf.userName.text = dic[@"datas"][@"Paddress"][@"xm"];
            
            strongSelf.phoneNum.text = dic[@"datas"][@"Paddress"][@"tel"];
            
            strongSelf.sendAddress.text = [NSString stringWithFormat:@"%@%@",dic[@"datas"][@"Paddress"][@"area_str"],dic[@"datas"][@"Paddress"][@"info"]];
            
            strongSelf.sendAddress.adjustsFontSizeToFitWidth = YES;
            
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
-(void)backBtn:(UIButton *)sender
{
    if ([_orderPay isEqualToString:@"OrderPay"]) {
     
        NSArray *arr = self.navigationController.viewControllers;
        
        [self.navigationController popToViewController:arr[arr.count - 3] animated:YES];
    }else{
        
        [super backBtn:sender];
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
