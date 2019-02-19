//
//  easyflyAnimation.m
//  easyflyDemo
//
//  Created by dukai on 15/5/29.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import "easyflyAnimation.h"

@implementation easyflyAnimation


+(void)back:(UIView *)view animationType:(AnimationType *)type Direction:(AnimationDirection *)Direction
{
    [UIView animateWithDuration:1 animations:^{
        
        CATransition *animation = [CATransition animation];
        
        [animation setDuration:1];
    
        [animation setType: kCATransitionReveal];
        
        [animation setSubtype: kCATransitionFromBottom];
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [view.layer addAnimation:animation forKey:nil];
        
    }];
    
}
+(void)curlAnimation:(UIView *)view{
    [UIView beginAnimations:@"Curl" context:Nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:view cache:YES];
    [UIView commitAnimations];
}
+(void)CABasicAnimation:(UIView *)view{
     //CABasicAnimation  单一动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake(160, 250)] ];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(160,-(view.bounds.size.height) )] ];
    animation.duration = 5;
    [view.layer setPosition: CGPointMake(160,view.bounds.size.height -130 )]; //动画结束后回到从前位置
    [view.layer addAnimation:animation forKey:Nil];
    [UIView commitAnimations];
}
+(void)doubleCABasicAnimation:(UIView *)view{
    //CABasicAnimation  合并动画
    //下面 用了一个合并动画 2个动画一起做得效果  值得注意的是 动画并不是太难 只是想全部都弄一遍还要试很多遍
   CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; //图片中心旋转
    [animation setToValue:[NSNumber numberWithFloat:(2 *M_PI) *2]];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *secAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; //图片缩放
    secAnimation.toValue = [NSNumber numberWithFloat:0];
    secAnimation.duration = 1;
    secAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation]; //合并动画
    animationGroup.duration = 1;
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = 1;
    animationGroup.animations = [NSArray arrayWithObjects:animation,secAnimation, nil];
    [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
    [UIView commitAnimations];
    
}
+(void)doubleCATransitionAnimation:(UIView *)view{
    CATransition *transition = [CATransition animation ];
    [transition setDelegate:self ];
    [transition setDuration:1.0];
    //setType 用视觉效果   setSubtype 用于动画方向  如果弄反了 就不出动画效果
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transition setType:kCATransitionReveal];
    [transition setSubtype:kCATransitionFromBottom];
    [view.layer addAnimation:transition forKey:@"Reveal"];//@"Reveal" @"push" @"fade"
    [UIView commitAnimations];
}
+(void)CATransform3DAnimation:(UIView *)view{
     // 改变坐标轴  非常难弄的动画 一般轻易不要用，用的话一定要研究矩阵
    CATransform3D rotationTransform = CATransform3DIdentity;
    rotationTransform.m34 = -1.0/200.0f ;
    rotationTransform = CATransform3DRotate(rotationTransform, 0.05 *M_PI_2, 0.0f, 1.0f, 0.0f);
    view.layer.transform = rotationTransform;
    view.layer.zPosition = 100;
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        CATransform3D rotationTransform2 = CATransform3DIdentity;
        rotationTransform2.m34 = -1.0/200;
        rotationTransform2 = CATransform3DRotate(rotationTransform2, -0.05*M_PI_2, 0.0, 1.0, 0.0);
        view.layer.transform = rotationTransform2;
        
        view.layer.zPosition = 100;
        
    } completion:^(BOOL finished) {
        
    }];
   [UIView commitAnimations];
    
}

/*
 animationWithKeyPath的值：
 
 　 transform.scale = 比例轉換
 
 transform.scale.x = 闊的比例轉換
 
 transform.scale.y = 高的比例轉換
 
 transform.rotation.z = 平面圖的旋轉
 
 opacity = 透明度
 
 margin
 
 zPosition
 
 backgroundColor    背景颜色
 
 cornerRadius    圆角
 
 borderWidth
 
 bounds
 
 contents
 
 contentsRect
 
 cornerRadius
 
 frame
 
 hidden
 
 mask
 
 masksToBounds
 
 opacity
 
 position
 
 shadowColor
 
 shadowOffset
 
 shadowOpacity
 
 shadowRadius
 
 */

/*CATransition
 pageCurl 向上翻一页
 pageUnCurl 向下翻一页     rippleEffect 滴水效果      suckEffect 收缩效果，如一块布被抽走     cube 立方体效果     oglFlip 上下翻转效果
 */

