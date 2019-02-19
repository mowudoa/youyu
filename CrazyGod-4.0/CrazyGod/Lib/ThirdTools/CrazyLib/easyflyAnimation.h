//
//  easyflyAnimation.h
//  easyflyDemo
//
//  Created by dukai on 15/5/29.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface easyflyAnimation : NSObject

typedef NS_ENUM(NSUInteger, AnimationDirection) {
    AnimationDirectionFromBottom = 1,
    AnimationDirectionFromTop,
    AnimationDirectionFromLeft,
    AnimationDirectionFromRight
};
typedef NS_ENUM(NSUInteger, AnimationType) {
    AnimationTypeFade = 1,
    AnimationTypeMoveIn,
    AnimationTypePush,
    AnimationTypeReveal
};
+(void)back:(UIView *)view animationType:(AnimationType *)type Direction:(AnimationDirection *)Direction ;

@end
