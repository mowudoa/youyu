//
//  HZDSUnderLineViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/8.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSUnderLineViewController.h"
#import "AFHTTPSessionManager.h"
#import "HZDSBusinessModel.h"
#import "HZDSCityListModel.h"


@interface HZDSUnderLineViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>
{
    
    NSString *choiceID;
    
    NSString *classFatherID;
    
    NSString *classSubID;
    
    NSString *classFatherName;
    
    NSString *classSubName;
    
    NSString *areaOneID;
    
    NSString *areaTwoID;
    
    NSString *areaThressID;
    
    NSString *areaOneName;
    
    NSString *areaTwoName;
    
    NSString *areaThressName;
    
}
@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@property (weak, nonatomic) IBOutlet UIImageView *contractImage;

@property (weak, nonatomic) IBOutlet UIImageView *businessImage;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (weak, nonatomic) IBOutlet UIImageView *idCardFace;

@property (weak, nonatomic) IBOutlet UIImageView *idCardOpposite;

@property (weak, nonatomic) IBOutlet UIImageView *BusinessLicense;

@property (weak, nonatomic) IBOutlet UITextField *businessNameTF;

@property (weak, nonatomic) IBOutlet UITextField *businessRecommendUserTF;

@property (weak, nonatomic) IBOutlet UITextField *businessShopNameTF;

@property (weak, nonatomic) IBOutlet UITextField *legalPersonTF;

@property (weak, nonatomic) IBOutlet UITextField *legalPersonPhoneTF;

@property (weak, nonatomic) IBOutlet UITextField *ShopProportionTF;

@property (weak, nonatomic) IBOutlet UIButton *businessClassButton;

@property (weak, nonatomic) IBOutlet UIButton *businessAreaButton;

@property (weak, nonatomic) IBOutlet UITextField *businessPhoneTF;

@property (weak, nonatomic) IBOutlet UITextField *businessUserNameTF;

@property (weak, nonatomic) IBOutlet UITextField *businessShopPhoneTF;

@property (weak, nonatomic) IBOutlet UITextField *businessAddressTF;

@property (weak, nonatomic) IBOutlet UILabel *businessCoordinateLabel;

@property (weak, nonatomic) IBOutlet UILabel *businessCoordinateLabelY;

@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@property (weak, nonatomic) IBOutlet UITextField *businessHoursTF;

@property (weak, nonatomic) IBOutlet UITextView *businessInfoTextView;

@property (weak, nonatomic) IBOutlet UIButton *SettledButton;

@property (weak, nonatomic) IBOutlet UITextField *SettlementPhoneTF;

@property (weak, nonatomic) IBOutlet UIView *contractView;//合同照片view

@property (weak, nonatomic) IBOutlet UIView *businessIconView;//商户形象view

@property (weak, nonatomic) IBOutlet UIView *logoView;//LOGO

@property (weak, nonatomic) IBOutlet UIView *idCardView;//身份证正面照

@property (weak, nonatomic) IBOutlet UIView *idCardOutFaceView;//身份证反面照

@property (weak, nonatomic) IBOutlet UIView *businessLIcenseView;//营业执照

@property (weak, nonatomic) IBOutlet UILabel *taglabel;

@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (weak, nonatomic) IBOutlet UIView *AgreementView;

@property (weak, nonatomic) IBOutlet UITextView *agreementTextView;

@property (weak, nonatomic) IBOutlet UIView *bankGroundView;

@property(nonatomic,strong) NSMutableArray *businessClassArray;

@property(nonatomic,strong) NSMutableArray *businessCityArray;

@property(nonatomic,copy) NSString *imageClassString;

@property(nonatomic,strong) UIPickerView *classPickView;

@property(nonatomic,strong) UIView *myPickView;

@property(nonatomic,copy) NSString *parent_id;

@property(nonatomic,copy) NSString *parent_Name;

@end

