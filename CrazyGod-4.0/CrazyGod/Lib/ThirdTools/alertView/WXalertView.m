//
//  WXalertView.m
//  zhaowenzhuo
//
//  Created by wangxiaowei on 15/8/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "WXalertView.h"

@implementation WXalertView

+(void)alertWithMessage:(NSString *)message andDelegate:(id)delegate
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}

@end
