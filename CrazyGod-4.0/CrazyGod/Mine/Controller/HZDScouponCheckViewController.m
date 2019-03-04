//
//  HZDScouponCheckViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/13.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDScouponCheckViewController.h"
#import "HZDScheckCouponHistoryViewController.h"

@interface HZDScouponCheckViewController ()

@property (weak, nonatomic) IBOutlet UITextField *couponNumTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet UIButton *checkHistoryButton;

@end

@implementation HZDScouponCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
-(void)initUI
{
    self.navigationItem.title = @"抢购券验证";
    
    [WYFTools viewLayer:_checkButton.frame.size.height/16*3 withView:_checkButton];
    
    [WYFTools viewLayer:_checkHistoryButton.frame.size.height/16*3 withView:_checkHistoryButton];
    
}
- (IBAction)check:(UIButton *)sender {

    
    if ([_couponNumTextField.text isEqualToString:@""] || [_couponNumTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
      
        [JKToast showWithText:@"抢购码不可为空"];
    
    }else{
     
        NSDictionary *dic = @{@"code":_couponNumTextField.text};
        
        [CrazyNetWork CrazyRequest_Post:_checkUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"验证抢购码", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
        
    }
    
    
}
- (IBAction)checkHistory:(UIButton *)sender {

    HZDScheckCouponHistoryViewController *history = [[HZDScheckCouponHistoryViewController alloc] init];
    
    if ([_checkUrl isEqualToString:MERCHANT_COUPON_CHECK]) {
        
        history.checkHistoryUrl = MERCHANT_COUPON_CHECK_HISTORY;
        
    }else if ([_checkUrl isEqualToString:EMPLOYEE_COUPON_CHECK]){
        
        history.checkHistoryUrl = EMPLOYEE_COUPON_CHECK_HISTORY;
    }
    
    [self.navigationController pushViewController:history animated:YES];
    
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
