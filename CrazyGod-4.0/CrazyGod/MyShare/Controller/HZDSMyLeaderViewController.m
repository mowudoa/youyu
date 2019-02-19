//
//  HZDSMyLeaderViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/15.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMyLeaderViewController.h"

@interface HZDSMyLeaderViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation HZDSMyLeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"我的领导";
    
    _headerImage.layer.cornerRadius = _headerImage.frame.size.height/2;
    
    _headerImage.layer.masksToBounds = YES;
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:MYLEADER parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"我的领导", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
            
            if (dic[@"datas"][@"site"][@"title"] == NULL || dic[@"datas"][@"site"][@"title"] == nil ||dic[@"datas"][@"site"][@"title"] == [NSNull null]) {
                
                
            }else{
                
                strongSelf.titleLabel.text = dic[@"datas"][@"site"][@"title"];
                
            }
            
            
            if (dic[@"datas"][@"site"][@"logo"] == NULL || dic[@"datas"][@"site"][@"logo"] == nil ||dic[@"datas"][@"site"][@"logo"] == [NSNull null]) {
                
                strongSelf.headerImage.image = [UIImage imageNamed:@"1213per"];
                
            }else{
                
                [strongSelf.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"site"][@"logo"]]] placeholderImage:[UIImage imageNamed:@"1213per"]];
                
                
            }
            
            strongSelf.phoneLabel.text = dic[@"datas"][@"site"][@"tel"];
            
            if (dic[@"datas"][@"site"][@"qq"] == NULL || dic[@"datas"][@"site"][@"qq"] == nil ||dic[@"datas"][@"site"][@"qq"] == [NSNull null]) {
                
                
            }else{
                
                strongSelf.qqLabel.text = dic[@"datas"][@"site"][@"qq"];
                
            }
            
            if (dic[@"datas"][@"site"][@"email"] == NULL || dic[@"datas"][@"site"][@"email"] == nil ||dic[@"datas"][@"site"][@"email"] == [NSNull null]) {
                
                
            }else{
                
                strongSelf.emailLabel.text = dic[@"datas"][@"site"][@"email"];
                
            }
            
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
