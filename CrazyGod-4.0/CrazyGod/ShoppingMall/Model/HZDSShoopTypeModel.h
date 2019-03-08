//
//  HZDSShoopTypeModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/22.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSShoopTypeModel : rootModel

@property(copy,nonatomic)NSString *shopId;

@property(strong,nonatomic)NSMutableArray *goodsArray;

@end
