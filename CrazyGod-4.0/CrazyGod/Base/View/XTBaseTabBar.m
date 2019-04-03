//
//  XTBaseTabBar.m
//  StarGroupBuying
//
//  Created by 英峰 on 2018/12/17.
//  Copyright © 2018年 英峰. All rights reserved.
//

#import "XTBaseTabBar.h"

@interface XTBaseTabBar ()

@property(nonatomic,strong)NSArray *titleDataList;

@property(nonatomic,strong)NSArray *imageDataList;

@property(nonatomic,strong)NSArray *selectedDataList;


@end
@implementation XTBaseTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
      //  self.backgroundColor = [UIColor redColor];
        [self createMyTabBarWithBackgroundImageName:@"tabbar_btn" andItemTitles:self.titleDataList andItemImagesName:self.imageDataList andItemSelectImagesName:self.selectedDataList andClass:self andSEL:@selector(tabbarSelected:)];
        
        
    }
    return self;
}
-(NSArray *)imageDataList{
    
    if (!_imageDataList) {
        
        _imageDataList = @[@"home-icon1",@"busi-icon1",@"mall-icon1",@"pers-icon1"];
    }
    return _imageDataList;
    
}
-(NSArray *)selectedDataList{
    
    if (!_selectedDataList) {
        
        _selectedDataList = @[@"home-icon2",@"busi-icon2",@"mall-icon2",@"pers-icon2"];
    }
    return _selectedDataList;
    
}
-(NSArray *)titleDataList{
    
    if (!_titleDataList) {
        
        _titleDataList = @[@"首页",@"商家",@"商城",@"个人中心"];
    }
    return _titleDataList;
    
}
-(void)createMyTabBarWithBackgroundImageName:(NSString *)bgImageName andItemTitles:(NSArray *)itemTitles andItemImagesName:(NSArray *)itemImagesName andItemSelectImagesName:(NSArray *)itemSelectImagesName andClass:(id)classObject andSEL:(SEL)sel
{
    //  [self createBackgroundImageWithImageViewName:bgImageName];
    //分栏总数
    NSInteger itemCount = itemImagesName.count;
    //循环创建每个分栏
    for (int index = 0; index<itemCount; index++)
    {
        [self createItemWithItemTitle:[itemTitles objectAtIndex:index] andItemImageName:[itemImagesName objectAtIndex:index] andItemSelectImageName:[itemSelectImagesName objectAtIndex:index] andIndex:index andItemCount:itemCount andClass:classObject andSEL:sel];
    }
    
}
//创建每个分栏 index--第几个分栏，从0开始
-(void)createItemWithItemTitle:(NSString *)itemTitle andItemImageName:(NSString *)itemImageName andItemSelectImageName:(NSString *)itemSelectImageName andIndex:(int)index andItemCount:(NSInteger)itemCount andClass:(id)classObject andSEL:(SEL)sel
{
    //1.首先得到每个图片的大小(美工会做好图片)
    //CGSize imageSize = [UIImage imageNamed:itemImageName].size;
    CGSize imageSize = CGSizeMake(24, 24);
    //2.创建分栏view
    //    UIView *bgView = [[UIView alloc] init];
    //    bgView.frame = CGRectMake(self.frame.size.width/itemCount*index, 0, self.frame.size.width/itemCount, self.frame.size.height);
    //    bgView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake((self.frame.size.width)/itemCount*index, 0, (self.frame.size.width)/itemCount, self.frame.size.height);
    
    btn.backgroundColor = [UIColor clearColor];
    
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = index;
    
    [self addSubview:btn];
    
    //3.设置按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake((self.frame.size.width/itemCount-imageSize.width)/2, 5, imageSize.width, imageSize.height);
    
    [button setImage:[UIImage imageNamed: itemImageName] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed: itemSelectImageName ] forState:UIControlStateSelected];
    
    button.userInteractionEnabled = NO;
   
    [btn addSubview:button];
    //4.设置label
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(0, imageSize.height+8, btn.frame.size.width, 20);
    
    label.text = itemTitle;
    
    label.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:12];
    
    [btn addSubview:label];
    
    if (index == 0) {
        
        button.selected = YES;
        
        label.textColor = [UIColor colorWithRed:249/255.0 green:58/255.0 blue:101/255.0 alpha:1];
        
    }
    
}
//创建分栏的条的背景图片
-(void)createBackgroundImageWithImageViewName:(NSString *)imageName
{
    
    UIImageView *imageView = [[UIImageView alloc] init];
   
    imageView.image = [UIImage imageNamed:imageName];
    
    imageView.backgroundColor = [UIColor whiteColor];
    
    imageView.alpha = 0.f;
    
    imageView.frame = self.bounds;
    
    [self addSubview:imageView];
    
}
-(void)tabbarSelected:(UIButton *)sender{
   
    for(UIView *view in sender.superview.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            ((UIButton *)[view.subviews objectAtIndex:0]).selected = NO;
            
            ((UILabel *)[view.subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
            
        }
    }
    
    ((UIButton *)[sender.subviews objectAtIndex:0]).selected = YES;
    
    ((UILabel *)[sender.subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:249/255.0 green:58/255.0 blue:101/255.0 alpha:1];
    
    //协议
    if ([self.delegate respondsToSelector:@selector(tabBar:itemIndex:)]) {
        
        [self.delegate tabBar:self itemIndex:sender.tag];
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
