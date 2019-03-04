//
//  HZDSMyShareViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMyShareViewController.h"
#import "HZDSBalanceRechargeViewController.h"
#import "HZDSMySubordinateViewController.h"
#import "HZDSMyShareQRCodeViewController.h"
#import "HZDSMyProfitListViewController.h"
#import "HZDSMyLeaderViewController.h"
#import "HZDSLoginViewController.h"

@interface HZDSMyShareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipRank;

@property (weak, nonatomic) IBOutlet UILabel *myBalance;

@property (weak, nonatomic) IBOutlet UILabel *myReward;

@property (weak, nonatomic) IBOutlet UILabel *myCancleReward;

@property(nonatomic,copy) NSString *user_id;
@end

@implementation HZDSMyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
    
}
-(void)initUI
{
    self.navigationItem.title = @"我的营销中心";
    
    [WYFTools viewLayer:_headerImage.frame.size.height/2 withView:_headerImage];
    
    [WYFTools viewLayer:3 withView:_vipRank];
}
-(void)initData
{

    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:MYMARKET_CENTER parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"营销中心", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        
        if (SUCCESS) {
            
            strongSelf.user_id = dic[@"datas"][@"MEMBER"][@"user_id"];
            
            if (dic[@"datas"][@"MEMBER"][@"nickname"] == NULL || dic[@"datas"][@"MEMBER"][@"nickname"] == nil ||dic[@"datas"][@"MEMBER"][@"nickname"] == [NSNull null]) {
                
                
            }else{
                
                strongSelf.userNameLabel.text = dic[@"datas"][@"MEMBER"][@"nickname"];
                
            }
            
            if (dic[@"datas"][@"MEMBER"][@"face"] == NULL || dic[@"datas"][@"MEMBER"][@"face"] == nil ||dic[@"datas"][@"MEMBER"][@"face"] == [NSNull null]) {
                
                strongSelf.headerImage.image = [UIImage imageNamed:@"1213per"];
                
            }else{
                
                [strongSelf.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"MEMBER"][@"face"]]] placeholderImage:[UIImage imageNamed:@"1213per"]];
                
                [USER_DEFAULT setObject:dic[@"datas"][@"MEMBER"][@"face"] forKey:@"face"];
                
            }
            
            strongSelf.vipRank.text = [NSString stringWithFormat:@"VIP %@",dic[@"datas"][@"MEMBER"][@"rank_id"]];

            strongSelf.myBalance.text = [NSString stringWithFormat:@"¥%@",[dic[@"datas"][@"MEMBER"][@"money"] stringValue]];

            if (dic[@"datas"][@"profit_ok"] == NULL || dic[@"datas"][@"profit_ok"] == nil ||dic[@"datas"][@"profit_ok"] == [NSNull null]) {
                
                strongSelf.myReward.text = @"¥0";

            }else{
                
                strongSelf.myReward.text = [NSString stringWithFormat:@"¥%@",[dic[@"datas"][@"profit_ok"] stringValue]];

            }
            if (dic[@"datas"][@"profit_cancel"] == NULL || dic[@"datas"][@"profit_cancel"] == nil ||dic[@"datas"][@"profit_cancel"] == [NSNull null]) {
                
                strongSelf.myCancleReward.text = @"¥0";
                
            }else{
                
                strongSelf.myCancleReward.text = [NSString stringWithFormat:@"¥%@",[dic[@"datas"][@"profit_cancel"] stringValue]];
                
            }
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
            HZDSLoginViewController *login = [[HZDSLoginViewController alloc] init];
            
            [self.navigationController pushViewController:login animated:YES];
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
- (IBAction)seeMyReward:(UIButton *)sender {

    if (sender.tag == 201) {
      
        HZDSBalanceRechargeViewController *recharge = [[HZDSBalanceRechargeViewController alloc] init];
        
        [self.navigationController pushViewController:recharge animated:YES];
        
    }else if (sender.tag == 202){
     
        HZDSMyProfitListViewController *profit = [[HZDSMyProfitListViewController alloc] init];
        
        profit.profitType = MyProfitTypeOk;
        
        [self.navigationController pushViewController:profit animated:YES];
        
    }else if (sender.tag == 203){
        
        HZDSMyProfitListViewController *profit = [[HZDSMyProfitListViewController alloc] init];
        
        profit.profitType = MyProfitTypeCancle;
        
        [self.navigationController pushViewController:profit animated:YES];
    }
    
}
- (IBAction)clickButton:(UIButton *)sender {

    if (sender.tag == 101) {
     
        HZDSMyProfitListViewController *profit = [[HZDSMyProfitListViewController alloc] init];
        
        profit.profitType = MyProfitTypeOk;
        
        [self.navigationController pushViewController:profit animated:YES];
        
    }else if (sender.tag == 102){
     
        HZDSMySubordinateViewController *Subordinate = [[HZDSMySubordinateViewController alloc] init];
        
        Subordinate.SubordinateType = MySubordinateFirst;
        
        [self.navigationController pushViewController:Subordinate animated:YES];
        
    }else if (sender.tag == 103){
     
        HZDSMyLeaderViewController *leader = [[HZDSMyLeaderViewController alloc] init];
        
        [self.navigationController pushViewController:leader animated:YES];
        
    }else if (sender.tag == 104){
      
        HZDSMyShareQRCodeViewController *code = [[HZDSMyShareQRCodeViewController alloc] init];
        
        code.userID = _user_id;
        
        [self.navigationController pushViewController:code animated:YES];
        
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
