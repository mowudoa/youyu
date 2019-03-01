//
//  HZDSTransferAccountsViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/16.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSTransferAccountsViewController.h"

@interface HZDSTransferAccountsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *transAccountInfo;

@property (weak, nonatomic) IBOutlet UITextField *phonneTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkPhoneButton;

@property (weak, nonatomic) IBOutlet UITextField *moneyNumTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *transAccountButton;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property(nonatomic,copy) NSString *phoneNumString;

@property(nonatomic,copy) NSString *formTokenString;

@property(nonatomic,assign) NSInteger num;
@end

@implementation HZDSTransferAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"转账给好友";
    
    _transAccountButton.layer.cornerRadius = _transAccountButton.frame.size.height/16*3;
    
    _transAccountButton.layer.masksToBounds = YES;
    
    _getCodeButton.layer.cornerRadius = _getCodeButton.frame.size.height/6;
    
    _getCodeButton.layer.masksToBounds = YES;
    
    _checkPhoneButton.layer.cornerRadius = _checkPhoneButton.frame.size.height/6;
    
    _checkPhoneButton.layer.masksToBounds = YES;
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:TRANSACCOUNT_INFO parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"转账详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.transAccountInfo.text = [NSString stringWithFormat:@"您当前有余额:%.2f  单笔最少转账:%@,最多%@",[dic[@"datas"][@"money"] doubleValue],dic[@"datas"][@"chsh"][@"is_transfer_small"],dic[@"datas"][@"chsh"][@"is_transfer_big"]];
            
            strongSelf.phoneLabel.text = dic[@"datas"][@"mobile"];
            
            strongSelf.phoneNumString = dic[@"datas"][@"MEMBER"][@"mobile"];
            
            strongSelf.formTokenString = dic[@"datas"][@"form_token"];
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
- (IBAction)checkPhone:(id)sender {

    if ([_phonneTextField.text isEqualToString:@""] || [_phonneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"手机号不可为空"];
        
    }else{
        
        NSDictionary *dic = @{@"mobile":_phonneTextField.text};
        
        __weak typeof(self) weakSelf = self;

        [CrazyNetWork CrazyRequest_Post:TRANSACCOUNT_CHECKPHONE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"手机号检测", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;

            if (SUCCESS) {
                
                [self loadHtmlString:dic[@"datas"][@"msg"]];
                
                [strongSelf.transAccountButton setBackgroundColor:[UIColor redColor]];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
                [strongSelf.transAccountButton setBackgroundColor:[UIColor colorWithHexString:@"#aaaaaa"]];
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
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
- (IBAction)transAccount:(UIButton *)sender {

    if ([_phonneTextField.text isEqualToString:@""] || [_phonneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"手机号不可为空"];
        
    }else if ([_moneyNumTextField.text isEqualToString:@""] || [_moneyNumTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"转账数额不可为空"];

    }else if ([_codeTextField.text isEqualToString:@""] || [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"验证码不可为空"];
        
    }else{
     
        NSDictionary *urlDic = @{@"form_token":_formTokenString,
                                 @"mobile":_phonneTextField.text,
                                 @"money":_moneyNumTextField.text,
                                 @"yzm":_codeTextField.text};
        [CrazyNetWork CrazyRequest_Post:TRANSACCOUNT parameters:urlDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"转账", dic);
            
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

//加载html提示
-(void)loadHtmlString:(NSString *)htmlString
{
    
    NSString *infoStr = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",SCREEN_WIDTH - 20,htmlString];
    
    NSData *data = [infoStr dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                
                                                               options:options
                                
                                                    documentAttributes:nil
                                
                                                                 error:nil];
    
    
    _tipsLabel.attributedText = html;
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
