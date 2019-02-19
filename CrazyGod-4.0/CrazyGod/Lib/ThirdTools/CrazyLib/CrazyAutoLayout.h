//
//  CrazyAutoLayout.h
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(View)

@property(nonatomic,strong)NSString * mark;

@end


@interface CrazyAutoLayout : NSObject

@property(nonatomic)float scale;
+(void)layoutOfSuperView:(UIView *)superView;
+(CGFloat)getFontSize:(CGFloat)fontSize;
+(CGFloat)getUIScale;
+(CGFloat)crazyHeight:(float)height;

@end
