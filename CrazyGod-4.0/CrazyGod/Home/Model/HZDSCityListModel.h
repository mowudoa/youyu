//
//  HZDSCityListModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/7.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSCityListModel : rootModel

@property(copy,nonatomic)NSString* citysFirstKey; //首字母

@property(copy,nonatomic)NSString* citysId; //id

@property(copy,nonatomic)NSString* citysName; //名字

@property(strong,nonatomic)NSMutableArray *cityListArray;//城市列表

@end
