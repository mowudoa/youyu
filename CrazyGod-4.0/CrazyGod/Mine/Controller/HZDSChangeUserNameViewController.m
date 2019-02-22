//
//  HZDSChangeUserNameViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSChangeUserNameViewController.h"

@interface HZDSChangeUserNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeNickNameButton;

@end

@implementation HZDSChangeUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
-(void)initUI
{
    self.navigationItem.title = @"修改昵称";
    
    _changeNickNameButton.layer.cornerRadius = _changeNickNameButton.frame.size.height/16*3;
    
    _changeNickNameButton.layer.masksToBounds = YES;
 
    _nickNameLabel.text = [USER_DEFAULT objectForKey:@"nickname"];
}
- (IBAction)checkNickName:(UIButton *)sender {

    
    if ([_nickNameTextField.text isEqualToString:@""] || [_nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"昵称不可为空"];
    }else{
        
        NSDictionary *dic = @{@"nickname":_nickNameTextField.text};
        
        [CrazyNetWork CrazyRequest_Post:CHECKNICKNAME parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"昵称检测", dic);
            
            if (SUCCESS) {
                
                if ([dic[@"datas"][@"msg"] isEqualToString:@"0"]) {
                    
                    [JKToast showWithText:@"昵称重复"];
                    
                    
                }else if ([dic[@"datas"][@"msg"] isEqualToString:@"1"])
                {
                    
                    [JKToast showWithText:@"昵称可以使用"];
                    
                    self->_changeNickNameButton.hidden = NO;
                }
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }

}
- (IBAction)changeNickName:(UIButton *)sender {

    NSDictionary *dic = @{@"nickname":_nickNameTextField.text};
    
    [CrazyNetWork CrazyRequest_Post:CHANGENICKNAME parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"更改昵称", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
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
