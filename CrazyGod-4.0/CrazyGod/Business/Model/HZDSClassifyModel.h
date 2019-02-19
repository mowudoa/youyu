//
//  HZDSClassifyModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/7.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSClassifyModel : rootModel

@property(copy,nonatomic)NSString* classId; //类别id

@property(copy,nonatomic)NSString* className; //类别名称

@property(copy,nonatomic)NSString* classcont; //子类别数量


@property(strong,nonatomic)NSMutableArray *subClassArray;

@end
