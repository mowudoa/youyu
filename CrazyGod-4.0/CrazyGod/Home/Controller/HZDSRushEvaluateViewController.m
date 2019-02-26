//
//  HZDSRushEvaluateViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/26.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSRushEvaluateViewController.h"
#import "AFHTTPSessionManager.h"

@interface HZDSRushEvaluateViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet commentStar *starView;
@property (weak, nonatomic) IBOutlet UITextField *consumeMoney;
@property (weak, nonatomic) IBOutlet UITextView *evaluateTextView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;

@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property(copy,nonatomic) NSString *imageString;
@end

@implementation HZDSRushEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}

#pragma mark PRIVATE
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
    
    [CrazyNetWork CrazyRequest_Get:MY_ORDER_EVALUATE_INFO parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"评价", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            strongSelf.infoLabel.text = [NSString stringWithFormat:@"商品%@的评价",dic[@"datas"][@"tuan"][@"title"]];
            
            strongSelf.titleLabel.text = dic[@"datas"][@"tuan"][@"title"];
            
            strongSelf.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic[@"datas"][@"tuan"][@"tuan_price"] stringValue]];
            
            [strongSelf.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"tuan"][@"photo"]]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
//上传图片
- (IBAction)addImage:(UIButton *)sender {

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
//提价评价
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
        
        if ([_consumeMoney.text isEqualToString:@""] || [_consumeMoney.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            
        }else{
            
            [dic setObject:_consumeMoney.text forKey:@"data[cost]"];

        }
        
        [dic addEntriesFromDictionary:dict];
        
        
        [CrazyNetWork CrazyRequest_Post:MY_ORDER_EVALUATE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
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

-(void)viewDidLayoutSubviews
{
    UIView* conView = (UIView*)[_scrollView viewWithTag:2048];
    
    _scrollView.contentSize = CGSizeMake(0, conView.frame.origin.y+conView.frame.size.height + 20);
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
    [_addImageButton setImage:image forState:UIControlStateNormal];
    
    _imageString = dic[@"url"];
    
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
