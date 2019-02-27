//
//  WYFTools.m
//  UIGesture
//
//  Created by qianfeng on 15-9-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WYFTools.h"
static WYFTools *god = nil;
@implementation WYFTools




#define mark - Methods



//工厂模式
+(UIButton *)createButton:(CGRect)frame bgColor:(UIColor *)color title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag action:(SEL)action vc:(id)vc
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.tag = tag;
    
    [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    return button;
}
+(UILabel *)createLabel:(CGRect)frame bgColor:(UIColor *)color text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor tag:(NSInteger)tag
{

    UILabel *label = [[UILabel alloc] init];

    label.frame = frame;
    
    label.backgroundColor = color;
    
    label.text = text;
    
    label.textColor = textColor;
    
    label.tag = tag;
    
    label.textAlignment = textAlignment;
    
    label.font = [UIFont systemFontOfSize:17];
    
    label.numberOfLines = 0;
    
    
    return label ;

}
+(UITextField *)createTextField:(CGRect)frame bgColor:(UIColor *)color placeHolder:(NSString *)holder clearbutnMode:(UITextFieldViewMode)mode keyBoardType:(UIKeyboardType)type tag:(NSInteger)tag TextEntry:(BOOL)bo
{
    UITextField *field = [[UITextField alloc] init];
    field.frame = frame;
    field.backgroundColor = color;
    field.placeholder = holder;
    field.clearButtonMode = mode;
    field.keyboardType = type;
    field.secureTextEntry = bo;
    field.tag = tag;
    
    return field ;

}
+(UISlider *)createSlider:(CGRect)frame leftColor:(UIColor *)LColor rightColor:(UIColor *)RColor minValue:(float)minimumValue maxValue:(float)maximumValue tag:(NSInteger)tag currentValue :(float) currentValue
{
    
    //<1>创建滑块对象
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    
    //<2>设置slider左边的颜色
    slider.minimumTrackTintColor = LColor;
    //<3>设置右边的颜色
    slider.maximumTrackTintColor = RColor;
    //<4>改变按钮得背景颜色
   // slider.TintColor=color;
    //<5>设置slider的最大值,最小值
    slider.minimumValue = minimumValue;
    slider.maximumValue = maximumValue;
    //<6>设置slider当前显示位置
    slider.value = currentValue;
    //<7>为slider添加点击事件
  //  [slider addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventValueChanged];
    slider.tag = tag;
    //<8>设置slider按钮得图片
  //  [slider setThumbImage:[UIImage imageNamed:@"tab_c1"] forState:UIControlStateNormal];
    //<9>设置slider左侧图片
  //  slider.minimumValueImage=[UIImage imageNamed:@"tab_c0"];
 //   slider.maximumValueImage=[UIImage imageNamed:@"tab_c3"];
    
    
    
    return slider;
}
+(UIProgressView *)createProgressView:(CGRect)frame progressStyle:(UIProgressViewStyle)style progressValue:(float)value leftColor:(UIColor *)LColor rightColor:(UIColor *)RColor tag:(NSInteger)tag
{
    
    //创建对象
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:style];
    
    //设置进度条当前显示位置  progress的取值范围(0-1)
    //progress如果大于一,那么进度一直处于充满状态
    progressView.progress = value;
    
    [progressView setProgressTintColor:LColor];
    
    [progressView setTrackTintColor:RColor];
    
    
    progressView.frame = frame;
    
    progressView.tag = tag;
    
    return progressView;
}

