//
//  HZDSAddAddressViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/23.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSAddAddressViewController.h"
#import "HZDSAddressModel.h"

@interface HZDSAddAddressViewController ()<
UINavigationControllerDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>
{
    HZDSAddressModel *_provinceModel;
    HZDSAddressModel *_cityModel;
    HZDSAddressModel *_countyModel;

    NSString *choiceString;
}

@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;

@property (weak, nonatomic) IBOutlet UITextView *addressDetailTextView;

@property (weak, nonatomic) IBOutlet UIButton *cuntyBUtton;

@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (weak, nonatomic) IBOutlet UIButton *provinceButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;

@property (weak, nonatomic) IBOutlet UIButton *noButton;

@property(nonatomic,strong) UIPickerView *classPickView;

@property(nonatomic,strong) UIView *myPickView;

@property(nonatomic,strong) NSMutableArray *provinceDataSource;

@property(nonatomic,strong) NSMutableArray *cityDataSource;

@property(nonatomic,strong) NSMutableArray *countyDataSource;

@property(nonatomic,copy) NSString *defaultString;
@end

@implementation HZDSAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    _provinceDataSource = [[NSMutableArray alloc] init];
    
    _cityDataSource = [[NSMutableArray alloc] init];
    
    _countyDataSource = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"添加地址";
    
    [_addressDetailTextView.layer setMasksToBounds:YES];
    [_addressDetailTextView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_addressDetailTextView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _addressDetailTextView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    _addAddressButton.layer.cornerRadius = _addAddressButton.frame.size.height/16*3;
    
    _addAddressButton.layer.masksToBounds = YES;
    
    if (_addressType == addType) {
        
        [_addAddressButton setTitle:@"确认添加" forState:UIControlStateNormal];
        
    }else{
        
        [_addAddressButton setTitle:@"确认编辑" forState:UIControlStateNormal];

    }
    

    [WYFTools CreateTextPlaceHolder:@"请填写详细地址" WithFont:[UIFont systemFontOfSize:14] WithSuperView:_addressDetailTextView];
}
-(void)initData
{
    if (_addressType == editType) {
        
        __weak typeof(self) weakSelf = self;

        NSDictionary *dic = @{@"address_id":_addressModel.addressId,
                              @"type":@"goods"
                              };
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,ADDRESS_EDIT_INFO] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"编辑地址", dic);
            
            
            if (SUCCESS) {
                
                if ([dic[@"datas"][@"detail"][@"default"] isEqualToString:@"0"]) {
                    
                    strongSelf.yesButton.selected = NO;
                    
                    strongSelf.noButton.selected = YES;
                    
                    strongSelf.defaultString = @"0";
                    
                }else{
                    
                    strongSelf.yesButton.selected = YES;
                    
                    strongSelf.noButton.selected = NO;
                    
                    strongSelf.defaultString = @"1";
                }
                
                strongSelf.phoneTextField.text = dic[@"datas"][@"detail"][@"tel"];
               
                strongSelf.userNameTextField.text = dic[@"datas"][@"detail"][@"xm"];
                
                strongSelf.addressDetailTextView.text = dic[@"datas"][@"detail"][@"info"];

                NSArray *provinceArr = dic[@"datas"][@"provinceList"];
               
                for (NSDictionary *dic1 in provinceArr) {
                    
                    if ([dic1[@"id"] isEqualToString:dic[@"datas"][@"detail"][@"province_id"]]) {
                        
                        [strongSelf.provinceButton setTitle:dic1[@"name"] forState:UIControlStateNormal];
                        
                        HZDSAddressModel *model = [[HZDSAddressModel alloc] init];
                        
                        model.addressId = dic1[@"id"];
                       
                        model.address = dic1[@"name"];
                        
                        self->_provinceModel = model;
                    }
                    
                }
                
                NSArray *cityArr = dic[@"datas"][@"cityList"];
                for (NSDictionary *dic1 in cityArr) {
                    
                    if ([dic1[@"id"] isEqualToString:dic[@"datas"][@"detail"][@"city_id"]]) {
                        
                        [strongSelf.cityButton setTitle:dic1[@"name"] forState:UIControlStateNormal];
                        HZDSAddressModel *model = [[HZDSAddressModel alloc] init];
                       
                        model.addressId = dic1[@"id"];
                       
                        model.address = dic1[@"name"];
                        
                        self->_cityModel = model;
                    }
                    
                }
              
                NSArray *contyArr = dic[@"datas"][@"areaList"];
                for (NSDictionary *dic1 in contyArr) {
                    
                    if ([dic1[@"id"] isEqualToString:dic[@"datas"][@"detail"][@"area_id"]]) {
                        
                        [strongSelf.cuntyBUtton setTitle:dic1[@"name"] forState:UIControlStateNormal];
                        
                        HZDSAddressModel *model = [[HZDSAddressModel alloc] init];
                        
                        model.addressId = dic1[@"id"];
                       
                        model.address = dic1[@"name"];
                        
                        self->_countyModel = model;
                    }
                    
                }
            }else{
                
                
            }
            
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
            LOG(@"cuow", Json);
            
        }];
        
        
    }
    
    
}
- (UIPickerView *)classPickView {
    
    if (!_classPickView) {
        
        _classPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44,SCREEN_WIDTH, 200)];
       
        _classPickView.delegate = self;
        
        _classPickView.dataSource = self;

    }
    return _classPickView;
    
}
-(UIView *)myPickView
{
    if (!_myPickView) {
        
        _myPickView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 344, SCREEN_WIDTH,344)];
        
        _myPickView.backgroundColor = [UIColor grayColor];
        
        UIButton *rightSureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
       
        rightSureBtn.frame = CGRectMake(SCREEN_WIDTH - 54, 0, 44, 44);
        
        [rightSureBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [rightSureBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_myPickView addSubview:rightSureBtn];
        
        // 左边取消按钮
        UIButton *leftCancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        leftCancleButton.frame = CGRectMake(10, 0, 44, 44);
        
        [leftCancleButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [leftCancleButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_myPickView addSubview:self.classPickView];
        
    }
    
    return _myPickView;
}
- (IBAction)addAddress:(UIButton *)sender {

    if (_addressType == addType) {
        
        [self toAddAddress];
        
    }else{
        
        [self toEditAddress];
    }
    
    
    

}
- (IBAction)yesOrNo:(UIButton *)sender {

    if (sender.tag == 200) {
        
        _yesButton.selected = YES;
        
        _noButton.selected = NO;
        
        _defaultString = @"1";
    }else{
        
        _yesButton.selected = NO;
        
        _noButton.selected = YES;
        
        _defaultString = @"0";
    }
    
}
- (IBAction)choiceAddressButton:(UIButton *)sender {

    [self.myPickView removeFromSuperview];
    
    
    if (sender.tag == 101) {
    
        if (_provinceModel == nil) {
            
            [JKToast showWithText:@"请选择省"];
            
            return;
        }
    }
    if (sender.tag == 102) {
        
        if (_cityModel == nil) {
            
            [JKToast showWithText:@"请选择城市"];
            
            return;
        }
    }
    
    [self showPickView:sender.tag - 100];

    [self.view addSubview:self.myPickView];
 
}
-(void)showPickView:(NSInteger)index
{
    if (index == 0) {
      
        choiceString = @"1";
        
        __weak typeof(self) weakSelf = self;

        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,PROVINCE_CITY_COUNTY] parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"一级地址", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;

            
            if (SUCCESS) {
                
                [strongSelf.provinceDataSource removeAllObjects];
                
                NSArray* area = dic[@"datas"][@"data"];
                
                for (NSDictionary *dict in area) {
                    HZDSAddressModel* model = [[HZDSAddressModel alloc]init];
                    
                    model.addressId = [dict[@"id"] stringValue];
                    
                    model.address = dict[@"name"];
                    
                    [strongSelf.provinceDataSource addObject:model];
                }
                
                [strongSelf.classPickView reloadAllComponents];
            }else{
                
                [JKToast showWithText:dic[@"msg"]];
                
            }

            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
            LOG(@"cuow", Json);
            
        }];

        
    }else if (index == 1){
        
        choiceString = @"2";

        
        __weak typeof(self) weakSelf = self;
        
        NSDictionary *dic = @{@"upid":_provinceModel.addressId};
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,PROVINCE_CITY_COUNTY] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"二级地址", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (SUCCESS) {
                
                [strongSelf.cityDataSource removeAllObjects];
                
                NSArray* area = dic[@"datas"][@"data"];
                
                for (NSDictionary *dict in area) {
                    HZDSAddressModel* model = [[HZDSAddressModel alloc]init];
                    
                    model.addressId = [dict[@"id"] stringValue];
                  
                    model.address = dict[@"name"];
                    
                    [strongSelf.cityDataSource addObject:model];
                }
               
                [strongSelf.classPickView reloadAllComponents];
            }else{
                
                [JKToast showWithText:dic[@"msg"]];
                
            }
            
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
            LOG(@"cuow", Json);
            
        }];
        
    }else if (index == 2){
        
        choiceString = @"3";

        
        __weak typeof(self) weakSelf = self;
        
        NSDictionary *dic = @{@"upid":_cityModel.addressId};
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,PROVINCE_CITY_COUNTY] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"二级地址", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (SUCCESS) {
                
                [strongSelf.countyDataSource removeAllObjects];
                
                NSArray* area = dic[@"datas"][@"data"];
                
                for (NSDictionary *dict in area) {
                    HZDSAddressModel* model = [[HZDSAddressModel alloc]init];
                    
                    model.addressId = [dict[@"id"] stringValue];
                    
                    model.address = dict[@"name"];
                    
                    [strongSelf.countyDataSource addObject:model];
                }
                
                [strongSelf.classPickView reloadAllComponents];
            }else{
                
                [JKToast showWithText:dic[@"msg"]];
                
            }
            
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
            LOG(@"cuow", Json);
            
        }];
    }
    
    
}
//返回有几列

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    if ([choiceString isEqualToString:@"1"]) {
        
        return _provinceDataSource.count;

    }else if ([choiceString isEqualToString:@"2"]){
        
        return _cityDataSource.count;

    }
 
    return _countyDataSource.count;
    
}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 20.0f;
    
}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    
    return  SCREEN_WIDTH;
    
}


