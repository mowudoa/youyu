//
//  HZDScashHistoryModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDScashHistoryModel : rootModel


@property(copy,nonatomic)NSString* cashID; //提现编号

@property(copy,nonatomic)NSString* cashNum; //提现金额

@property(copy,nonatomic)NSString* bankName; //银行名字

@property(copy,nonatomic)NSString* bankNum; //银行账号

@property(copy,nonatomic)NSString* userName; //户名

@property(copy,nonatomic)NSString* cashStatus; //状态

@property(copy,nonatomic)NSString* cashTime; //时间

@end
