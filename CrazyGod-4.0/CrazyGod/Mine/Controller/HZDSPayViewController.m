//
//  HZDSPayViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSPayViewController.h"
#import "HZDSpayTypeTableViewCell.h"
#import "HZDSGoPayViewController.h"
#import "HZDSOrderModel.h"
#import "WXApi.h"

@interface HZDSPayViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *needPay;
@property (weak, nonatomic) IBOutlet UITableView *payTypeTableView;

@property(nonatomic,strong) NSMutableArray *payTypeDataSource;

@property(nonatomic,copy) NSString *payTypeString;

@property(nonatomic,copy) NSString *payNameString;

@end

@implementation HZDSPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"确认支付";

    _payTypeDataSource = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
}
-(void)initUI
{
    
    _payButton.layer.cornerRadius = _payButton.frame.size.height/16*9;
    
    _payButton.layer.masksToBounds = YES;
}
-(void)initData
{
    NSDictionary *dic = @{@"order_id":_orderId};
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:ORDER_PAY parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"确认支付", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.totalPrice.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"order"][@"total_price"] stringValue]];
            
            strongSelf.needPay.text = [NSString stringWithFormat:@"%@元",[dic[@"datas"][@"order"][@"total_price"] stringValue]];
            
            strongSelf.numLabel.text = dic[@"datas"][@"order"][@"num"];
            
            strongSelf.titleLabel.text = dic[@"datas"][@"tuan"][@"title"];
            
            strongSelf.phoneLabel.text = dic[@"datas"][@"mobile"];
            
            strongSelf.price.text = [NSString stringWithFormat:@"单价:%@元",[dic[@"datas"][@"tuan"][@"price"] stringValue]];
            
            NSArray *arr = dic[@"datas"][@"payment"];
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSOrderModel *order = [[HZDSOrderModel alloc] init];
                
                order.orderID = dict1[@"payment_id"];
                order.orderTitle = dict1[@"name"];
                order.orderStatus = dict1[@"code"];
                order.orderImage = dict1[@"mobile_logo"];
                
                [strongSelf.payTypeDataSource addObject:order];
            }
            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        [strongSelf.payTypeTableView reloadData];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)registercell
{
    
    UINib* nib = [UINib nibWithNibName:@"HZDSpayTypeTableViewCell" bundle:nil];
    [_payTypeTableView registerNib:nib forCellReuseIdentifier:@"payTypeTableViewCell"];
    
}
- (IBAction)pay:(UIButton *)sender {

    if (_payTypeString == nil) {
        
        [JKToast showWithText:@"请选择支付方式"];
    }else{
        
        NSDictionary *dict = @{@"order_id":_orderId,
                               @"code":_payTypeString
                               };
        
        [CrazyNetWork CrazyRequest_Post:ORDER_PAY_UPLOAD parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"支付", dic);
            
            if (SUCCESS) {
              
            [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                
                
                [self gopay:[dic[@"datas"][@"log_id"] stringValue]];
                
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
    
    
}
-(void)gopay:(NSString *)str
{
    
    if ([_payNameString isEqualToString:@"微信支付"]) {
        
        if (![WXApi isWXAppInstalled]) {
            
            [JKToast showWithText:@"请安装微信"];
        }
        
    }
    
    HZDSGoPayViewController *gopay = [[HZDSGoPayViewController alloc] init];
    
    gopay.payType = _payTypeString;
    
    gopay.payTypeID = str;
    
    gopay.OrderID = _orderId;
    
    gopay.payTypeMoney = _needPay.text;
    
    gopay.payTypeName = _payNameString;
    
    [self.navigationController pushViewController:gopay animated:YES];
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _payTypeDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZDSpayTypeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"payTypeTableViewCell" forIndexPath:indexPath];
    
    HZDSOrderModel *order = _payTypeDataSource[indexPath.row];
    
    cell.payName.text = order.orderTitle;
    
    [cell.payImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,order.orderImage]]];
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HZDSpayTypeTableViewCell *celled = [tableView cellForRowAtIndexPath:indexPath];

    celled.payButton.selected = YES;
    
    HZDSOrderModel *order = _payTypeDataSource[indexPath.row];

    _payTypeString = order.orderStatus;
    
    _payNameString = order.orderTitle;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
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