//显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HZDSAddressModel *model;
   
    if ([choiceString isEqualToString:@"1"]) {
      
        model= _provinceDataSource[row];

        
    }else if ([choiceString isEqualToString:@"2"]){
        
        model = _cityDataSource[row];
        
    }else{
        
        model = _countyDataSource[row];
    }
    
    
    return model.address;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    HZDSAddressModel *model;
  
    if ([choiceString isEqualToString:@"1"]) {
        
        
        model= _provinceDataSource[row];
        
        _provinceModel = model;

        [_cityButton setTitle:@"" forState:UIControlStateNormal];
      
        [_cuntyBUtton setTitle:@"" forState:UIControlStateNormal];
        
        _cityModel = nil;
        
        _countyModel = nil;
        
    }else if ([choiceString isEqualToString:@"2"]){
        
        model = _cityDataSource[row];
        
        _cityModel = model;
        
        [_cuntyBUtton setTitle:@"" forState:UIControlStateNormal];

        _countyModel = nil;

    }else{
        
        model = _countyDataSource[row];
        
        _countyModel = model;
    }
    
  
}
-(void)rightButtonClick:(UIButton *)sender
{
    
    
    if ([choiceString isEqualToString:@"1"]) {
        
        
        if (_provinceModel == nil) {
            
            if (_provinceDataSource.count > 0) {
                
                _provinceModel = _provinceDataSource[0];
            }
            
        }
        
        [_provinceButton setTitle:_provinceModel.address forState:UIControlStateNormal];
        
    }else if ([choiceString isEqualToString:@"2"]){
        
        if (_cityModel == nil) {
            
            if (_cityDataSource.count > 0) {
                
                _cityModel = _cityDataSource[0];
            }
            
        }
        
        [_cityButton setTitle:_cityModel.address forState:UIControlStateNormal];
        
    }else{
        
        
        if (_countyModel == nil) {
            
            if (_countyDataSource.count > 0) {
                
                _countyModel = _countyDataSource[0];
            }
            
        }
        
        [_cuntyBUtton setTitle:_countyModel.address forState:UIControlStateNormal];

    }
    
    [_myPickView removeFromSuperview];
}
-(void)leftButtonClick:(UIButton *)sender
{
 
    
    [self.myPickView removeFromSuperview];
    
    
}
-(void)toAddAddress
{
    
    if ([_userNameTextField.text isEqualToString:@""] || [_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"收货人不可为空"];
    
    }else if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"手机号不可为空"];
        
    }else if ([_provinceButton.currentTitle isEqualToString:@""] || [_provinceButton.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"省份不可为空"];
   
    }else if ([_cityButton.currentTitle isEqualToString:@""] || [_cityButton.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"城市不可为空"];
    
    }else if ([_cuntyBUtton.currentTitle isEqualToString:@""] || [_cuntyBUtton.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"县区不可为空"];
  
    }else if ([_addressDetailTextView.text isEqualToString:@""] || [_addressDetailTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"详细地址不可为空"];
        
    }else if (_defaultString == nil){
        
        [JKToast showWithText:@"请选择是否默认地址"];
        
    }else{
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSDictionary * dict = @{@"data[defaults]":_defaultString,
                              @"data[addxm]":_userNameTextField.text,
                              @"data[addtel]":_phoneTextField.text,
                              @"data[province]":_provinceModel.addressId,
                              @"data[city]":_cityModel.addressId,
                              @"data[areas]":_countyModel.addressId,
                              @"data[addinfo]":_addressDetailTextView.text,
                              @"data[type]":@"goods"
                              };
        
        [dic addEntriesFromDictionary:dict];
        
        if (_orderID != nil) {
            
            [dic addEntriesFromDictionary:@{@"data[order_id]":_orderID}];
        }
        if (_LogID != nil) {
            
            [dic addEntriesFromDictionary:@{@"data[log_id]":_LogID}];
        }
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,ADDRESS_ADD] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"添加地址", dic);
            
            
            if (SUCCESS) {
                
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
            LOG(@"cuow", Json);
            
        }];
        
        
    }
}
-(void)toEditAddress
{
    if ([_userNameTextField.text isEqualToString:@""] || [_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"收货人不可为空"];
    
    }else if ([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"手机号不可为空"];
        
    }else if ([_provinceButton.currentTitle isEqualToString:@""] || [_provinceButton.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"省份不可为空"];
    
    }else if ([_cityButton.currentTitle isEqualToString:@""] || [_cityButton.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"城市不可为空"];
   
    }else if ([_cuntyBUtton.currentTitle isEqualToString:@""] || [_cuntyBUtton.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"县区不可为空"];
   
    }else if ([_addressDetailTextView.text isEqualToString:@""] || [_addressDetailTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"详细地址不可为空"];
        
    }else if (_defaultString == nil){
        
        [JKToast showWithText:@"请选择是否默认地址"];
        
    }else{
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

     NSDictionary * dict = @{@"address_id":_addressModel.addressId,
              @"data[defaults]":_defaultString,
                              @"data[addxm]":_userNameTextField.text,
                              @"data[addtel]":_phoneTextField.text,
                              @"data[province]":_provinceModel.addressId,
                              @"data[city]":_cityModel.addressId,
                              @"data[areas]":_countyModel.addressId,
                              @"data[addinfo]":_addressDetailTextView.text,
                              @"data[type]":@"goods"
                              };
        
        [dic addEntriesFromDictionary:dict];
        
        if (_orderID != nil) {
            
            [dic addEntriesFromDictionary:@{@"order_id":_orderID}];
        }
        if (_LogID != nil) {
            
            [dic addEntriesFromDictionary:@{@"log_id":_LogID}];
        }
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,ADDRESS_EDIT_INFO] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"编辑地址", dic);
            
            
            if (SUCCESS) {
                
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
            LOG(@"cuow", Json);
            
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
