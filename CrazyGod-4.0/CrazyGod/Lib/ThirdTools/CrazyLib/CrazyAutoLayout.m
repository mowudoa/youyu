//
//  CrazyAutoLayout.m
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "CrazyAutoLayout.h"
#import "UIView+SDAutoLayout.h"
#import <objc/runtime.h>

static void *UtilityKey = (void*)&UtilityKey;
@implementation UIView(View)
@dynamic mark;
-(NSString *)mark{
    return objc_getAssociatedObject(self, UtilityKey);
}
-(void)setMark:(NSString *)mark{
    objc_setAssociatedObject(self, UtilityKey, mark, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

static CrazyAutoLayout *layout = nil;
@implementation CrazyAutoLayout

+(CrazyAutoLayout *)share{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        layout = [[self alloc]init];
    });
    return layout;
}
- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
+(void)layoutOfSuperView:(UIView *)superView{
    [CrazyAutoLayout share];
    if (SCREEN_WIDTH != 320) {
        layout.scale = [CrazyAutoLayout getUIScale];
        [layout updateUIFrame:superView];
    }
}

-(void)updateUIFrame:(UIView *)superView{
    
    for (UIView *view in superView.subviews) {
        if (![view.mark isEqualToString: @"yes"]) {
            CGRect rect = view.frame;
            
            view.sd_layout.leftSpaceToView(superView,rect.origin.x * _scale).topSpaceToView(superView,rect.origin.y * _scale).widthIs(rect.size.width * _scale).heightIs(rect.size.height * _scale);
            
            [self updateUIText:view];
            
            view.mark = @"yes";
            
        }
        
        if (view.subviews.count > 0) {
            [self updateUIFrame:view];
        }
    }
}

-(void)updateUIText:(UIView *)view{
    if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UITextView class]]){
        UILabel *label = (UILabel *)view;
        
        CGFloat fontSize = [CrazyAutoLayout getFontSize:label.font.pointSize];
        
        label.font = [UIFont fontWithName:label.font.fontName size:fontSize];
        
        if([view isKindOfClass:[UIButton class]]){
            UIEdgeInsets edge = ((UIButton *)view).imageEdgeInsets;
            ((UIButton *)view).imageEdgeInsets = UIEdgeInsetsMake(edge.top * _scale, edge.left * _scale, edge.bottom * _scale, edge.right * _scale);
            edge = ((UIButton *)view).titleEdgeInsets;
            ((UIButton *)view).titleEdgeInsets = UIEdgeInsetsMake(edge.top * _scale, edge.left * _scale, edge.bottom * _scale, edge.right * _scale);
            edge = ((UIButton *)view).contentEdgeInsets;
            ((UIButton *)view).contentEdgeInsets = UIEdgeInsetsMake(edge.top * _scale, edge.left * _scale, edge.bottom * _scale, edge.right * _scale);
            
        }
        
    }
    
}


+(CGFloat)getFontSize:(CGFloat)fontSize{
    int width = SCREEN_WIDTH;
    CGFloat size = fontSize;
    
    if (fontSize < 21) {
        if (width == 375) {
            size = size +1;
        }else if(width == 414){
            size = size +2 ;
        }
    }
    return size;
}

+(CGFloat)getUIScale{
    CGFloat scale = SCREEN_WIDTH/320.0;
    return scale;
}


+(CGFloat)crazyHeight:(float)height{
    CGFloat scale = SCREEN_WIDTH/320.0;
    return scale * height;
}

@end
