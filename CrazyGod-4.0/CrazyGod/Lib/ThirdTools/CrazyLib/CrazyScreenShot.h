//
//  easyflyScreenShot.h
//  easyflyDemo
//
//  Created by dukai on 15/6/2.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CrazyScreenShot : NSObject

@property(nonatomic)CGRect rect;//截屏区域  默认全屏

-(void)ScreenShot:(UIView *)screenView;
@end
