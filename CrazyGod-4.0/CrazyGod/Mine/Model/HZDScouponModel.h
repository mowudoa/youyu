//
//  HZDScouponModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDScouponModel : rootModel

@property(copy,nonatomic)NSString* couponID; //消费券id

@property(copy,nonatomic)NSString* couponTite; //商品名字

@property(copy,nonatomic)NSString* couponShop; //店铺名字

@property(copy,nonatomic)NSString* couponCode; //消费券编号

@property(copy,nonatomic)NSString* couponOrderCode; //订单id

@property(copy,nonatomic)NSString* couponNUm; //消费券码
@property(copy,nonatomic)NSString* couponTime; //生成时间

@property(copy,nonatomic)NSString* orderTime; //订单时间

@property(copy,nonatomic)NSString* couponStatus; //消费券状态

@property(copy,nonatomic)NSString* couponImage; //消费券商品名字

@property(copy,nonatomic)NSString* couponChecker; //消费验证人

@end
