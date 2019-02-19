//
//  HZDSintegralCashViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"

typedef enum {
    moneyCashType,
    integralCashType
}cashType;

@interface HZDSintegralCashViewController : XTBaseBackViewController

@property(nonatomic)cashType myCashType;

@end
