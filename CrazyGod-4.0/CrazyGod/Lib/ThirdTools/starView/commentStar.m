//
//  commentStar.m
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "commentStar.h"

@implementation commentStar

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [self createBtn];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [self createBtn];
    }
    return self;
}

-(void)setNumofStar:(NSInteger)numofStar
{
    _numofStar = numofStar;
    UIButton* btn = (UIButton*)[self viewWithTag:numofStar-1+10];
    [self selectStar:btn];
}

-(void)setSelectingenabled:(BOOL)selectingenabled
{
    _selectingenabled = selectingenabled;
    self.userInteractionEnabled = selectingenabled;
}

-(void)createBtn
{
    for (int i = 0; i< 5; i++) {
        UIButton* btn = [UIButton buttonWithType: UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(15+3), 5, 15, 15)];
        [btn setImage:[UIImage imageNamed:@"star4"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"star3"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectStar:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+10;
        
        [self addSubview:btn];
    }
}

-(void)selectStar:(UIButton*)sender
{
    
    _currentStar = sender.tag - 10+1;
    NSArray* arr = self.subviews;
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag<=sender.tag) {
                btn.selected = YES;
            }else
            {
                btn.selected = NO;
            }
        }
    }
}

@end
