//
//  HZDSForgetPassWordViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/8.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSForgetPassWordViewController.h"

@interface HZDSForgetPassWordViewController ()
{
    NSTimer* timer;

}
@property (weak, nonatomic) IBOutlet UIButton *getNewpassButton;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property(nonatomic,assign) NSInteger num;

@end

@implementation HZDSForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
-(void)initUI
{
    self.navigationItem.title = @"忘记密码";
    
    [WYFTools viewLayer:_getNewpassButton.frame.size.height/16*3 withView:_getNewpassButton];
    
    [WYFTools viewLayer:_codeButton.frame.size.height/6 withView:_codeButton];
    
}

- (IBAction)getCode:(UIButton *)sender {

    if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"手机号不可为空"];
    
    }else {
        
        __weak typeof(self) weakSelf = self;
        
        NSDictionary *urlDic = @{@"mobile":_phoneTextField.text};
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,GETNEWPASS_CODE] parameters:urlDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"获取验证码", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                strongSelf.num = 60;
               
                [strongSelf.codeButton setTitle:[NSString stringWithFormat:@"(%ld)",(long)(strongSelf.num)] forState:UIControlStateNormal];
            
                strongSelf.codeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                
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
    _codeButton.enabled = NO;
    
    _num--;
    
    if (_num<1) {
        
        _codeButton.enabled = YES;
        
        [_codeButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        
        [_codeButton setBackgroundColor:[UIColor redColor]];
        
        return;
    }else
    {
        _codeButton.enabled = NO;

        [_codeButton setTitle:[NSString stringWithFormat:@"(%ldS)",(long)_num] forState:UIControlStateNormal];

        [_codeButton setBackgroundColor:[UIColor colorWithHexString:@"808080"]];
        
        [self performSelector:@selector(jishiTimer) withObject:nil afterDelay:1.0f];
        
        return;
    }
    
}

- (IBAction)getNewPassWord:(UIButton *)sender {

    if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"帐号不可为空"];
    
    }else if ([_codeTextField.text isEqualToString:@""] || [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"验证码不可为空"];
    
    }else{
        
        NSDictionary *urlDict = @{@"mobile":_phoneTextField.text,
                                  @"scode":_codeTextField.text};
       
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,_request_url] parameters:urlDict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"获取新密码", dic);
            
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
