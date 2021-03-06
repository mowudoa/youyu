//
//  HZDSaddEmployeeViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSaddEmployeeViewController.h"

@interface HZDSaddEmployeeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (weak, nonatomic) IBOutlet UITextField *employeeID;

@property (weak, nonatomic) IBOutlet UITextField *employeeName;

@property (weak, nonatomic) IBOutlet UITextField *employeeMobile;

@property (weak, nonatomic) IBOutlet UITextField *employeePhone;

@property (weak, nonatomic) IBOutlet UITextField *employeeQQ;

@property (weak, nonatomic) IBOutlet UITextField *employeeWchat;

@property (weak, nonatomic) IBOutlet UITextField *employeeAddress;

@property (weak, nonatomic) IBOutlet UITextField *employeeJob;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;

@property (weak, nonatomic) IBOutlet UIButton *noButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property(nonatomic,copy) NSString *powerString;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UIView *employeeIdView;

@end

@implementation HZDSaddEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
-(void)initUI
{
    if (_employeeType == editType) {
        
        self.navigationItem.title = @"编辑员工";

        _headerLabel.hidden = YES;
        
        _employeeIdView.hidden = YES;
        
        _headerLabel.height = 0;
        
        _employeeIdView.height = 0;
        
        [_addButton setTitle:@"确认编辑" forState:UIControlStateNormal];

        _addButton.hidden = NO;
        
    }else if (_employeeType == addType){
        
        self.navigationItem.title = @"添加员工";

        _headerLabel.hidden = NO;
        
        _employeeIdView.hidden = NO;
        
        [_addButton setTitle:@"确认添加" forState:UIControlStateNormal];
        
        _addButton.hidden = YES;
    }
    
    if (_employeeType == editType) {
      
//        _employeeID.text = _employModel.employeeID;
        
        _employeeJob.text = _employModel.employeeJob;
        
        _employeeQQ.text = _employModel.employeeQQ;
        
        _employeeName.text = _employModel.employeeName;
        
        _employeePhone.text = _employModel.employeePhone;
        
        _employeeMobile.text = _employModel.employeeTel;
        
        _employeeWchat.text = _employModel.employeeWchat;
        
        _employeeAddress.text = _employModel.employeeAddress;
        
        if ([_employModel.employeePower isEqualToString:@"1"]) {
            
            _yesButton.selected = YES;
            
            _noButton.selected = NO;
            
            _powerString = @"1";
            
        }else{
            
            _noButton.selected = YES;
           
            _yesButton.selected = NO;

            _powerString = @"0";
        }
        
    }
    
    [WYFTools viewLayer:_checkButton.height/3 withView:_checkButton];
    
    [WYFTools viewLayer:_addButton.height/16*3 withView:_addButton];
    
}
- (IBAction)addEmployee:(UIButton *)sender {

   
    if (_employeeType == editType) {
        
        [self editEmployee];
        
    }else if (_employeeType == addType){
        
        [self addeToEmployee];
    }
    
}
-(void)addeToEmployee
{
    
    if ([_employeeID.text isEqualToString:@""] || [_employeeID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
    
        [JKToast showWithText:@"员工id不可为空"];
    
    }else if ([_employeeName.text isEqualToString:@""] || [_employeeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工名字不可为空"];
        
    }else if ([_employeeMobile.text isEqualToString:@""] || [_employeeMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工座机不可为空"];
        
    }else if ([_employeePhone.text isEqualToString:@""] || [_employeePhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工手机不可为空"];
        
    }else if ([_employeeQQ.text isEqualToString:@""] || [_employeeQQ.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工QQ不可为空"];
        
    }else if ([_employeeWchat.text isEqualToString:@""] || [_employeeWchat.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工微信不可为空"];
        
    }else if ([_employeeAddress.text isEqualToString:@""] || [_employeeAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工地址不可为空"];
        
    }else if ([_employeeJob.text isEqualToString:@""] || [_employeeJob.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工职务不可为空"];
        
    }else if (_powerString == nil){
        
        [JKToast showWithText:@"请选择员工核销权限"];
        
    }else{
        
        
        NSDictionary *dic = @{@"user_id":_employeeID.text,
                              @"name":_employeeName.text,
                              
                              @"tel":_employeeMobile.text,
                              @"mobile":_employeePhone.text,
                              @"qq":_employeeQQ.text,
                              @"weixin":_employeeWchat.text,
                              @"addr":_employeeAddress.text,
                              @"work":_employeeJob.text,
                              @"tuan":_powerString
                              };
        
        [CrazyNetWork CrazyRequest_Post:_addUrl parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"添加员工", dic);
            
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
-(void)editEmployee
{
    
    if ([_employeeName.text isEqualToString:@""] || [_employeeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工名字不可为空"];
        
    }else if ([_employeeMobile.text isEqualToString:@""] || [_employeeMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工座机不可为空"];
        
    }else if ([_employeePhone.text isEqualToString:@""] || [_employeePhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工手机不可为空"];
        
    }else if ([_employeeQQ.text isEqualToString:@""] || [_employeeQQ.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工QQ不可为空"];
        
    }else if ([_employeeWchat.text isEqualToString:@""] || [_employeeWchat.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工微信不可为空"];
        
    }else if ([_employeeAddress.text isEqualToString:@""] || [_employeeAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工地址不可为空"];
        
    }else if ([_employeeJob.text isEqualToString:@""] || [_employeeJob.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"员工职务不可为空"];
        
    }else if (_powerString == nil){
        
        [JKToast showWithText:@"请选择员工核销权限"];
        
    }else{
        
        
        NSDictionary *dic = @{@"worker_id":_employModel.employeeID,
                              @"user_id":_employModel.userID,       @"name":_employeeName.text,
                              
                              @"tel":_employeeMobile.text,
                              @"mobile":_employeePhone.text,
                              @"qq":_employeeQQ.text,
                              @"weixin":_employeeWchat.text,
                              @"addr":_employeeAddress.text,
                              @"work":_employeeJob.text,
                              @"tuan":_powerString
                              };
        
        
        [CrazyNetWork CrazyRequest_Post:_addUrl parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"添加员工", dic);
            
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
- (IBAction)powerYesOrNo:(UIButton *)sender {


    if (sender.tag == 101) {
        
        _yesButton.selected = YES;
       
        _noButton.selected = NO;
        
        _powerString = @"1";
    }else{
        
        _yesButton.selected = NO;
       
        _noButton.selected = YES;
        
        _powerString = @"0";
    }
    
}
- (IBAction)checkId:(UIButton *)sender {
  
    if ([_employeeID.text isEqualToString:@""] || [_employeeID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"员工id不可为空"];
    }else{
        
        NSDictionary *dic = @{@"user_id":_employeeID.text
                              };
        
        [CrazyNetWork CrazyRequest_Post:EMPLOYEE_ID_CHECK parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"员工id检测", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                self->_addButton.hidden = NO;
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }

}

-(void)viewDidLayoutSubviews
{
    
    UIView* conView = (UIView*)[_bgScrollView viewWithTag:2048];
    
    _bgScrollView.contentSize = CGSizeMake(0, conView.frame.origin.y+conView.frame.size.height + 10);
    
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
