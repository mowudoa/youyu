//
//  HZDSintegralCashViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSintegralCashViewController.h"

@interface HZDSintegralCashViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankUserTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankAddress;
@property (weak, nonatomic) IBOutlet UITextField *bankNum;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *cashNum;
@property (weak, nonatomic) IBOutlet UILabel *shopUserName;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopIntegral;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;


@property(nonatomic,assign) NSInteger num;

@end

@implementation HZDSintegralCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
}
-(void)initUI
{
    
    _codeButton.layer.cornerRadius = _codeButton.frame.size.height/5;
    
    _codeButton.layer.masksToBounds = YES;
    
    _applyButton.layer.cornerRadius = _applyButton.frame.size.height/16*9;
    
    _applyButton.layer.masksToBounds = YES;
    
    if (_myCashType == moneyCashType) {
     
        [self initDataWithMoney];
        self.navigationItem.title = @"资金提现";

    }else{
        
        [self initData];

        self.navigationItem.title = @"积分提现";
    }
    
}
-(void)initData
{
   
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:GET_INTEGRAL_APPLY_INFO parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"积分提现详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            
            strongSelf.shopUserName.text = [NSString stringWithFormat:@"您好:%@", dic[@"datas"][@"MEMBER"][@"account"]];
            
            strongSelf.shopName.text = [NSString stringWithFormat:@"您的店铺:%@",dic[@"datas"][@"SHOP"][@"shop_name"] ];
            
            strongSelf.shopIntegral.text = [NSString stringWithFormat:@"可提现余额:%.2f",[dic[@"datas"][@"MEMBER"][@"shop_integral"] doubleValue]];
            
            strongSelf.phoneTextField.text = dic[@"datas"][@"MEMBER"][@"mobile"];
            
            strongSelf.tagLabel.text = [NSString stringWithFormat:@"单笔最少:%@,最多%@",dic[@"datas"][@"cash_money"],dic[@"datas"][@"cash_money_big"]];
            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
-(void)initDataWithMoney
{
 
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:MERCHANT_MONEY_APPLY_INFO parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"资金提现详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            
            strongSelf.shopUserName.text = [NSString stringWithFormat:@"您好:%@", dic[@"datas"][@"account"]];
            
            strongSelf.shopName.text = [NSString stringWithFormat:@"您的店铺:%@",dic[@"datas"][@"shop_name"] ];
            
            strongSelf.shopIntegral.text = [NSString stringWithFormat:@"可提现余额:%@",[dic[@"datas"][@"gold"] stringValue]];
            
         //   strongSelf.phoneTextField.text = dic[@"datas"][@"account"];
            
            strongSelf.tagLabel.text = [NSString stringWithFormat:@"单笔最少:%@,最多%@",dic[@"datas"][@"cash_money"],dic[@"datas"][@"cash_money_big"]];
            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
- (IBAction)getCode:(UIButton *)sender {

    if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"手机号不可为空"];
    }else {
        
        __weak typeof(self) weakSelf = self;
        
        
        NSDictionary *urlDic = @{@"mobile":_phoneTextField.text};
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",CASH_SENDCODE] parameters:urlDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"获取验证码", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                strongSelf.num = 60;
                [strongSelf.codeButton setTitle:[NSString stringWithFormat:@"(%ld)",(long)(strongSelf.num)] forState:UIControlStateNormal];
                strongSelf.codeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                strongSelf.codeButton.enabled = NO;
                
                [self jishiTimer];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
        
    }
    
}

- (IBAction)applySubmit:(UIButton *)sender {

    
    
    if (_myCashType == moneyCashType) {
        
        [self applySubmitWithMoney];
        
    }else{
        
        [self applySubmintWithIntegral];
        
    }
    
    
}
//倒计时
-(void)jishiTimer
{
    _num--;
    if (_num<1) {
        _codeButton.enabled = YES;
        [_codeButton setTitle:[NSString stringWithFormat:@"立即获取"] forState:UIControlStateNormal];
        //  [_codeButton setBackgroundImage:[UIImage imageNamed:@"QPHyanzhengma"] forState:UIControlStateNormal];
        
        [_codeButton setBackgroundColor:[UIColor redColor]];
        
        return;
    }else
    {
        _codeButton.enabled = NO;
        [_codeButton setTitle:[NSString stringWithFormat:@"(%ldS)",(long)_num] forState:UIControlStateNormal];
        // [_codeButton setBackgroundImage:[UIImage imageNamed:@"QPHyzmHui"] forState:UIControlStateNormal];
        [_codeButton setBackgroundColor:[UIColor colorWithHexString:@"808080"]];
        
        [self performSelector:@selector(jishiTimer) withObject:nil afterDelay:1.0f];
        return;
    }
    
}
-(void)applySubmitWithMoney
{
    
    if ([_cashNum.text isEqualToString:@""] || [_cashNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"提现金额不可为空"];
    }else if ([_bankName.text isEqualToString:@""] || [_bankName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"开户银行不可为空"];
        
        
    }else if ([_bankNum.text isEqualToString:@""] || [_bankNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"银行账号不可为空"];
        
        
    }else if ([_bankAddress.text isEqualToString:@""] || [_bankAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"具体支行 不可为空"];
        
        
    }else if ([_bankUserTextField.text isEqualToString:@""] || [_bankUserTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"开户名不可为空"];
        
        
    }else if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"手机号不可为空"];
        
        
    }else if ([_codeTextField.text isEqualToString:@""] || [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"验证码不可为空"];
        
        
    }else{
        
        NSDictionary *dic = @{@"gold":_cashNum.text,
                              @"bank_name":_bankName.text,
                              @"bank_num":_bankNum.text,
                              @"bank_branch":_bankAddress.text,
                              @"bank_realname":_bankUserTextField.text,
                              @"yzm":_codeTextField.text
                              };
        
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",MERCHANT_MONEY_APPLY] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"资金提现申请", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
}
-(void)applySubmintWithIntegral
{
    
    if ([_cashNum.text isEqualToString:@""] || [_cashNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"提现金额不可为空"];
    }else if ([_bankName.text isEqualToString:@""] || [_bankName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"开户银行不可为空"];
        
        
    }else if ([_bankNum.text isEqualToString:@""] || [_bankNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"银行账号不可为空"];
        
        
    }else if ([_bankAddress.text isEqualToString:@""] || [_bankAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"具体支行 不可为空"];
        
        
    }else if ([_bankUserTextField.text isEqualToString:@""] || [_bankUserTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"开户名不可为空"];
        
        
    }else if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"手机号不可为空"];
        
        
    }else if ([_codeTextField.text isEqualToString:@""] || [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        [JKToast showWithText:@"验证码不可为空"];
        
        
    }else{
        
        NSDictionary *dic = @{@"gold":_cashNum.text,
                              @"bank_name":_bankName.text,
                              @"bank_num":_bankNum.text,
                              @"bank_branch":_bankAddress.text,
                              @"bank_realname":_bankUserTextField.text,
                              @"yzm":_codeTextField.text
                              };
        
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",GET_INTEGRAL_APPLY] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"积分提现申请", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                
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
