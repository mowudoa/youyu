//
//  HZDSAddAddressViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/23.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"
#import "HZDSAddressModel.h"

typedef enum {
    addType,
    editType
}addAddressType;

@interface HZDSAddAddressViewController : XTBaseBackViewController

@property(nonatomic)addAddressType addressType;

@property(nonatomic,strong)HZDSAddressModel *addressModel;


@property(nonatomic,copy) NSString *orderID;

@property(nonatomic,copy) NSString *LogID;

@end
