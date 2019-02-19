//
//  CrazyAlumWithCamera.m
//  ocCrazy
//
//  Created by dukai on 16/1/4.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "CrazyAlumWithCamera.h"

@implementation CrazyAlumWithCamera

-(void)alertsheetUploadHeadImage:(UIViewController *)controller block:(ImageFinishBlock)ImageBlock{
    
    _sheetImgblock = ImageBlock;
    _VC = controller;
    
    UIActionSheet *sheet =  [[UIActionSheet alloc]initWithTitle:@"选择图片方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照相机选取",@"从相册中选取", nil];
    [sheet showInView:controller.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        [self readFromcamera:_VC block:^(UIImage *image) {
            if (_sheetImgblock) {
                _sheetImgblock(image);
            }
        }];
    }else if (buttonIndex ==1){
        [self readFromAlum:_VC block:^(UIImage *image) {
            if (_sheetImgblock) {
                _sheetImgblock(image);
            }
        }];
    }
}

-(void)readFromAlum:(id)viewController block:(ImageFinishBlock)ImageBlock
{
    
    if ((YES == [UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        )
    {
        
        _imgblock = ImageBlock;
        _VC = viewController;
        
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        //        cameraUI.mediaTypes =
        //        [UIImagePickerController availableMediaTypesForSourceType:
        //         UIImagePickerControllerSourceTypePhotoLibrary];
        [cameraUI setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        cameraUI.allowsEditing = YES;
        
        cameraUI.delegate = self;
        
        [viewController presentViewController:cameraUI animated:YES completion:nil];
        
    }
    
}
-(void)readFromcamera:(id)viewController block:(ImageFinishBlock)ImageBlock
{
    
    if ((YES == [UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera])
        )
    {
        
        _imgblock = ImageBlock;
        _VC = viewController;
        
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        cameraUI.mediaTypes =
        [UIImagePickerController availableMediaTypesForSourceType:
         UIImagePickerControllerSourceTypeCamera];
        
        cameraUI.allowsEditing = YES;
        
        cameraUI.delegate = self;
        
        [viewController presentViewController:cameraUI animated:YES completion:nil];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"打开照相机失败了" message:@"请检查照相机是否已损坏" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        
    }
    
}
#pragma mark UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    UIImage *originalImage, *editedImage;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        
        //  NSData *imageData= UIImageJPEGRepresentation(editedImage, 100);
        //    NSData*  imageData = UIImagePNGRepresentation(editedImage);
        
        // photoImageView.image = [UIImage imageWithData:imageData];
        
    }
    
    if (_imgblock) {
        _imgblock(editedImage);
    }
    
    [_VC dismissViewControllerAnimated: YES completion:nil];
    
}

@end
