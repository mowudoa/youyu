//
//  HZDSmerchantIMageListModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSmerchantIMageListModel : rootModel

@property(copy,nonatomic)NSString* imageID; //图片ID

@property(copy,nonatomic)NSString* shopID; //商户id

@property(copy,nonatomic)NSString* imageTite; //图片标题

@property(copy,nonatomic)NSString* imageOrderby; //图片排序

@property(copy,nonatomic)NSString* imageUrl; //图片网址

@property(copy,nonatomic)NSString* iamgecreateTime; //图片创建时间

@property(copy,nonatomic)NSString* iamgeStatus; //图片状态

@end
