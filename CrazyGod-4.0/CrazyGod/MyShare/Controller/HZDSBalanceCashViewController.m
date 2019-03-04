//
//  HZDSBalanceCashViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/15.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSBalanceCashViewController.h"

@interface HZDSBalanceCashViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tagInfoLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyNum;

@property (weak, nonatomic) IBOutlet UITextField *bankName;

@property (weak, nonatomic) IBOutlet UITextField *bankNum;

@property (weak, nonatomic) IBOutlet UITextField *bankAddress;

@property (weak, nonatomic) IBOutlet UITextField *bankUser;

@property (weak, nonatomic) IBOutlet UIButton *cashButton;

@end

@implementation HZDSBalanceCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"余额提现";
    
    [WYFTools viewLayer:_cashButton.frame.size.height/16*3 withView:_cashButton];
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:MYBALANCE_CASHINFO parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"积分提现详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.tagInfoLabel.text = [NSString stringWithFormat:@"余额:%.2f  单笔最少:%@,最多%@",[dic[@"datas"][@"money"] doubleValue],dic[@"datas"][@"cash_money"],dic[@"datas"][@"cash_money_big"]];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
- (IBAction)submitCash:(UIButton *)sender {

    if ([_moneyNum.text isEqualToString:@""] || [_moneyNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"提现金额不可为空"];
        
    }else if ([_bankName.text isEqualToString:@""] || [_bankName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"开户银行不可为空"];
        
    }else if ([_bankNum.text isEqualToString:@""] || [_bankNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"银行账号不可为空"];
        
    }else if ([_bankAddress.text isEqualToString:@""] || [_bankAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"具体支行 不可为空"];
        
    }else if ([_bankUser.text isEqualToString:@""] || [_bankUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"开户名不可为空"];
        
    }else{
        
        NSDictionary *dic = @{@"money":_moneyNum.text,
                              @"bank_name":_bankName.text,
                              @"bank_num":_bankNum.text,
                              @"bank_branch":_bankAddress.text,
                              @"bank_realname":_bankUser.text,
                              @"code":@"bank"
                              };
        
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",MYBALANCE_CASHSUBMIT] parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"余额申请提现", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];

            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
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
