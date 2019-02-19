//
//  easyflyRegular.h
//  easyflyDemo
//
//  Created by dukai on 15/5/30.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSString(CrazyRegular)

@property(nonatomic)BOOL CrazyValidateNumber; //数字验证
@property(nonatomic)BOOL CrazyValidatePhoneNum; //手机验证
@property(nonatomic)BOOL CrazyValidateEmail; //邮箱验证
@property(nonatomic)BOOL CrazyValidateIdentityCard; //身份证号
@property(nonatomic)BOOL CrazyValidatePassWord; //密码
@property(nonatomic)BOOL CrazyValidateNickname; //昵称
@property(nonatomic)BOOL CrazyValidateName; //用户名
@property(nonatomic)BOOL CrazyValidateCarNo; //车牌号验证

//聚合接口 判断身份证号 手机号
-(void)Crazy_juheIsIDCard:(NSString *)IDCard block:(success)block;
-(void)Crazy_juheIsPhone:(NSString *)Phone block:(success)block;
@end
