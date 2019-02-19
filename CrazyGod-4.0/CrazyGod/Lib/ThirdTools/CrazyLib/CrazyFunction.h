//
//  easyflyFunction.h
//  easyflyDemo
//
//  Created by dukai on 15/6/2.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CrazyFunction : NSObject<UITextFieldDelegate>

+(void)textfeildSpace:(UITextField *)textFeild space:(float )space; //textfield 不顶头

+(NSString *)compareCurrentTime:(NSDate*) compareDate; //计算时间差

+(NSString *)crazy_md5:(NSString *)string;//md5加密小写
+(NSString *)crazy_MD5:(NSString *)string;//md5加密大写

+(NSString *)crazy_timeToTimestamp:(NSDate *)data;//时间转时间戳
+(NSString *)crazy_timestampToTime:(NSString *)timestamp;//时间戳转时间
+(int)crazy_RandomNumber:(int)from to:(int)to; //随机数 间隔
+(NSString *)crazy_ObjectToJsonString:(id)object;//字典或者数组 转换成json串
+(id)crazy_JsonStringToObject:(NSString *)JsonString;//json串 转换成字典或者数组
+(NSString *)crazy_pinyin:(NSString *)hanzi;//汉字转拼音


+(BOOL)CrazyValidatePhoneNum:(NSString *)str;//验证手机号码
+(BOOL)CrazyValidateIdentityCard:(NSString *)str;//验证身份证号码
#pragma 正则匹配银行卡号
+ (BOOL)checkUserBankNumber:(NSString *)BankNumber;

@end

/*倒计时*/
typedef void (^FinishTimerBolck)(int time);
@interface CrazyCountdownTimer : NSObject

@property(nonatomic,strong)FinishTimerBolck TimerBolck;
@property(nonatomic)int nowTime;

+(void)crazy_CountdownTimer:(int)Second block:(FinishTimerBolck)block;



@end

