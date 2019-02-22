//
//  HZDSmerchantBaseInfoViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmerchantBaseInfoViewController.h"

@interface HZDSmerchantBaseInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UITextField *merchantAddress;
@property (weak, nonatomic) IBOutlet UITextField *merchantPhone;
@property (weak, nonatomic) IBOutlet UITextField *merchantUser;
@property (weak, nonatomic) IBOutlet UITextField *merchantMobile;
@property (weak, nonatomic) IBOutlet UITextField *businessTime;

@property (weak, nonatomic) IBOutlet UITextField *DeliveryTime;
@end

@implementation HZDSmerchantBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"基本设置";
    
    [_describeTextView.layer setMasksToBounds:YES];
    [_describeTextView.layer setCornerRadius:10]; //设置矩形四个圆角半径
    //边框宽度
    [_describeTextView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _describeTextView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    _editButton.layer.cornerRadius = _editButton.frame.size.height/16*3;
    
    _editButton.layer.masksToBounds = YES;
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"店铺介绍,建议不超过200字!";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_describeTextView addSubview:placeHolderLabel];
    
    // same font
    placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    
    [_describeTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
-(void)initData
{
  
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:MERCHANTSET_BASE parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"基本设置", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
        
            strongSelf.merchantAddress.text = dic[@"datas"][@"SHOP"][@"addr"];
            
            strongSelf.merchantUser.text = dic[@"datas"][@"SHOP"][@"contact"];

            strongSelf.merchantMobile.text = dic[@"datas"][@"SHOP"][@"tel"];

            strongSelf.merchantPhone.text = dic[@"datas"][@"SHOP"][@"mobile"];

            strongSelf.businessTime.text = dic[@"datas"][@"ex"][@"business_time"];

            strongSelf.DeliveryTime.text = [dic[@"datas"][@"ex"][@"delivery_time"] stringValue];
            
            strongSelf.describeTextView.text = dic[@"datas"][@"ex"][@"details"];

            
            }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
- (IBAction)goEdit:(UIButton *)sender {

    if ([_merchantAddress.text isEqualToString:@""] || [_merchantAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"商户地址不可为空"];
    }else if ([_merchantUser.text isEqualToString:@""] || [_merchantUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"联系人不可为空"];
        
    }else if ([_merchantMobile.text isEqualToString:@""] || [_merchantMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"店铺电话不可为空"];
        
    }else if ([_merchantPhone.text isEqualToString:@""] || [_merchantPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"店铺手机号不可为空"];
        
    }else if ([_businessTime.text isEqualToString:@""] || [_businessTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"营业时间不可为空"];
        
    }else if ([_DeliveryTime.text isEqualToString:@""] || [_DeliveryTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"配送时间不可为空"];
        
    }else if ([_describeTextView.text isEqualToString:@""] || [_describeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"描述不可为空"];
        
    }else{
        
        NSDictionary *dic = @{@"addr":_merchantAddress.text,
                              @"contact":_merchantUser.text,
                
                              @"tel":_merchantMobile.text,
                              @"mobile":_merchantPhone.text,
                              @"business_time":_businessTime.text,
                              @"delivery_time":_DeliveryTime.text,
                              @"details":_describeTextView.text
                              };
        
        
        [CrazyNetWork CrazyRequest_Post:MERCHANTSET_BASE_EDIT parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"修改设置", dic);
            
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
