//
//  HZDSMyShareQRCodeViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/15.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMyShareQRCodeViewController.h"

@interface HZDSMyShareQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImage;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation HZDSMyShareQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"我的二维码";
    
    _headerImage.layer.cornerRadius = _headerImage.frame.size.height/2;
    
    _headerImage.layer.masksToBounds = YES;
    
   
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"fuid":_userID};
    
    [CrazyNetWork CrazyRequest_Post:MYSHARE_QRCODE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"我的二维码", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
          
            strongSelf.titleLabel.text = dic[@"datas"][@"MEMBER"][@"nickname"];

            [strongSelf.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"MEMBER"][@"face"]]] placeholderImage:[UIImage imageNamed:@"1213per"]];

            [strongSelf.QRCodeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL_CODE,dic[@"datas"][@"file"]]] placeholderImage:[UIImage imageNamed:@"1213per"]];

            strongSelf.infoLabel.text = [NSString stringWithFormat:@"尊敬的%@,分享当前页面,会员扫码后就可以获得分成",dic[@"datas"][@"MEMBER"][@"nickname"]];
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
