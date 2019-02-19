//
//  HZDSShopOrderViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/22.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"

@interface HZDSShopOrderViewController : XTBaseBackViewController

@property(nonatomic,copy) NSString *orderId;

@property(nonatomic,copy) NSString *areaId;

@property(nonatomic,copy) NSString *logId;

@property(nonatomic,copy) NSDictionary *orderDic;

@end
