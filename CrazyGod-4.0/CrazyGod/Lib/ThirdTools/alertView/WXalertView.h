//
//  WXalertView.h
//  zhaowenzhuo
//
//  Created by wangxiaowei on 15/8/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXalertView : NSObject

@property(assign,nonatomic)id delegate;

+(void)alertWithMessage:(NSString*)message andDelegate:(id)delegate;

@end
