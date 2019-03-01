//
//  HZDSgoAgreeMessageViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSgoAgreeMessageViewController.h"

@interface HZDSgoAgreeMessageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *agreeBUtton;

@property (weak, nonatomic) IBOutlet UIButton *refuseBUtton;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@property (weak, nonatomic) IBOutlet UILabel *qqLabel;

@property (weak, nonatomic) IBOutlet UILabel *wChatLabel;

@end

@implementation HZDSgoAgreeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    _agreeBUtton.layer.cornerRadius = 3;
    
    _agreeBUtton.layer.masksToBounds = YES;
    
    _refuseBUtton.layer.cornerRadius = 3;
    
    _refuseBUtton.layer.masksToBounds = YES;
    
    self.navigationItem.title = @"通知详情";
}
-(void)initData
{
  
    NSDictionary *dic = @{@"worker_id":_workerID                          };
    
    __weak typeof(self) weakSelf = self;

    [CrazyNetWork CrazyRequest_Post:MY_MESSAGE_CHOICE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"请求详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        
        if (SUCCESS) {
         
            strongSelf.shopName.text  =dic[@"datas"][@"shop"][@"shop_name"];
           
            strongSelf.nameLabel.text  =dic[@"datas"][@"worker"][@"name"];

            strongSelf.jobLabel.text  =dic[@"datas"][@"worker"][@"work"];

            strongSelf.phoneLabel.text  =dic[@"datas"][@"worker"][@"tel"];

            strongSelf.mobileLabel.text  =dic[@"datas"][@"worker"][@"mobile"];

            strongSelf.qqLabel.text  =dic[@"datas"][@"worker"][@"qq"];

            strongSelf.wChatLabel.text  =dic[@"datas"][@"worker"][@"weixin"];

        }else{
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    

}
- (IBAction)agree:(UIButton *)sender {

    NSDictionary *dic = @{@"worker_id":_workerID                          };
    
    
    [CrazyNetWork CrazyRequest_Post:MESSAGE_AGREE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"同意", dic);
        
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
           
            [JKToast showWithText:dic[@"datas"][@"error"]];

        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
- (IBAction)refuse:(UIButton *)sender {

    
    NSDictionary *dic = @{@"worker_id":_workerID                          };
        
    [CrazyNetWork CrazyRequest_Post:MESSAGE_REFUSE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"拒绝", dic);
        
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
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
