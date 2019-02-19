//
//  animationFunction.m
//  yicheng
//
//  Created by dukai on 15/8/19.
//  Copyright (c) 2015年 dukai. All rights reserved.
//

#import "animationFunction.h"
#import "CrazyFunction.h"
int ani_index = 0;
@implementation animationFunction

+(void)startAninationWith:(NSArray *)UIArr{
    
    for(UIView *view in UIArr){
        
        view.alpha = 0;
        
    }
    
    for (int i = 0; i < UIArr.count; i ++) {
        
             UIView *UI = UIArr[i];
        
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (i-(0.5*i)) * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                 UI.alpha = 1;
                
                [animationFunction randomAction:UI];
            });
        
    }
    
}
+(void)randomAction:(UIView *)UI{
    ;
    switch ([CrazyFunction crazy_RandomNumber:0 to:3]) {
        case 0:
             [animationFunction CABasicAnimation:UI];
            break;
        case 1:
            [animationFunction sacleAnimation:UI];
            break;
        case 2:
            [animationFunction rotateAnimation:UI];
            break;
        case 3:
            [animationFunction doflipAnimation:UI];
            break;

        default:
            break;
    }
}


//位置改变
+(void)CABasicAnimation:(UIView *)UI{
    float pointx = UI.frame.origin.x;
    UI.frame = CGRectMake(SCREEN_WIDTH, UI.frame.origin.y, UI.frame.size.width, UI.frame.size.height);
    [UIView beginAnimations:@"move" context:nil];
    
    [UIView setAnimationDuration:1];
    
    [UIView setAnimationDelegate:self];
    
    //改变它的frame的x,y的值
    
    UI.frame=CGRectMake(pointx,UI.frame.origin.y, UI.frame.size.width,UI.frame.size.height);
    
    [UIView commitAnimations];
}
//缩放
+(void)sacleAnimation:(UIView *)UI{
    CGAffineTransform  transform;
    transform = CGAffineTransformScale(UI.transform,1.2,1.2);
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UI setTransform:transform];
    [UI setTransform:CGAffineTransformScale(UI.transform,1.0,1.0)];
    [UIView commitAnimations];
}
//旋转
+(void)rotateAnimation:(UIView *)UI{
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(UI.transform,M_PI*2);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:2];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [UI setTransform:transform];
    //关闭动画  
    [UIView commitAnimations];
}
//翻转
+(void)doflipAnimation:(UIView *)UI{
    //开始动画
    [UIView beginAnimations:@"doflip" context:nil];
    //设置时常
    [UIView setAnimationDuration:1];
    //设置动画淡入淡出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置翻转方向
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft  forView:UI cache:YES];
    //动画结束
    [UIView commitAnimations];
}
@end
