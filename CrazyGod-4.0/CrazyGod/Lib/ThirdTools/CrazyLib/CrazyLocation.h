//
//  UserLocation.h
//  TiaoWei
//
//  Created by dukai on 15/3/27.
//  Copyright (c) 2015年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
typedef void (^LocationFinishBolck)(double longitude,double latitude);
typedef void (^cityFinishBolck)(NSDictionary* addressDic);
@interface CrazyLocation : NSObject<CLLocationManagerDelegate>

@property(nonatomic,strong)LocationFinishBolck finishBlock;
@property(nonatomic,strong)cityFinishBolck cityBlock;

+(CrazyLocation *)share;
+(void)startUpdataUserLocation:(LocationFinishBolck)block cityBlock:(cityFinishBolck)cityBlock;

//info.plist  文件里加入
//NSLocationWhenInUseUsageDescription  Boolean  YES
@end
