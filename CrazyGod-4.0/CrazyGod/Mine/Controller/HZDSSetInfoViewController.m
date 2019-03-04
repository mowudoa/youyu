//
//  HZDSSetInfoViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/8.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSSetInfoViewController.h"
#import "HZDSTransferAccountsViewController.h"
#import "HZDSBalanceRechargeViewController.h"
#import "HZDSChangepassWordViewController.h"
#import "HZDSForgetPassWordViewController.h"
#import "HZDSAuthenticationViewController.h"
#import "HZDSChangePayPassViewController.h"
#import "HZDSlinkUserPhoneViewController.h"
#import "HZDSLogListViewController.h"
#import "WXApi.h"

@interface HZDSSetInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *userPhoneButton;

@property (weak, nonatomic) IBOutlet UIButton *linkWChatButton;

@property (weak, nonatomic) IBOutlet UIButton *exitLoginButton;

@property (weak, nonatomic) IBOutlet UIButton *authenticationButton;

@end

@implementation HZDSSetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initData
{
  
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:GETUSERINFO parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"个人信息", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
           
        [strongSelf.userPhoneButton setTitle:dic[@"datas"][@"mobile"] forState:UIControlStateNormal];
        
        if (dic[@"datas"][@"renzheng"] == NULL || dic[@"datas"][@"renzheng"] == nil ||dic[@"datas"][@"renzheng"] == [NSNull null]) {
            
        strongSelf.authenticationButton.userInteractionEnabled = YES;
            
            [strongSelf.authenticationButton setTitle:@"未认证" forState:UIControlStateNormal];
            
            [strongSelf.authenticationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            }else{
                
            strongSelf.authenticationButton.userInteractionEnabled = NO;

                [strongSelf.authenticationButton setTitle:@"已认证" forState:UIControlStateNormal];

                [strongSelf.authenticationButton setTitleColor:[UIColor colorWithHexString:@"#1ec46d"] forState:UIControlStateNormal];
            }
            
            if ([dic[@"datas"][@"bind"] isKindOfClass:[NSArray class]]) {
             
            strongSelf.linkWChatButton.userInteractionEnabled = YES;
                
                [strongSelf.linkWChatButton setTitle:@"未绑定" forState:UIControlStateNormal];
                
                [strongSelf.linkWChatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                
            strongSelf.linkWChatButton.userInteractionEnabled = NO;
                
                [strongSelf.linkWChatButton setTitle:@"已绑定" forState:UIControlStateNormal];

                [strongSelf.linkWChatButton setTitleColor:[UIColor colorWithHexString:@"#1ec46d"] forState:UIControlStateNormal];
            }
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}

-(void)initUI
{
    self.navigationItem.title = @"账户信息";
    
    [WYFTools viewLayer:_exitLoginButton.frame.size.height/16*3 withView:_exitLoginButton];
    
}
//余额充值
- (IBAction)rechargeBalance:(UIButton *)sender {

    HZDSBalanceRechargeViewController *recharg = [[HZDSBalanceRechargeViewController alloc] init];
    
    [self.navigationController pushViewController:recharg animated:YES];
}
//余额日志
- (IBAction)balanceLogList:(UIButton *)sender {

    HZDSLogListViewController *logList = [[HZDSLogListViewController alloc] init];
   
    [self.navigationController pushViewController:logList animated:YES];
}
//好友转账
- (IBAction)TransferAccounts:(UIButton *)sender {

    HZDSTransferAccountsViewController *account = [[HZDSTransferAccountsViewController alloc] init];
    
    [self.navigationController pushViewController:account animated:YES];
}

//绑定手机号
- (IBAction)linkUserPhone:(UIButton *)sender {

    HZDSlinkUserPhoneViewController *link = [[HZDSlinkUserPhoneViewController alloc] init];
    
    [self.navigationController pushViewController:link animated:YES];
}
//会员认证
- (IBAction)authenticationCLick:(UIButton *)sender {

    HZDSAuthenticationViewController *authentication = [[HZDSAuthenticationViewController alloc] init];
    
    [self.navigationController pushViewController:authentication animated:YES];
}

- (IBAction)linkWX:(id)sender {

    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
        
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        
        [WXApi sendReq:req];//发起微信授权请求
    
    }else{
        
     //   [JKToast showWithText:@"请安装微信客户端"];
        
    }
    
}
//修改登录密码
- (IBAction)changeLoginPass:(UIButton *)sender {

    HZDSChangepassWordViewController *pass = [[HZDSChangepassWordViewController alloc] init];
    
    [self.navigationController pushViewController:pass animated:YES];

}
//修改支付密码
- (IBAction)changePayPass:(UIButton *)sender {

    HZDSChangePayPassViewController *pay = [[HZDSChangePayPassViewController alloc] init];
    
    [self.navigationController pushViewController:pay animated:YES];
}
//忘记支付密码
- (IBAction)forgetpayPass:(UIButton *)sender {

    HZDSForgetPassWordViewController *pass = [[HZDSForgetPassWordViewController alloc] init];
    
    pass.request_url = GETNEWPAYPASSWORD;
    
    [self.navigationController pushViewController:pass animated:YES];
}

//退出登录
- (IBAction)exitLogin:(UIButton *)sender {

    
    
    [CrazyNetWork CrazyRequest_Post:EXITLOGINSTATUS parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"退出登录", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [USER_DEFAULT setBool:NO forKey:@"isLogin"];

            [self clearData];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
  
}
-(void)clearData
{
  

    [USER_DEFAULT removeObjectForKey:@"User_ID"];
    
    [USER_DEFAULT removeObjectForKey:@"nickname"];
   
    [USER_DEFAULT removeObjectForKey:@"face"];
    
    [USER_DEFAULT removeObjectForKey:@"HETONG"];
    
    [USER_DEFAULT removeObjectForKey:@"SHANGHU"];
    
    [USER_DEFAULT removeObjectForKey:@"LOGO"];
    
    [USER_DEFAULT removeObjectForKey:@"IDCARDFACE"];
    
    [USER_DEFAULT removeObjectForKey:@"IDCARDOUTFACE"];
    
    [USER_DEFAULT removeObjectForKey:@"ZHIZHAO"];

    [USER_DEFAULT removeObjectForKey:@"choiceAddress"];
    
    [USER_DEFAULT removeObjectForKey:@"payGoodsOrMall"];
    
    [USER_DEFAULT removeObjectForKey:@"xianshang"];
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
