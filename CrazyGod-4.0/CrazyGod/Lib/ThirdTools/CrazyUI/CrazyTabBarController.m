//
//  CrazyTabBarController.m
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "CrazyTabBarController.h"

@interface CrazyTabBarController ()

@end

@implementation CrazyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTabbar_navi:(NSArray *)tabbar_navi{
    self.viewControllers = tabbar_navi;
}
-(void)shareNormalImage:(NSArray *)normalImage SelectImage:(NSArray *)selectImage Title:(NSArray *)title{
    
    if (self.viewControllers.count == 0) {
        NSLog(@"navi_tabbar 不能为空");return;
    }
    if (normalImage.count != self.viewControllers.count) {
        NSLog(@"normalImage 不能为空 检查数组数量");return;
    }
    if (selectImage.count != self.viewControllers.count) {
        NSLog(@"selectImage 不能为空 检查数组数量");return;
    }
    if (title.count != self.viewControllers.count) {
        NSLog(@"title 不能为空 检查数组数量");return;
    }
    
    for (int i = 0 ; i < self.tabbar_navi.count; i++) {
        [self initTabbarItem:normalImage[i] selectImage:selectImage[i] title:title[i] index:i];
    }
    
    if (self.tabbar_backgroundColor != nil) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
        backView.backgroundColor = self.tabbar_backgroundColor;
        
        [self.tabBar insertSubview:backView atIndex:0];
        self.tabBar.opaque = false;
    }
    if (self.tabbar_backgroundImage != nil) {
        self.tabBar.backgroundImage = self.tabbar_backgroundImage;
    }
    if (self.tabbar_select_itemBackGroundImage != nil) {
        UIImage *itemBackImg = [self OriginImage:self.tabbar_select_itemBackGroundImage];
        self.tabBar.selectionIndicatorImage = itemBackImg;
    }
}


-(void)initTabbarItem:(NSString *)nomarlImage selectImage:(NSString *)selectImage title:(NSString *)title index:(int)index{
    
    UITabBarItem * item = self.tabBar.items[index];
    
    UIImage *n_image = [UIImage imageNamed:nomarlImage];
    UIImage *s_image = [UIImage imageNamed:selectImage];
    
    n_image = [n_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    s_image = [n_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item.image = n_image;
    item.selectedImage = s_image;
    item.title = title;
    
    if (self.tabbar_normal_titleColor != nil && self.tabbar_select_titleColor != nil) {
        
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:self.tabbar_normal_titleColor} forState:UIControlStateNormal];
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:self.tabbar_select_titleColor} forState:UIControlStateSelected];
    }else{
        NSLog(@"tabbar_normal_titleColor || tabbar_select_titleColor 不能为空");
    }
}

-(UIImage *)OriginImage:(UIImage *)itembackgroundImage{
    int screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGSize size = CGSizeMake(screenwidth/self.viewControllers.count, 49);
    
    UIGraphicsBeginImageContext(size);
    [itembackgroundImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
