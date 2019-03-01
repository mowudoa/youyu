//
//  HZDSlinkUserPhoneViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/15.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSlinkUserPhoneViewController.h"

@interface HZDSlinkUserPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *linkButton;

@property(nonatomic,assign) NSInteger num;

@end

@implementation HZDSlinkUserPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
-(void)initUI
{
    self.navigationItem.title = @"绑定手机";
    
    _linkButton.layer.cornerRadius = _linkButton.frame.size.height/16*3;
    
    _linkButton.layer.masksToBounds = YES;
    
    _getCodeButton.layer.cornerRadius = _getCodeButton.frame.size.height/6;
    
    _getCodeButton.layer.masksToBounds = YES;
    
}
- (IBAction)getCode:(UIButton *)sender {

    if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"手机号不可为空"];
    
    }else {
        
        __weak typeof(self) weakSelf = self;
        
        
        NSDictionary *urlDic = @{@"mobile":_phoneTextField.text};
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",LINKUSER_GETCODE] parameters:urlDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"获取验证码", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                strongSelf.num = 60;
                
                [strongSelf.getCodeButton setTitle:[NSString stringWithFormat:@"(%ld)",(long)(strongSelf.num)] forState:UIControlStateNormal];
            strongSelf.getCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                
                [self jishiTimer];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
        
    }

}
//倒计时
-(void)jishiTimer
{
    _getCodeButton.enabled = NO;
    
    _num--;
    if (_num<1) {
        
        _getCodeButton.enabled = YES;
        
        [_getCodeButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        
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

- (IBAction)linkUserPhone:(UIButton *)sender {

    if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"帐号不可为空"];
    
    }else if ([_codeTextField.text isEqualToString:@""] || [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"验证码不可为空"];
   
    }else{
        
        NSDictionary *urlDict = @{@"mobile":_phoneTextField.text,
                                  @"scode":_codeTextField.text};
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",LINKUSER_PHONE] parameters:urlDict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"绑定新手机", dic);
            
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
