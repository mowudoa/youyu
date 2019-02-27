//
//  HZDSBusinessModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/5.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSBusinessModel : rootModel

@property(copy,nonatomic)NSString* businessName; //商家名字
@property(copy,nonatomic)NSString*businessId;//商家id

@property(copy,nonatomic)NSString* businessIcon; //商家图标

@property(copy,nonatomic)NSString* businesstitleImage; //商家招牌

@property(copy,nonatomic)NSString* businessEvaluate; //评价

@property(copy,nonatomic)NSString* businessStarNum; //评分

@property(copy,nonatomic)NSString* businessType; //商家类型

@property(copy,nonatomic)NSString* businessPrice; //价格

@property(copy,nonatomic)NSString* businessOldPrice; //原价价格


@property(copy,nonatomic)NSString* businessSaleNum; //月售


@property(copy,nonatomic)NSString* businessLocation; //位置

@property(copy,nonatomic)NSString* businessPhone; //电话

@property(assign,nonatomic) CGFloat cellHeight;//cell高度

@property(strong,nonatomic)NSMutableArray *goodsArray;

@end
