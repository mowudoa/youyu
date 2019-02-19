//
//  HZDSemployeeCenterViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSemployeeCenterViewController.h"
#import "HZDSNewMessageViewController.h"
#import "HZDScouponCheckViewController.h"
#import "HZDSmerchantOrderViewController.h"

@interface HZDSemployeeCenterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *employName;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation HZDSemployeeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"店员中心";
    
    _titleImage.layer.cornerRadius = _titleImage.frame.size.height/2;
    
    _titleImage.layer.masksToBounds = YES;
    
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:EMPLOYEE_CENTRE parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"店员中心", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSDictionary *dict = dic[@"datas"];
            
            strongSelf.employName.text = [NSString stringWithFormat:@"欢迎你:%@",dict[@"worker"][@"name"]];
            
            strongSelf.phoneLabel.text = [NSString stringWithFormat:@"电话:%@  职务:%@",dict[@"worker"][@"tel"],dict[@"worker"][@"work"]];

            strongSelf.shopName.text = [NSString stringWithFormat:@"店铺:%@",dict[@"SHOP"][@"shop_name"]];

            [strongSelf.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dict[@"SHOP"][@"logo"]]]];

            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
- (IBAction)clickButton:(UIButton *)sender {

    if (sender.tag == 101) {
     
        HZDScouponCheckViewController *coupon = [[HZDScouponCheckViewController alloc] init];
        
        coupon.checkUrl = EMPLOYEE_COUPON_CHECK;
        
        [self.navigationController pushViewController:coupon animated:YES];
    }else if(sender.tag == 102){
    
        HZDSNewMessageViewController *message = [[HZDSNewMessageViewController alloc] init];
        
        message.messageUrl = EMPLOYEE_MESSAGE;
        
        [self.navigationController pushViewController:message animated:YES];
    }else{
      
        HZDSmerchantOrderViewController *order = [[HZDSmerchantOrderViewController alloc] init];
        
        order.OrderUrl = EMPLOYEE_ORDER;
        
        [self.navigationController pushViewController:order animated:YES];
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
