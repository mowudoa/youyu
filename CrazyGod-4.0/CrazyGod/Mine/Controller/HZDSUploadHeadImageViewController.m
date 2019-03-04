//
//  HZDSUploadHeadImageViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSUploadHeadImageViewController.h"
#import "AFHTTPSessionManager.h"

@interface HZDSUploadHeadImageViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIImageView *oldImage;

@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property(nonatomic,copy) NSString *headImageString;

@end

@implementation HZDSUploadHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"修改头像";
    
    [self initUI];
}
-(void)initUI
{

    
    [_oldImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,[USER_DEFAULT objectForKey:@"face"]]] placeholderImage:[UIImage imageNamed:@"1213per"]];
    
    [WYFTools viewLayer:_oldImage.frame.size.height/2 withView:_oldImage];
    
    [WYFTools viewLayer:_confirmButton.frame.size.height/16*3 withView:_confirmButton];
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

- (IBAction)uploadNewIcon:(UIButton *)sender {

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
- (IBAction)UserNewIcon:(UIButton *)sender {

    if (_headImageString == nil) {
        
        [JKToast showWithText:@"请选择头像图片"];
        
    }else{
    
        NSDictionary *dic = @{@"avatar":_headImageString};
        
        [CrazyNetWork CrazyRequest_Post:CHANGEICON_USER parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"修改头像", dic);
            
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
    [_addImageButton setImage:image forState:UIControlStateNormal];
   
    _headImageString = dic[@"url"];
    
    _confirmButton.hidden = NO;
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
