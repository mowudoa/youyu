//
//  HZDSAddressModel.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/23.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "rootModel.h"

@interface HZDSAddressModel : rootModel


@property(copy,nonatomic)NSString* addressDetail;//详细地址

@property(copy,nonatomic)NSString* userPhone;//电话

@property(copy,nonatomic)NSString* is_default;//是否为默认

@property(copy,nonatomic)NSString* userName;//名字

@property(copy,nonatomic)NSString* address;//地址


@property(copy,nonatomic)NSString *addressId;//id
@end
