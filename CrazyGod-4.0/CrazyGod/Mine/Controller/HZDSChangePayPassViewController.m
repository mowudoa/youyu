//
//  HZDSChangePayPassViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/16.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSChangePayPassViewController.h"

@interface HZDSChangePayPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPayPassWordTF;

@property (weak, nonatomic) IBOutlet UITextField *payPassWordTF;

@property (weak, nonatomic) IBOutlet UITextField *payPassWordTwo;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property(nonatomic,copy) NSString *phoneNumString;

@property(nonatomic,assign) NSInteger num;
@end

@implementation HZDSChangePayPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"修改支付密码";
    
    [WYFTools viewLayer:_changeButton.frame.size.height/16*3 withView:_changeButton];
    
    [WYFTools viewLayer:_getCodeButton.frame.size.height/6 withView:_changeButton];
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:CHANGEPAYPASS_INFO parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"修改支付密码详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.phoneNumString = dic[@"datas"][@"mobile"];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
- (IBAction)getCode:(UIButton *)sender {

    __weak typeof(self) weakSelf = self;
    
    NSDictionary *urlDic = @{@"mobile":_phoneNumString};
    [CrazyNetWork CrazyRequest_Post:TRANSACCOUNT_GETCODE parameters:urlDic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"获取验证码", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            strongSelf.num = 60;
            
            [strongSelf.getCodeButton setTitle:[NSString stringWithFormat:@"(%ld)",(long)(strongSelf.num)] forState:UIControlStateNormal];
       
            strongSelf.getCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            strongSelf.getCodeButton.enabled = NO;
            
            [self jishiTimer];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
//倒计时
-(void)jishiTimer
{
    _num--;
    if (_num<1) {
        _getCodeButton.enabled = YES;
       
        [_getCodeButton setTitle:[NSString stringWithFormat:@"立即获取"] forState:UIControlStateNormal];
        
        [_getCodeButton setBackgroundColor:[UIColor redColor]];
        
        return;
    }else
    {
        _getCodeButton.enabled = NO;
       
        [_getCodeButton setTitle:[NSString stringWithFormat:@"(%ldS)",(long)_num] forState:UIControlStateNormal];
        
        [_getCodeButton setBackgroundColor:[UIColor colorWithHexString:@"808080"]];
        
        [self performSelector:@selector(jishiTimer) withObject:nil afterDelay:1.0f];
        return;
    }
    
}

- (IBAction)cahngePayPass:(UIButton *)sender {

    if ([_oldPayPassWordTF.text isEqualToString:@""] || [_oldPayPassWordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"旧密码不可为空"];
        
    }else if ([_payPassWordTF.text isEqualToString:@""] || [_payPassWordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"新密码不可为空"];
    
    }else if ([_payPassWordTwo.text isEqualToString:@""] || [_payPassWordTwo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"密码不可为空"];
        
    }else if ([_codeTextField.text isEqualToString:@""] || [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"验证码不可为空"];
    
    }else{
     
        NSDictionary *urlDic = @{@"type":@"1",
                                 @"pay_password":_oldPayPassWordTF.text,
                                 @"new_pay_password":_payPassWordTF.text,
                                 @"new_pay_password2":_payPassWordTwo.text,
                                 @"yzm":_codeTextField.text};
       
        [CrazyNetWork CrazyRequest_Post:CHANGEPAYPASSWORD parameters:urlDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"修改密码", dic);
            
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
