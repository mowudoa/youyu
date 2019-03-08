//
//  HZDSBalanceRechargeViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/15.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSBalanceRechargeViewController.h"
#import "HZDScashHistoryViewController.h"
#import "HZDSBalanceCashViewController.h"
#import "HZDSGoRechargeViewController.h"
#import "HZDSLogListViewController.h"
#import "HZDSpayTypeTableViewCell.h"
#import "HZDSOrderModel.h"
#import "WXApi.h"


@interface HZDSBalanceRechargeViewController ()<
UITableViewDelegate,
UITableViewDataSource,
selectedBtnDelagate
>
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIView *moneyView;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UITableView *payTypeTableView;

@property(nonatomic,strong) NSMutableArray *payTypeDataSource;

@property(nonatomic,copy) NSString *payTypeString;

@end

@implementation HZDSBalanceRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self registercell];
    
}
-(void)initUI
{
    self.navigationItem.title = @"我的余额";
    
    _payTypeDataSource = [[NSMutableArray alloc] init];
    
    [WYFTools viewLayer:_rechargeButton.height/16*3 withView:_rechargeButton];
}
-(void)registercell
{
    
    UINib* nib = [UINib nibWithNibName:@"HZDSpayTypeTableViewCell" bundle:nil];
    
    [_payTypeTableView registerNib:nib forCellReuseIdentifier:@"payTypeTableViewCell"];
    
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:MY_BALANCE parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"我的余额界面", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.payTypeDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            strongSelf.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[dic[@"datas"][@"money"] stringValue]];
            
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
//充值
- (IBAction)recharge:(UIButton *)sender {
    
    if ([_moneyTextField.text isEqualToString:@""] || [_moneyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"请输入充值金额"];
        
    }else if (_payTypeString == nil) {
        
        [JKToast showWithText:@"请选择支付方式"];
        
    }else{
        
        NSDictionary *dict = @{@"money":_moneyTextField.text,
                               @"code":_payTypeString
                               };
        
        [CrazyNetWork CrazyRequest_Post:MYBALANCE_RECHARGE parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"支付", dic);
            
            if (SUCCESS) {
                
                HZDSGoRechargeViewController *rechage = [[HZDSGoRechargeViewController alloc] init];
                
                rechage.payInfo = dic[@"datas"][@"logs"];
                
                [self.navigationController pushViewController:rechage animated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
    
}

//提现/日志/提现日志
- (IBAction)cashOrLogClick:(UIButton *)sender {

    if (sender.tag == 101) {
     
        HZDSBalanceCashViewController *cash = [[HZDSBalanceCashViewController alloc] init];
        
        [self.navigationController pushViewController:cash animated:YES];
        
    }else if (sender.tag == 102){
     
        HZDScashHistoryViewController *cash = [[HZDScashHistoryViewController alloc] init];
        
        cash.logUrl = MYBALANCE_CASHLIST;
        
        [self.navigationController pushViewController:cash animated:YES];
        
    }else if (sender.tag == 103){
        
        HZDSLogListViewController *logList = [[HZDSLogListViewController alloc] init];
        
        [self.navigationController pushViewController:logList animated:YES];
        
    }
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
    
    cell.payButton.tag = indexPath.row;
    
    cell.delegate = self;
    
    [cell.payImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,order.orderImage]]];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self changeButtonStatusWithTableviewcell:indexPath.row];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];

    [self checkWchatInstall];
    
    _moneyTextField.text = @"";
}
-(void)checkWchatInstall
{
    if (![WXApi isWXAppInstalled]) {
        
        _moneyView.hidden = YES;
        
        _payTypeTableView.hidden = YES;
        
        _rechargeButton.hidden = YES;
        
    }else{
        
        _moneyView.hidden = NO;
        
        _payTypeTableView.hidden = NO;
        
        _rechargeButton.hidden = NO;
    }
}
#pragma mark SelectedButtonDelegate

-(void)selectedButton:(NSInteger)index
{
   
    [self changeButtonStatusWithTableviewcell:index];
    
}

-(void)changeButtonStatusWithTableviewcell:(NSInteger)index
{
 
    NSArray *visibleCells = [_payTypeTableView visibleCells];
    
    for (HZDSpayTypeTableViewCell *cell in visibleCells){
        
        cell.payButton.selected = NO;
        
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    HZDSpayTypeTableViewCell *celled = [_payTypeTableView cellForRowAtIndexPath:indexPath];
    
    celled.payButton.selected = YES;
    
    HZDSOrderModel *order = _payTypeDataSource[index];
    
    _payTypeString = order.orderStatus;
    
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
