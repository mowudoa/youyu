//
//  HZDScheckCouponDetailViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDScheckCouponDetailViewController.h"

@interface HZDScheckCouponDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *counponIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *couponNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *usedTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;

@end

@implementation HZDScheckCouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"验证记录详情";
}
-(void)initData
{
    NSDictionary *dic = @{@"code_id":_couponId};
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:_detailUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"验证码详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.counponIDLabel.text = dic[@"datas"][@"detail"][@"code_id"];
            
            strongSelf.couponNumLabel.text = dic[@"datas"][@"detail"][@"code"];
            
            strongSelf.createTimeLabel.text = [self ConvertStrToTime:dic[@"datas"][@"detail"][@"create_time"]];
            
            strongSelf.usedTimeLabel.text = [self ConvertStrToTime:dic[@"datas"][@"detail"][@"used_time"]];
            
            
            strongSelf.userNameLabel.text = dic[@"datas"][@"users"][@"nickname"];
            
            strongSelf.userPhoneLabel.text = dic[@"datas"][@"users"][@"mobile"];            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
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
