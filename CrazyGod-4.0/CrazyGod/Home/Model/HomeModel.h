//
//  HomeModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HomeModel : rootModel


@property(copy,nonatomic)NSString* goodsType; //商品类型

@property(copy,nonatomic)NSString* goodsName; //商品名字

@property(copy,nonatomic)NSString* goodsId; //商品ID

@property(copy,nonatomic)NSString* goodsSoldNum; //已售数量
@property(copy,nonatomic)NSString* goodsPrice; //价格



@property(copy,nonatomic)NSString* goodsIcon; //商品图片

@property(copy,nonatomic)NSString* hometitle; //首页标题

@property(copy,nonatomic)NSString* distance; //首页标题


@property(assign,nonatomic)float cellHeight; //首页标题



@property(strong,nonatomic)NSMutableArray *goodsArray;

@property(strong,nonatomic)NSMutableArray *bannerArray;

@property(strong,nonatomic)NSMutableArray *advArray;

@property(strong,nonatomic)NSMutableArray *tagArray;



@end