@implementation HZDSUnderLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _businessClassArray = [[NSMutableArray alloc] init];
    
    _businessCityArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self initData];
    
    [self initCityData];
    
}
-(void)initUI
{
 
    [_contractView.layer setMasksToBounds:YES];
    
    [_contractView.layer setCornerRadius:5]; //设置矩形四个圆角半径
        //边框宽度
    [_contractView.layer setBorderWidth:1.0];
        //设置边框颜色有两种方法：第一种如下:
    _contractView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    [_businessIconView.layer setMasksToBounds:YES];
    
    [_businessIconView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_businessIconView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _businessIconView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    [_logoView.layer setMasksToBounds:YES];
    
    [_logoView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_logoView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _logoView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    [_idCardView.layer setMasksToBounds:YES];
    
    [_idCardView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_idCardView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _idCardView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    [_idCardOutFaceView.layer setMasksToBounds:YES];
   
    [_idCardOutFaceView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_idCardOutFaceView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _idCardOutFaceView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    [_businessLIcenseView.layer setMasksToBounds:YES];
    
    [_businessLIcenseView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_businessLIcenseView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _businessLIcenseView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    
    [_businessInfoTextView.layer setMasksToBounds:YES];
    
    [_businessInfoTextView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_businessInfoTextView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _businessInfoTextView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    _SettledButton.layer.cornerRadius = _SettledButton.frame.size.height/16*3;
    
    _SettledButton.layer.masksToBounds = YES;
    
    _addressButton.layer.cornerRadius = 5;
    
    _addressButton.layer.masksToBounds = YES;
    
    self.navigationItem.title = @"线下入驻";
    
    [self initAgreement];
}
-(void)initAgreement
{
 _agreementTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    
}
- (UIPickerView *)classPickView {
    if (!_classPickView) {
        _classPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44,SCREEN_WIDTH, 320)];
        
        _classPickView.delegate = self;
        
        _classPickView.dataSource = self;
        
        _classPickView.backgroundColor = [UIColor redColor];
        
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
        
        [_myPickView addSubview:leftCancleButton];
        
    }
    
    return _myPickView;
}
-(void)rightButtonClick:(UIButton *)sender
{
    
    [_myPickView removeFromSuperview];
    
    if ([choiceID isEqualToString:@"100"]) {
     
        NSMutableString *str = [[NSMutableString alloc] init];
        
        if (classFatherName != nil) {
            
            [str appendString:classFatherName];
        }
        if (classSubName != nil) {
            
            [str appendString:classSubName];
        }
        
        [_businessClassButton setTitle:str forState:UIControlStateNormal];
    }else{
       
        NSMutableString *str1 = [[NSMutableString alloc] init];
        
        if (areaOneName != nil) {
            
            [str1 appendString:areaOneName];
        }
        if (areaTwoName != nil) {
            
            [str1 appendString:areaTwoName];
        }
        if (areaThressName != nil) {
            
            [str1 appendString:areaThressName];
        }
        
        [_businessAreaButton setTitle:str1 forState:UIControlStateNormal];
    }
    
}
-(void)leftButtonClick:(UIButton *)sender
{
    
    [_myPickView removeFromSuperview];

}
-(void)initData
{
    __weak typeof(self) weakSelf = self;

    
    [CrazyNetWork CrazyRequest_Get:UNDERLINE_INFO parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"线下信息", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.businessClassArray removeAllObjects];
        
        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            
            
            if (dic[@"datas"][@"parent_id"][@"fuid1"] == NULL || dic[@"datas"][@"parent_id"][@"fuid1"] == nil ||dic[@"datas"][@"parent_id"][@"fuid1"] == [NSNull null]) {
                
            }else{
                
                strongSelf.parent_id = dic[@"datas"][@"parent_id"][@"fuid1"];

            }
            
            
            if (dic[@"datas"][@"p_nickname"] == NULL || dic[@"datas"][@"p_nickname"] == nil ||dic[@"datas"][@"p_nickname"] == [NSNull null]) {
                
            }else{
                
                strongSelf.businessRecommendUserTF.text = dic[@"datas"][@"p_nickname"];
            }
            
            
            NSArray* List = dic[@"datas"][@"cates"];
            
            if (List == nil) {
               
                strongSelf.tagView.hidden = NO;
                
                strongSelf.mainScrollview.hidden = YES;
                
                strongSelf.taglabel.text = dic[@"datas"][@"msg"];
            }else{
                
                strongSelf.tagView.hidden = YES;
               
                strongSelf.mainScrollview.hidden = NO;
                
                strongSelf.bankGroundView.hidden = NO;
                
                strongSelf.AgreementView.hidden = NO;
                
            }
            
            for (NSDictionary *dict in List) {
                
                HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
                
                model.businessId = dict[@"cate_id"];
                
                model.businessName = dict[@"cate_name"];
                
                [model.goodsArray addObjectsFromArray:dict[@"son"]];
                
                [strongSelf.businessClassArray addObject:model];
            }
            
            
        }else{
            
            [JKToast showWithText:dic[@"msg"]];
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
 
}
-(void)initCityData
{
 
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *urlDict = @{@"name":@"cityareas" };

    
    [CrazyNetWork CrazyRequest_Post:CITY_LIST parameters:urlDict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"城市信息", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.businessCityArray removeAllObjects];
        
        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            NSArray* List = dic[@"city"];
            
            for (NSDictionary *dict in List) {
                
                HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
                
                model.businessId = dict[@"city_id"];
                
                model.businessName = dict[@"name"];
                
                NSArray *areaArr = dict[@"area"];
                
                for (NSDictionary *dict1 in areaArr){
                    
                    HZDSCityListModel *model2 = [[HZDSCityListModel alloc] init];
                    
                    model2.citysId = dict1[@"area_id"];
                   
                    model2.citysName = dict1[@"area_name"];
                    
                    [model2.cityListArray addObjectsFromArray:dict1[@"business"]];
                    
                    [model.goodsArray addObject:model2];
                }
                
                
                [strongSelf.businessCityArray addObject:model];
            }
            
            
        }else{
            
            [JKToast showWithText:dic[@"msg"]];
        }
        [strongSelf.classPickView reloadAllComponents];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        LOG(@"cuow", Json);
        
        NSData *jsonData = [Json dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray* List = dic[@"city"];
        
        for (NSDictionary *dict in List) {
            
            HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
            
            model.businessId = dict[@"city_id"];
            
            model.businessName = dict[@"name"];
            
            NSArray *areaArr = dict[@"area"];
            
            for (NSDictionary *dict1 in areaArr){
                
                HZDSCityListModel *model2 = [[HZDSCityListModel alloc] init];
                
                model2.citysId = dict1[@"area_id"];
               
                model2.citysName = dict1[@"area_name"];
                
                [model2.cityListArray addObjectsFromArray:dict1[@"business"]];
                
                [model.goodsArray addObject:model2];
            }
            
            
            [strongSelf.businessCityArray addObject:model];
        }
        [strongSelf.classPickView reloadAllComponents];

    }];
}

-(UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        _imagePicker.allowsEditing = YES;
        
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}
#pragma  mark ==== UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSLog(@"访问相机拍照");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
            
        }
        
    }else if (buttonIndex == 1){
        
        NSLog(@"相册选择");
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:_imagePicker animated:YES completion:NULL];
        
    }else if (buttonIndex == 2){
        
        NSLog(@"取消");
    }
    
}
#pragma mark ==== UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(changePhoto:) withObject:orgImage afterDelay:0.1];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changePhoto:(UIImage*)image
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:UPLOADIMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageDatas = UIImageJPEGRepresentation(image,0.4);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"====成功====");
        
        [self saveUrl:responseObject withImage:image];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"======失败======");
    }];
    
    
}
-(void)saveUrl:(NSDictionary *)dic withImage:(UIImage *)image
{
    
    if ([_imageClassString isEqualToString:@"HETONG"]) {
        
        _contractImage.image = image;
        
        [USER_DEFAULT setObject:dic[@"url"] forKey:@"HETONG"];
        
    }else if ([_imageClassString isEqualToString:@"SHANGHU"])
    {
        _businessImage.image = image;
        
        [USER_DEFAULT setObject:dic[@"url"] forKey:@"SHANGHU"];

    }else if ([_imageClassString isEqualToString:@"LOGO"])
    {
        _logoImage.image = image;
        
        [USER_DEFAULT setObject:dic[@"url"] forKey:@"LOGO"];

    }else if ([_imageClassString isEqualToString:@"IDCARDFACE"])
    {
        _idCardFace.image = image;
        
        [USER_DEFAULT setObject:dic[@"url"] forKey:@"IDCARDFACE"];

    }else if ([_imageClassString isEqualToString:@"IDCARDOUTFACE"])
    {
        _idCardOpposite.image = image;
        
        [USER_DEFAULT setObject:dic[@"url"] forKey:@"IDCARDOUTFACE"];

    }else if ([_imageClassString isEqualToString:@"ZHIZHAO"])
    {
        _BusinessLicense.image = image;
        
        [USER_DEFAULT setObject:dic[@"url"] forKey:@"ZHIZHAO"];
        
    }
    
    
}
#pragma mark pickerview function

