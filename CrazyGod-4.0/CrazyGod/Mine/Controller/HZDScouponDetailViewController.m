//
//  HZDScouponDetailViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDScouponDetailViewController.h"

@interface HZDScouponDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *couponNum;
@property (weak, nonatomic) IBOutlet UILabel *counponPrice;
@property (weak, nonatomic) IBOutlet UIImageView *couponCode;

@end

@implementation HZDScouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
    [self initData];
    
}
-(void)initUI
{
    self.navigationItem.title = @"我的消费券";
}
-(void)initData
{
    
    NSDictionary *dic = @{@"code_id":_couponId};

    __weak typeof(self) weakSelf = self;

    [CrazyNetWork CrazyRequest_Post:COUPON_DETAIL parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"消费券详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (SUCCESS) {
            
            strongSelf.couponNum.text = dic[@"datas"][@"detail"][@"code"];
           
            strongSelf.counponPrice.text = [dic[@"datas"][@"detail"][@"real_money"] stringValue];

            NSString *urlStr = dic[@"datas"][@"file"];
            
            
            [strongSelf.couponCode sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL_CODE,urlStr]]];

            
        }else{
            

            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
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
