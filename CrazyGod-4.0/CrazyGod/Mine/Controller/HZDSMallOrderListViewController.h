//
//  HZDSMallOrderListViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/24.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"
typedef enum {
    WXMyOrderUnPay,
    WXMyOrderUnSend,
    WXMyOrderUnReceive,
    WXMyOrderUnEvaluate,
    WXMyOrderUnRefund,
    WXMyOrderRefunded
}WXMyOrder;

@interface HZDSMallOrderListViewController : XTBaseBackViewController

@property(nonatomic)WXMyOrder orderType;

@end
