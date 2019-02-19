//
//  HZDSmyMessageDetailViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"

typedef enum {
    mineMessageType,
    merchantMessageType,
    employeeMessageType
}messageType;

@interface HZDSmyMessageDetailViewController : XTBaseBackViewController

@property(nonatomic,copy) NSString *messageID;

@property(nonatomic)messageType messageType;

@end
