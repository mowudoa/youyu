//
//  HZDSLoginViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/8.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSLoginViewController.h"
#import "HZDSForgetPassWordViewController.h"
#import "HZDSRegisterViewController.h"
#import "XTBaseTabBarViewController.h"
#import "HZDSMineViewController.h"
#import "WXApi.h"

@interface HZDSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation HZDSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self initUI];
    
}
-(void)initUI
{
   
    [WYFTools viewLayer:_loginButton.height/16*9 withView:_loginButton];
    
}
//注册
- (IBAction)clickRegister:(UIButton *)sender {

    HZDSRegisterViewController *regis = [[HZDSRegisterViewController alloc] init];
    
    [self.navigationController pushViewController:regis animated:YES];
}
//忘记密码
- (IBAction)clickForgetPassWord:(UIButton *)sender {

    HZDSForgetPassWordViewController *pass = [[HZDSForgetPassWordViewController alloc] init];
    
    pass.request_url = GETNEWPASSWORD;
    
    [self.navigationController pushViewController:pass animated:YES];
    
}
//登录
- (IBAction)clickLogin:(UIButton *)sender {


    if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"帐号不可为空"];
    
    }else if ([_passWordTextField.text isEqualToString:@""] || [_passWordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"密码不可为空"];
        
    }else{
        
        NSDictionary *urlDict = @{@"account":_phoneTextField.text,
                                  @"password":_passWordTextField.text};
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,LOGIN] parameters:urlDict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"登录", dic);
            
            if (SUCCESS) {
               
                [JKToast showWithText:dic[@"datas"][@"msg"]];

                [USER_DEFAULT setBool:YES forKey:@"isLogin"];
                
                //登录成功获取用户信息,主要是拿到user_id
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getUserINfo" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];

            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }

}
//退出登录页面(并不是退出登录)
- (IBAction)closeLoginClick:(UIButton *)sender {
    
    [YY_APPDELEGATE.tabBarControll joinBaseController:0];
    
    for (UIViewController *viewcontrollview in self.navigationController.viewControllers) {
        
        if (![viewcontrollview isKindOfClass:[HZDSMineViewController class]]) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
 //   [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (IBAction)wxLogin:(UIButton *)sender {

    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
     
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        
        [WXApi sendReq:req];//发起微信授权请求
        
    }else{
        
        [JKToast showWithText:@"请安装微信客户端"];
        
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
