//
//  HZDSevaluateModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/28.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSevaluateModel : rootModel


@property(copy,nonatomic)NSString* goodsEvaluate;//商品评价

@property(copy,nonatomic)NSString* businessReply;//商家回复

@property(copy,nonatomic)NSString* goodsId;//商品id

@property(copy,nonatomic)NSString* userImageUrl;//用户头像

@property(copy,nonatomic)NSString* userName;//用户昵称

@property(copy,nonatomic)NSString* evaluateTime;//评价时间

@property(copy,nonatomic)NSString*evaluateScore;//评分
@end
