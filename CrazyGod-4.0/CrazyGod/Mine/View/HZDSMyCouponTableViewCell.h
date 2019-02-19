//
//  HZDSMyCouponTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZDScouponModel.h"


@protocol couponBtnDelagate <NSObject>

-(void)couponSleected:(NSString *)couponStatus withcouponID:(NSString *)couponId;

@end

@interface HZDSMyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *couponID;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *couponNum;
@property (weak, nonatomic) IBOutlet UILabel *couponTime;

@property(nonatomic,strong) HZDScouponModel *couponModel;

@property (nonatomic, weak) id<couponBtnDelagate> delegate;

@end
