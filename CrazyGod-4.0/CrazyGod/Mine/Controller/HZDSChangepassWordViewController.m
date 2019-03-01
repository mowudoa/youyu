//
//  HZDSChangepassWordViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/8.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSChangepassWordViewController.h"

@interface HZDSChangepassWordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (weak, nonatomic) IBOutlet UITextField *passWordTwo;

@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;

@end

@implementation HZDSChangepassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self iniUI];
}
-(void)iniUI
{
    self.navigationItem.title = @"修改密码";
    
    _changeButton.layer.cornerRadius = _changeButton.frame.size.height/16*3;
    
    _changeButton.layer.masksToBounds = YES;
    
}
- (IBAction)changePassWord:(UIButton *)sender {

  
    if ([_oldPassWord.text isEqualToString:@""] || [_oldPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
      
        [JKToast showWithText:@"旧密码不可为空"];
    
    }else if ([_passWord.text isEqualToString:@""] || [_passWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"新密码不可为空"];

    }else if ([_passWordTwo.text isEqualToString:@""] || [_passWordTwo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"再次输入密码不可为空"];
        
    }else if (![_passWord.text isEqualToString:_passWordTwo.text]){
        
        [JKToast showWithText:@"两次密码输入不一致"];

    }else{
        
        NSDictionary *dic = @{@"oldpwd":_oldPassWord.text,
                              @"newpwd":_passWord.text,
                              @"pwd2":_passWordTwo.text
                              };
        
        [CrazyNetWork CrazyRequest_Post:CHANGEPASS_LOGIN parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"更改登录密码", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
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
