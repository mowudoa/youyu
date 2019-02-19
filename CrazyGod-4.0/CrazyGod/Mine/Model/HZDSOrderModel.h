//
//  HZDSOrderModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSOrderModel : rootModel


@property(copy,nonatomic)NSString* orderID; //订单id

@property(copy,nonatomic)NSString* orderTitle; //订单名字

@property(copy,nonatomic)NSString* orderImage; //订单图片
@property(copy,nonatomic)NSString* orderStatus; //订单状态

@property(copy,nonatomic)NSString* orderPrice; //订单价格
@property(copy,nonatomic)NSString* orderTime; //订单时间

@property(copy,nonatomic)NSString* orderNeedPayPrice; //订单实际支付价格

@property(copy,nonatomic)NSString* orderType; //订单类型

@property(copy,nonatomic)NSString* orderNum; //订单数量

@property(copy,nonatomic)NSString* soldNum; //已售数量

@end
