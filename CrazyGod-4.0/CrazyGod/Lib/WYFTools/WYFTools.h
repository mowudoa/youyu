//
//  WYFTools.h
//  UIGesture
//
//  Created by qianfeng on 15-9-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYFTools : NSObject

//按钮
+(UIButton *)createButton:(CGRect)frame bgColor:(UIColor *)color title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag action:(SEL)action vc:(id)vc;

//标题
+(UILabel *)createLabel:(CGRect)frame bgColor:(UIColor *)color text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor tag:(NSInteger)tag;

//文本框
+(UITextField *)createTextField:(CGRect)frame bgColor:(UIColor *)color placeHolder:(NSString *)holder clearbutnMode:(UITextFieldViewMode)mode keyBoardType:(UIKeyboardType)type tag:(NSInteger)tag TextEntry:(BOOL)bo;
//滑块
+(UISlider *)createSlider:(CGRect)frame leftColor:(UIColor *)LColor rightColor:(UIColor *)RColor minValue:(float)minimumValue maxValue:(float)maximumValue tag:(NSInteger)tag currentValue :(float) currentValue;
//进度条
+(UIProgressView *)createProgressView:(CGRect)frame progressStyle:(UIProgressViewStyle)style progressValue:(float)value leftColor:(UIColor *)LColor rightColor:(UIColor *)RColor tag:(NSInteger)tag;
//webView
+(UIWebView *)createWebView:(CGRect)frame bgColor:(UIColor *)color requestUrl:(NSURL *)Url;


//取随机颜色
+(UIColor *)randomcolor;

//提示框
+(void)alertWithMessage:(NSString *)message andDelegate:(id)delegate tag:(NSInteger)tag;

//类似美团点评的自适应字体的评价标签
+(void)createTagLabel:(UIFont *)font tagArray:(NSArray *)array itemSpace:(float)itemSpace itemHeight:(float)itemHeight currentX:(float)currentX currentY:(float)currentY superView:(UIView *)myView;

//给textview添加placeholder
+(void)CreateTextPlaceHolder:(NSString *)placeString WithFont:(UIFont *)font WithSuperView:(UIView *)superView;

+(float)heightWithCreateTagLabel:(UIFont *)font tagArray:(NSArray *)array itemSpace:(float)itemSpace itemHeight:(float)itemHeight currentX:(float)currentX currentY:(float)currentY superView:(UIView *)myView action:(SEL)action vc:(id)vc;

//单例
+(WYFTools *)shardGodlike;
@property(nonatomic,copy) NSString *str;
@property(nonatomic,copy) NSString *str1;
@property(nonatomic,copy) NSString *str2;

@end