+(UIWebView *)createWebView:(CGRect)frame bgColor:(UIColor *)color requestUrl:(NSURL *)Url
{
    
    UIWebView *webview=[[UIWebView alloc] initWithFrame:frame];
    //<2>添加显示数据的网址
    
    //<3>将字符串网址转化成NSNRL
    
    //<4>将URL封装成NSURLRequest对象
    NSURLRequest *request=[NSURLRequest requestWithURL:Url];
    
    //<5>将请求对象添加在webView视图上
    [webview loadRequest:request];
    
    webview.backgroundColor = color;
    
    return webview;
}
+(void)createTagLabel:(UIFont *)font tagArray:(NSArray *)array itemSpace:(float)itemSpace itemHeight:(float)itemHeight currentX:(float)currentX currentY:(float)currentY superView:(UIView *)myView
{
    
    for (int index = 0; index < array.count; index++) {
        NSString *itemString = [array objectAtIndex:index];
        //   CGSize size = [itemString sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, itemHeight)];
        
        NSDictionary *attribute = @{NSFontAttributeName: font};
        
        CGSize size = [itemString boundingRectWithSize:CGSizeMake(myView.frame.size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        
        if ([itemString isEqualToString:@""] || [itemString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            
            
        }else{
            
            size.width = size.width + 10;//为了给每个label 留点显示边距  ＋10

        }
        
        if (size.width > myView.frame.size.width - itemSpace * 2) {
            size.width = myView.frame.size.width - itemSpace * 2;
        }
        if (currentX + size.width > myView.frame.size.width - 2 * itemSpace) {//计算的宽度大于 屏幕的宽度
            currentY = currentY + itemHeight + itemSpace;
            currentX = 0;
        }
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.frame = CGRectMake(currentX + itemSpace, currentY + itemSpace, size.width, itemHeight);
        button.backgroundColor = [UIColor clearColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        [button setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        button.layer.borderColor = [UIColor orangeColor].CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:itemString forState:(UIControlStateNormal)];
        button.titleLabel.font = font;
        currentX += size.width + 10;
        
        
        [myView addSubview:button];

    }
    
}
+(float)heightWithCreateTagLabel:(UIFont *)font tagArray:(NSArray *)array itemSpace:(float)itemSpace itemHeight:(float)itemHeight currentX:(float)currentX currentY:(float)currentY superView:(UIView *)myView action:(SEL)action vc:(id)vc buttonUserEnable:(BOOL)enable
{
    float height = 0.0;
    
    for (int index = 0; index < array.count; index++) {
        NSString *itemString = [array objectAtIndex:index];
        //   CGSize size = [itemString sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, itemHeight)];
        
        NSDictionary *attribute = @{NSFontAttributeName: font};
        
        CGSize size = [itemString boundingRectWithSize:CGSizeMake(myView.frame.size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        
        if ([itemString isEqualToString:@""] || [itemString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            
            
        }else{
            
            size.width = size.width + 10;//为了给每个label 留点显示边距  ＋10
            
        }
        
        if (size.width > myView.frame.size.width - itemSpace * 2) {
            size.width = myView.frame.size.width - itemSpace * 2;
        }
        if (currentX + size.width > myView.frame.size.width - 2 * itemSpace) {//计算的宽度大于 屏幕的宽度
            currentY = currentY + itemHeight + itemSpace;
            currentX = 0;
        }
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.frame = CGRectMake(currentX + itemSpace, currentY + itemSpace, size.width, itemHeight);
        button.backgroundColor = [UIColor clearColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        [button setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        button.layer.borderColor = [UIColor orangeColor].CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:itemString forState:(UIControlStateNormal)];
        button.titleLabel.font = font;
        currentX += size.width + 10;
        [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = enable;
        
        [myView addSubview:button];
        
        height = currentY;
    }
    
    return height + itemHeight;
}

+(UIColor *)randomcolor
{


    UIColor *color =  [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];

    return color;
}
+(void)CreateTextPlaceHolder:(NSString *)placeString WithFont:(UIFont *)font WithSuperView:(UIView *)superView
{
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeString;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [superView addSubview:placeHolderLabel];
    
    // same font
    placeHolderLabel.font = font;
    
    [superView setValue:placeHolderLabel forKey:@"_placeholderLabel"];

}
+(void)alertWithMessage:(NSString *)message andDelegate:(id)delegate tag:(NSInteger)tag
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}


//单例
+(WYFTools *)shardGodlike
{
    
    if (god == nil) {
        god = [[WYFTools alloc] init];
    }
    
    return god;
}


@end
