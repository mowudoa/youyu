//
//  easyflyScreenShot.m
//  easyflyDemo
//
//  Created by dukai on 15/6/2.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import "CrazyScreenShot.h"

@implementation CrazyScreenShot

-(void)ScreenShot:(UIView *)screenView{
    
    
    //截图
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    if (_rect.size.width <1) {
        _rect = [UIScreen mainScreen].bounds;//这里可以设置想要截图的区域
    }
   
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, _rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"result.png"];
    NSLog(@"%@", savedImagePath);
    [imageViewData writeToFile:savedImagePath atomically:YES];
    CGImageRelease(imageRefRect);

    
    
}


@end