//返回有几列

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    if ([choiceID isEqualToString:@"100"]) {
        
        return 2;
    }
    
    return 3;
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    if ([choiceID isEqualToString:@"100"]) {
    
            if (component == 0) {
        
                return _businessClassArray.count;
        
            }else{
        
                NSInteger selectRow = [pickerView selectedRowInComponent:0];
        
        
                if (_businessClassArray.count == 0) {
        
                    return 0;
                }
        
                HZDSBusinessModel *model = _businessClassArray[selectRow];
        
                return model.goodsArray.count;
        
            }
    }else{
        
        if (component == 0) {
            
            return _businessCityArray.count;
            
        }else if (component == 1){
            
            NSInteger selectRow = [pickerView selectedRowInComponent:0];
            
            
            if (_businessCityArray.count == 0) {
                
                return 0;
            }
            
            HZDSBusinessModel *model = _businessCityArray[selectRow];
            
            return model.goodsArray.count;
            
        }else{
            
            NSInteger selectRow = [pickerView selectedRowInComponent:1];
            
            NSInteger selectRow1 = [pickerView selectedRowInComponent:0];
            
            
            if (_businessCityArray.count == 0) {
                
                return 0;
            }
            
            
            
            HZDSBusinessModel *model = _businessCityArray[selectRow1];
            
            if (model.goodsArray.count == 0) {
                
                return 0;
            }
            
            
            HZDSCityListModel *model1 = model.goodsArray[selectRow];
            
            return model1.cityListArray.count;
            
        }
        
    }

}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 20.0f;
    
}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    
    return  SCREEN_WIDTH/3;
    
}

