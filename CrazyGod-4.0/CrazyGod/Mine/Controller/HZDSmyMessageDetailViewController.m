//
//  HZDSmyMessageDetailViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmyMessageDetailViewController.h"
#import "HZDSgoAgreeMessageViewController.h"

@interface HZDSmyMessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@property(nonatomic,copy) NSString *agreeUrl;

@end

@implementation HZDSmyMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];

}
-(void)initUI
{
    self.navigationItem.title = @"通知中心";
    
}
-(void)initData
{
    _clickButton.userInteractionEnabled = YES;
    
    __weak typeof(self) weakSelf = self;

    
    NSDictionary *dic = @{@"msg_id":_messageID                          };
    
    [CrazyNetWork CrazyRequest_Post:MY_MESSGAE_DETAIL parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"消息详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSDictionary *dict1 = dic[@"datas"][@"detail"];
            
            strongSelf.titleLabel.text = dict1[@"title"];
            
            strongSelf.infoLabel.text = dic[@"datas"][@"msg"];

            strongSelf.agreeUrl = dic[@"datas"][@"worker_id"];
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)initmechantMessageData
{
    _clickButton.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    
    
    NSDictionary *dic = @{@"msg_id":_messageID                          };
    
    [CrazyNetWork CrazyRequest_Post:MERCHANT_MESSAGE_DETAIL parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商家消息详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSDictionary *dict1 = dic[@"datas"][@"detail"];
            
            strongSelf.titleLabel.text = dict1[@"title"];
            
            strongSelf.infoLabel.text = dict1[@"intro"];
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)initEmployeeMessageData
{
    _clickButton.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    
    
    NSDictionary *dic = @{@"msg_id":_messageID                          };
    
    [CrazyNetWork CrazyRequest_Post:MERCHANT_MESSAGE_DETAIL parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商家消息详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSDictionary *dict1 = dic[@"datas"][@"detail"];
            
            strongSelf.titleLabel.text = dict1[@"title"];
            
            
            strongSelf.infoLabel.text = dict1[@"intro"];
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
- (IBAction)agreeButton:(UIButton *)sender {

    NSDictionary *dic = @{@"worker_id":_agreeUrl                          };
    
    
    [CrazyNetWork CrazyRequest_Post:MY_MESSAGE_CHOICE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"是否同意过", dic);
        
        
        if (SUCCESS) {
    
            HZDSgoAgreeMessageViewController *agree = [[HZDSgoAgreeMessageViewController alloc] init];
            
            agree.workerID = self->_agreeUrl;
            
            [self.navigationController pushViewController:agree animated:YES];
            
        }else{
            
            [JKToast showWithText:@"您已经同意一个该请求"];
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_messageType == mineMessageType) {
        
        [self initData];

    }else if (_messageType == merchantMessageType)
    {
        [self initmechantMessageData];
        
    }else if (_messageType == employeeMessageType)
    {
        [self initEmployeeMessageData];
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
