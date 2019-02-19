//
//  HZDSCityListViewController.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/7.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "XTBaseBackViewController.h"


@protocol cityChoiceDelegate <NSObject>

-(void)citySleected:(NSString *)lngString withcouponlat:(NSString *)latString;

@end

@interface HZDSCityListViewController : XTBaseBackViewController

@property (nonatomic, weak) id<cityChoiceDelegate> delegate;

@end