//显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ([choiceID isEqualToString:@"100"]) {
     
            if (component == 0) {
        
                 HZDSBusinessModel *model= _businessClassArray[row];
        
                return model.businessName;
        
            }else{
        
                NSInteger selectRow = [pickerView selectedRowInComponent:0];
        
        
                HZDSBusinessModel *model = _businessClassArray[selectRow];
        
                return [model.goodsArray[row] objectForKey:@"cate_name"];
        
            }
        
    }else{
      
        if (component == 0) {
            
            HZDSBusinessModel *model= _businessCityArray[row];
            
            return model.businessName;
            
        }else if (component == 1){
            
            NSInteger selectRow = [pickerView selectedRowInComponent:0];
            
            HZDSBusinessModel *model = _businessCityArray[selectRow];
            
            HZDSCityListModel *model1 = model.goodsArray[row];
            
            return model1.citysName;
            
        }else{
            
            NSInteger selectRow = [pickerView selectedRowInComponent:1];
            
            NSInteger selectRow1 = [pickerView selectedRowInComponent:0];
            
            HZDSBusinessModel *model = _businessCityArray[selectRow1];
            
            HZDSCityListModel *model1 = model.goodsArray[selectRow];
            
            return [model1.cityListArray[row] objectForKey:@"business_name"];
            
        }
        
    }
    

    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ([choiceID isEqualToString:@"100"]) {
        
        if (component == 0) {
            
            [pickerView reloadComponent:1];
            
            classFatherID = nil;
            
            classFatherName = nil;
            
            NSInteger selectRow = [pickerView selectedRowInComponent:0];
            
            HZDSBusinessModel *model= _businessClassArray[selectRow];
            
            classFatherID = model.businessId;
            
            classFatherName = model.businessName;
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            classSubName = [model.goodsArray[0] objectForKey:@"cate_name"];
            
            classSubID = [model.goodsArray[0] objectForKey:@"cate_id"];
            
        }else if (component == 1){
         
            classSubID = nil;
           
            classSubName = nil;
            
            NSInteger selectRow = [pickerView selectedRowInComponent:0];
            
            NSInteger selectRow1 = [pickerView selectedRowInComponent:1];
            
            HZDSBusinessModel *model = _businessClassArray[selectRow];
            
            classSubName = [model.goodsArray[selectRow1] objectForKey:@"cate_name"];
            
            classSubID = [model.goodsArray[selectRow1] objectForKey:@"cate_id"];

        }else{
            
        }
    }else{
        
        if (component == 0) {
            
            areaOneID = nil;
           
            areaOneName = nil;
            
            [pickerView reloadComponent:1];
           
            [pickerView reloadComponent:2];
            
            NSInteger selectRow = [pickerView selectedRowInComponent:0];
            
            HZDSBusinessModel *model= _businessCityArray[selectRow];
            
            areaOneID = model.businessId;
            
            areaOneName = model.businessName;
            
            if (model.goodsArray.count > 0) {
             
                HZDSCityListModel *model1 = model.goodsArray[0];
                
                areaTwoID = model1.citysId;
                
                areaTwoName = model1.citysName;
                
                if (model1.cityListArray.count > 0) {
                 
                    areaThressID = [model1.cityListArray[0] objectForKey:@"business_id"];
                    
                    areaThressName = [model1.cityListArray[0] objectForKey:@"business_name"];
                    
                    [pickerView selectRow:0 inComponent:2 animated:YES];

                }else{
                    
                    areaThressName = nil;
                   
                    areaThressID = nil;
                    
                }
                
                [pickerView selectRow:0 inComponent:1 animated:YES];
            }else{
               
                areaTwoName = nil;
                
                areaTwoID = nil;
                
                areaThressName = nil;
                
                areaThressID = nil;
            }
            
        }else if (component == 1){
            
            areaTwoName = nil;
            
            areaTwoID = nil;
            
            [pickerView reloadComponent:2];

            
            NSInteger selectRow = [pickerView selectedRowInComponent:0];
            
            NSInteger selectRow1 = [pickerView selectedRowInComponent:1];
            
            HZDSBusinessModel *model = _businessCityArray[selectRow];
            
            HZDSCityListModel *model1 = model.goodsArray[selectRow1];

            areaTwoID = model1.citysId;
            
            areaTwoName = model1.citysName;
            
            
            if (model1.cityListArray.count > 0) {
             
                [pickerView selectRow:0 inComponent:2 animated:YES];
                
                areaThressID = [model1.cityListArray[0] objectForKey:@"business_id"];
                
                areaThressName = [model1.cityListArray[0] objectForKey:@"business_name"];
            }else{
                
                areaThressName = nil;
                
                areaThressID = nil;
            }
            
         
            
        }else{
          
            areaThressName = nil;
            
            areaThressID = nil;
            
            NSInteger selectRow = [pickerView selectedRowInComponent:1];
            
            NSInteger selectRow1 = [pickerView selectedRowInComponent:0];
            
            HZDSBusinessModel *model = _businessCityArray[selectRow1];
            
            HZDSCityListModel *model1 = model.goodsArray[selectRow];

            areaThressID = [model1.cityListArray[selectRow1] objectForKey:@"business_id"];
            
            areaThressName = [model1.cityListArray[selectRow1] objectForKey:@"business_name"];

        }
        
        
    }
    
    
}
-(void)viewDidLayoutSubviews
{
    UIView* conView = (UIView*)[_mainScrollview viewWithTag:2048];
    
    _mainScrollview.contentSize = CGSizeMake(0, conView.frame.origin.y+conView.frame.size.height + 10);
    
}
- (IBAction)clickcameracameraclickCamera:(UIButton *)sender {
  
    switch (sender.tag) {
        case 300:
            _imageClassString = @"HETONG";
            break;
        case 301:
            _imageClassString = @"SHANGHU";
            break;
        case 302:
            _imageClassString = @"LOGO";
            break;
        case 303:
            _imageClassString = @"IDCARDFACE";
            break;
        case 304:
            _imageClassString = @"IDCARDOUTFACE";
            break;
        case 305:
            _imageClassString = @"ZHIZHAO";
            break;
        default:
            break;
    }
    
    
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    
    acSheet.tag = sender.tag;
    
    [acSheet showInView:self.view];
    
}
- (IBAction)clickSettled:(UIButton *)sender
{
    NSMutableDictionary *businessInfo = [[NSMutableDictionary alloc] init];
    
    if (_parent_id != nil) {
        
        [businessInfo addEntriesFromDictionary:@{@"user_guide_id" :_parent_id}];
    }
    if ([_businessShopPhoneTF.text isEqualToString:@""] || [_businessShopPhoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
    }else{
        
        [businessInfo addEntriesFromDictionary:@{@"zuo_tel" :_businessShopPhoneTF.text}];
    }
    
    
    if ([_businessNameTF.text isEqualToString:@""] || [_businessNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"商户名不可为空"];
   
    }else if ([_businessShopNameTF.text isEqualToString:@""] || [_businessShopNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"企业名称不可为空"];
        
    }else if ([_legalPersonTF.text isEqualToString:@""] || [_legalPersonTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"法人姓名不可为空"];
        
    }else if ([_legalPersonPhoneTF.text isEqualToString:@""] || [_legalPersonPhoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"法人联系方式不可为空"];
        
    }else if ([_ShopProportionTF.text isEqualToString:@""] || [_ShopProportionTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"合作比例不可为空"];
        
    }else if ([_businessPhoneTF.text isEqualToString:@""] || [_businessPhoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商户不可为空"];
        
    }else if ([_businessUserNameTF.text isEqualToString:@""] || [_businessUserNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商家联系人不可为空"];
        
    }else if ([_businessPhoneTF.text isEqualToString:@""] || [_businessPhoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"联系手机不可为空"];
        
    }else if ([_businessAddressTF.text isEqualToString:@""] || [_businessAddressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商家地址不可为空"];
        
    }else if ([_businessCoordinateLabel.text isEqualToString:@""] || [_businessCoordinateLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"坐标不可为空"];
        
    }else if ([_businessCoordinateLabelY.text isEqualToString:@""] || [_businessCoordinateLabelY.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"坐标不可为空"];
        
    }else if ([_businessHoursTF.text isEqualToString:@""] || [_businessHoursTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"营业时间不可为空"];
        
    }else if ([_businessInfoTextView.text isEqualToString:@""] || [_businessInfoTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商家描述不可为空"];
        
    }else if ([_SettlementPhoneTF.text isEqualToString:@""] || [_SettlementPhoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"结算手机不可为空"];
        
    }else if ([USER_DEFAULT objectForKey:@"HETONG"] == nil) {
        
        [JKToast showWithText:@"请上传合同照"];
        
    }else if ([USER_DEFAULT objectForKey:@"SHANGHU"] == nil){
        
        [JKToast showWithText:@"请上传商户图片"];
        
        
    }else if ([USER_DEFAULT objectForKey:@"LOGO"] == nil){
       
        [JKToast showWithText:@"请上传LOGO"];
        
    }else if ([USER_DEFAULT objectForKey:@"IDCARDFACE"] == nil){
        
        [JKToast showWithText:@"请上传身份证正面照"];
        
    }else if ([USER_DEFAULT objectForKey:@"IDCARDOUTFACE"] == nil){
        
        [JKToast showWithText:@"请上传身份证反面照"];
        
        
    }else if ([USER_DEFAULT objectForKey:@"ZHIZHAO"] == nil){
        
        [JKToast showWithText:@"请上传营业执照"];
        
    }else{
        
        NSDictionary *dic = @{@"shop_name":_businessShopNameTF.text,
                              @"qiye_name":_businessShopNameTF.text,
                              @"faren_name":_legalPersonTF.text,
                              @"faren_mobile":_legalPersonPhoneTF.text,
                              @"xianxia_jiesuan":_ShopProportionTF.text,
                              @"parent_id":classFatherID,
                              @"cate_id":classSubID,
                              @"city_id":areaOneID,
                              @"area_id":areaTwoID,
                              @"business_id":areaThressID,
                              @"contact":_businessUserNameTF.text,
                              @"mobile":_businessPhoneTF.text,
                              @"tel":_SettlementPhoneTF.text,
                              @"addr":_businessAddressTF.text,
                              @"business_time":_businessHoursTF.text,
                              @"lng":_businessCoordinateLabel.text,
                              @"lat":_businessCoordinateLabelY.text,
                              @"business_license":[USER_DEFAULT objectForKey:@"ZHIZHAO"],
                              @"people_id_y":[USER_DEFAULT objectForKey:@"IDCARDOUTFACE"],
                              @"people_id_x":[USER_DEFAULT objectForKey:@"IDCARDFACE"],
                              @"logo":[USER_DEFAULT objectForKey:@"LOGO"],
                              @"photo":[USER_DEFAULT objectForKey:@"SHANGHU"],
                              @"compact":[USER_DEFAULT objectForKey:@"HETONG"],
                              @"details":_businessInfoTextView.text
                              };
        
        [businessInfo addEntriesFromDictionary:dic];
      
        [CrazyNetWork CrazyRequest_Post:UNDERLINE_APPLY parameters:businessInfo HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"线下入驻申请", dic);
            
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
- (IBAction)getAddressCode:(UIButton *)sender
{
    
    
    if ([_businessAddressTF.text isEqualToString:@""] || [_businessAddressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"地址不可为空"];
    
    }else{
       
        __weak typeof(self) weakSelf = self;
  
        NSDictionary *urlDict = @{@"address":_businessAddressTF.text};
        
        [CrazyNetWork CrazyRequest_Post:ADDRESS_COORDINATE parameters:urlDict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"坐标转换", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (SUCCESS) {
               
                strongSelf.businessCoordinateLabel.text = [dic[@"datas"][@"data"][@"lng"] stringValue];
                
                strongSelf.businessCoordinateLabelY.text = [dic[@"datas"][@"data"][@"lat"] stringValue];
                
            }else{
             
                [JKToast showWithText:dic[@"datas"][@"error"]];
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
    
}
- (IBAction)AreaClass:(UIButton *)sender
{

    choiceID = @"101";
    
    for (UIView *view in self.myPickView.subviews) {
        
        if ([view isKindOfClass:[UIPickerView class]]) {
            
            [view removeFromSuperview];
        }
        
    }
    
    UIPickerView *pickView = [self createPickView];
    
    [self.myPickView addSubview:pickView];
    
    [self.view addSubview:self.myPickView];
    
    
    [pickView reloadAllComponents];

    HZDSBusinessModel *model= _businessCityArray[0];
    
    areaOneID = model.businessId;
    
    areaOneName = model.businessName;
    
    if (model.goodsArray.count > 0) {
        
        HZDSCityListModel *model1 = model.goodsArray[0];
        
        areaTwoID = model1.citysId;
        
        areaTwoName = model1.citysName;
        
        if (model1.cityListArray.count > 0) {
           
            areaThressID = [model1.cityListArray[0] objectForKey:@"business_id"];
            
            areaThressName = [model1.cityListArray[0] objectForKey:@"business_name"];
        }
    }
    
}
-(UIPickerView *)createPickView
{
   
    UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44,SCREEN_WIDTH, 200)];
    
    pickView.delegate = self;
    
    pickView.dataSource = self;
    
    return pickView;
}

- (IBAction)businessClass:(UIButton *)sender {

    choiceID = @"100";
    
    for (UIView *view in self.myPickView.subviews) {
        
        if ([view isKindOfClass:[UIPickerView class]]) {
            
            [view removeFromSuperview];
        }
        
    }
    
    
    UIPickerView *pickView = [self createPickView];
    
    [self.myPickView addSubview:pickView];
    
    [self.view addSubview:self.myPickView];
    
    [pickView reloadAllComponents];
    
    HZDSBusinessModel *model= _businessClassArray[0];
    
    classFatherID = model.businessId;
    
    classFatherName = model.businessName;
    
    if (model.goodsArray.count > 0) {
     
        classSubName = [model.goodsArray[0] objectForKey:@"cate_name"];
        
        classSubID = [model.goodsArray[0] objectForKey:@"cate_id"];
    }
    
}
- (IBAction)agreeBtn:(UIButton *)sender {

    _AgreementView.hidden = YES;
    
    _bankGroundView.hidden = YES;
}
- (IBAction)backBtn:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
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
