//
//  HZDSCartModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/22.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSCartModel : rootModel

@property(copy,nonatomic)NSString* goodsnum;

@property(copy,nonatomic)NSString* goodssalesprice;

@property(copy,nonatomic)NSString* goodstitle;

@property(copy,nonatomic)NSString* goodsId;

@property(copy,nonatomic)NSString* goodsImageUrl;

@property(copy,nonatomic)NSString* goodsSpec;

@property(copy,nonatomic)NSString* goodsStockNum;

@property(copy,nonatomic)NSString* goodsIdAndSpec;

@property(assign,nonatomic)BOOL isSelect;

@end
