//
//  scrollPhotos.h
//  O2O
//
//  Created by wangxiaowei on 15/5/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scrollPhotos : UIView<UIScrollViewDelegate>

@property(assign,nonatomic)id delegate;

@property(strong,nonatomic)NSArray* photos;

@property(strong,nonatomic)UIScrollView* scrollView;

@property(strong,nonatomic)UIPageControl* pagecontrol;

@end
