//
//  HZDSEvaluateViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/25.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSEvaluateViewController.h"
#import "AFHTTPSessionManager.h"

@interface HZDSEvaluateViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntegralLabel;
@property (weak, nonatomic) IBOutlet commentStar *starView;
@property (weak, nonatomic) IBOutlet UITextView *evaluateTextView;
@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;

@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property(nonatomic,copy) NSString *imageString;

@end

@implementation HZDSEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
  
    [_evaluateTextView.layer setMasksToBounds:YES];
    [_evaluateTextView.layer setCornerRadius:5]; //设置矩形四个圆角半径
    //边框宽度
    [_evaluateTextView.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    _evaluateTextView.layer.borderColor=[UIColor colorWithHexString:@"f5f5f5"].CGColor;
    
    [_evaluateButton.layer setMasksToBounds:YES];
    [_evaluateButton.layer setCornerRadius:5];
    
    self.navigationItem.title = @"商品点评";
    
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"还记得这家店吗?写点评记录生活,分享体验";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_evaluateTextView addSubview:placeHolderLabel];
    
    // same font
    placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    
    [_evaluateTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
-(void)initData
{
  
    NSDictionary *dic = @{@"order_id":_order_id};
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:SHOPPING_MALL_ORDER_EVALUATE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"评价", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.headerTitleLabel.text = [NSString stringWithFormat:@"商品%@的评价",dic[@"datas"][@"goods"][@"title"]];
            
            strongSelf.goodsTitleLabel.text = dic[@"datas"][@"goods"][@"title"];
            
            strongSelf.goodsMoneyLabel.text = [NSString stringWithFormat:@"实付金额:%@",[dic[@"datas"][@"detail"][@"need_pay"] stringValue]];
            
            strongSelf.goodsIntegralLabel.text = [NSString stringWithFormat:@"使用积分数:%@",dic[@"datas"][@"detail"][@"use_integral"]];
            
            [strongSelf.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"goods"][@"photo"]]] placeholderImage:[UIImage imageNamed:@"baseImage"]];

        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
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

- (IBAction)uploadImage:(UIButton *)sender {

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

- (IBAction)evaluate:(UIButton *)sender {

    if ([_evaluateTextView.text isEqualToString:@""] || [_evaluateTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JKToast showWithText:@"评价内容不可为空"];
    }else{
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dict = @{@"order_id":_order_id,
                               @"data[score]":[NSString stringWithFormat:@"%ld",(long)_starView.currentStar],
                               @"data[contents]":_evaluateTextView
                               };
        
        
        if (_imageString != nil) {
            
            [dic setObject:_imageString forKey:@"photos[]"];
        }
        
        [dic addEntriesFromDictionary:dict];
        
        
        [CrazyNetWork CrazyRequest_Post:SHOPPING_MALL_ORDER_SUBMITEVALUATE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"提交评价", dic);
            
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
    [_uploadImageButton setImage:image forState:UIControlStateNormal];
    
    _imageString = dic[@"url"];
    
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
