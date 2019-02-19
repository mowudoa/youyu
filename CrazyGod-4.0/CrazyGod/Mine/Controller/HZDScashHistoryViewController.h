//
//  HZDScashHistoryViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"


typedef enum {
    moneyCashLogType,
    integralCashLogType
}cashLogType;

@interface HZDScashHistoryViewController : XTBaseBackViewController

@property(nonatomic)cashLogType myCashLogType;

@property(nonatomic,copy) NSString *logUrl;
@end
