//
//  HZDSMessageModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSMessageModel : rootModel

@property(copy,nonatomic)NSString* messageID; //消息id

@property(copy,nonatomic)NSString* messageTitle; //消息标题
@property(copy,nonatomic)NSString* messageUrl; //消息链接
@property(copy,nonatomic)NSString* messageTime; //消息时间

@end
