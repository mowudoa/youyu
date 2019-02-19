//
//  CrazyTabBarController.h
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrazyTabBarController : UITabBarController

@property(nonatomic,strong)UIColor * tabbar_backgroundColor;
@property(nonatomic,strong)UIImage * tabbar_backgroundImage;
@property(nonatomic,strong)UIColor * tabbar_normal_titleColor;
@property(nonatomic,strong)UIColor * tabbar_select_titleColor;
@property(nonatomic,strong)UIImage * tabbar_select_itemBackGroundImage;
@property(nonatomic,strong)NSArray * tabbar_navi;

-(void)shareNormalImage:(NSArray *)normalImage SelectImage:(NSArray *)selectImage Title:(NSArray *)title;

@end
