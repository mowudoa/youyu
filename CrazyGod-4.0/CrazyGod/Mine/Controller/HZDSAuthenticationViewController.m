//
//  HZDSAuthenticationViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/18.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSAuthenticationViewController.h"
#import "AFHTTPSessionManager.h"

@interface HZDSAuthenticationViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIImageView *icCardImage;
@property (weak, nonatomic) IBOutlet UITextField *accountName;
@property (weak, nonatomic) IBOutlet UITextField *accontPhone;
@property (weak, nonatomic) IBOutlet UITextField *accountIDCard;
@property (weak, nonatomic) IBOutlet UITextView *detailAddress;
@property (weak, nonatomic) IBOutlet UIButton *authenticationButton;


@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property(nonatomic,copy) NSString *idCardImageString;
@end

@implementation HZDSAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"实名认证";
    
    [WYFTools CreateTextPlaceHolder:@"请输入详细地址" WithFont:[UIFont systemFontOfSize:14.0] WithSuperView:_detailAddress];
    
    _authenticationButton.layer.cornerRadius = _authenticationButton.frame.size.height/16*3;
    
    _authenticationButton.layer.masksToBounds = YES;
    
    [_detailAddress.layer setMasksToBounds:YES];
    [_detailAddress.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_detailAddress.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _detailAddress.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    

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

-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:AUTHENTICATION_INFO parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"获取认证用户信息", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
            
            if (dic[@"datas"][@"MEMBER"][@"nickname"] == NULL || dic[@"datas"][@"MEMBER"][@"nickname"] == nil ||dic[@"datas"][@"MEMBER"][@"nickname"] == [NSNull null]) {
                
                
            }else{
                
                strongSelf.accountName.text = dic[@"datas"][@"MEMBER"][@"nickname"];
                
            }
            
            if (dic[@"datas"][@"MEMBER"][@"mobile"] == NULL || dic[@"datas"][@"MEMBER"][@"mobile"] == nil ||dic[@"datas"][@"MEMBER"][@"mobile"] == [NSNull null]) {
                
            }else{
                
                strongSelf.accontPhone.text = dic[@"datas"][@"MEMBER"][@"mobile"];

            }
            
            
        }else{
          
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
//点击拍照/相册
- (IBAction)cameraClick:(UIButton *)sender {

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
            
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}
//立即认证
- (IBAction)authenticationClick:(UIButton *)sender {

    
    if ([_accountName.text isEqualToString:@""] || [_accountName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"姓名不可为空"];
    }else if ([_accontPhone.text isEqualToString:@""] || [_accontPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"手机号不可为空"];
    }else if ([_accountIDCard.text isEqualToString:@""] || [_accountIDCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"身份证号不可为空"];
    }else if ([_detailAddress.text isEqualToString:@""] || [_detailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"地址不可为空"];
    }else if (_idCardImageString == nil){
        
        [JKToast showWithText:@"f身份证照片不可为空"];
    }else{
    
        NSDictionary *urlDic = @{@"data[card_photo]":_idCardImageString,
                                 @"data[name]":_accountName.text,
                                 @"data[mobile]":_accontPhone.text,
                                 @"data[card_id]":_accountIDCard.text,
                                 @"data[addr_info]":_detailAddress.text};
        [CrazyNetWork CrazyRequest_Post:AUTHENTICATION parameters:urlDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"会员认证", dic);
            
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

    _icCardImage.image = image;
    
    _idCardImageString = dic[@"url"];
    
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
