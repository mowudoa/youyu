//
//  HZDSMySubordinateViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/2/16.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"

typedef enum {
    MySubordinateFirst,
    MySubordinateSecond
}WXMySubordinate;

@interface HZDSMySubordinateViewController : XTBaseBackViewController

@property(nonatomic)WXMySubordinate SubordinateType;

@end
