//
//  HZDSingegralListViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"

typedef enum {
    moneyLogType,
    integralLogType
}LogType;

@interface HZDSingegralListViewController : XTBaseBackViewController

@property(nonatomic)LogType myLogType;

@property(nonatomic,copy) NSString *logUrl;
@end
