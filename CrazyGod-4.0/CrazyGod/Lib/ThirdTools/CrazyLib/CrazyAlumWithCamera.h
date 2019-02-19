//
//  CrazyAlumWithCamera.h
//  ocCrazy
//
//  Created by dukai on 16/1/4.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageFinishBlock)(UIImage *image);
typedef void (^sheetFinishBlock)(UIImage *image);

@interface CrazyAlumWithCamera : NSObject<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)ImageFinishBlock imgblock;
@property(nonatomic,strong)sheetFinishBlock sheetImgblock;
@property(nonatomic,strong)id VC;

-(void)alertsheetUploadHeadImage:(UIViewController *)controller  block:(sheetFinishBlock)ImageBlock;
-(void)readFromAlum:(id)viewController block:(ImageFinishBlock)ImageBlock;
-(void)readFromcamera:(id)viewController block:(ImageFinishBlock)ImageBlock;

@end