/*
 *  kCATransitionFade            交叉淡化过渡
 *  kCATransitionMoveIn          新视图移到旧视图上面
 *  kCATransitionPush            新视图把旧视图推出去
 *  kCATransitionReveal          将旧视图移开,显示下面的新视图
 
 当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
 *  90cw    逆时针旋转90°
 *  90ccw   顺时针旋转90°
 *  180cw   逆时针旋转180°
 *  180ccw  顺时针旋转180°
 
 @see https://developer.apple.com/library/mac/#documentation/cocoa/conceptual/CoreAnimation_guide/Articles/KVCAdditions.html
 *
 *  @brief                      便利构造函数 animationWithKeyPath: KeyPath需要一个字符串类型的参数,实际上是一个
 *                              键-值编码协议的扩展,参数必须是CALayer的某一项属性,你的代码会对应的去改变该属性的效果
 *                              具体可以填写什么请参考上面的URL,切勿乱填!
 *                              例如这里填写的是 @"transform.rotation.z" 意思就是围绕z轴旋转,旋转的单位是弧度.
 *                              这个动画的效果是把view旋转到最小,再旋转回来.
 *                              你也可以填写@"opacity" 去修改透明度...以此类推.修改layer的属性,可以用这个类.
 *
 *  @param toValue              动画结束的值.CABasicAnimation自己只有三个属性(都很重要)(其他属性是继承来的),分别为:
 *                              fromValue(开始值), toValue(结束值), byValue(偏移值),
 !                              这三个属性最多只能同时设置两个;
 *                              他们之间的关系如下:
 *                              如果同时设置了fromValue和toValue,那么动画就会从fromValue过渡到toValue;
 *                              如果同时设置了fromValue和byValue,那么动画就会从fromValue过渡到fromValue + byValue;
 *                              如果同时设置了byValue  和toValue,那么动画就会从toValue - byValue过渡到toValue;
 *
 *                              如果只设置了fromValue,那么动画就会从fromValue过渡到当前的value;
 *                              如果只设置了toValue  ,那么动画就会从当前的value过渡到toValue;
 *                              如果只设置了byValue  ,那么动画就会从从当前的value过渡到当前value + byValue.
 *
 *                              可以这么理解,当你设置了三个中的一个或多个,系统就会根据以上规则使用插值算法计算出一个时间差并
 *                              同时开启一个Timer.Timer的间隔也就是这个时间差,通过这个Timer去不停地刷新keyPath的值.
 !                              而实际上,keyPath的值(layer的属性)在动画运行这一过程中,是没有任何变化的,它只是调用了GPU去
 *                              完成这些显示效果而已.
 *                              在这个动画里,是设置了要旋转到的弧度,根据以上规则,动画将会从它当前的弧度专旋转到我设置的弧度.
 *
 *  @param duration             动画持续时间
 *
 *  @param timingFunction       动画起点和终点之间的插值计算,也就是说它决定了动画运行的节奏,是快还是慢,还是先快后慢...
 */

/** CAAnimationGroup
 *
 *  @brief                      顾名思义,这是一个动画组,它允许多个动画组合在一起并行显示.比如这里设置了两个动画,
 *                              把他们加在动画组里,一起显示.例如你有几个动画,在动画执行的过程中需要同时修改动画的某些属性,
 *                              这时候就可以使用CAAnimationGroup.
 *
 *  @param duration             动画持续时间,值得一提的是,如果添加到group里的子动画不设置此属性,group里的duration会统一
 *                              设置动画(包括子动画)的duration属性;但是如果子动画设置了duration属性,那么group的duration属性
 *                              的值不应该小于每个子动画中duration属性的值,否则会造成子动画显示不全就停止了动画.
 *
 *  @param autoreverses         动画完成后自动重新开始,默认为NO.
 *
 *  @param repeatCount          动画重复次数,默认为0.
 *
 *  @param animations           动画组(数组类型),把需要同时运行的动画加到这个数组里.
 *
 *  @note  addAnimation:forKey  这个方法的forKey参数是一个字符串,这个字符串可以随意设置.
 *
 *  @note                       如果你需要在动画group执行结束后保存动画效果的话,设置 fillMode 属性,并且把
 *                              removedOnCompletion 设置为NO;
 */


@end
