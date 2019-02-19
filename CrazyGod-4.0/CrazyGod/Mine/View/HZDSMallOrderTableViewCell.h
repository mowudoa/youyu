//
//  HZDSMallOrderTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/28.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZDSMallOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsNeedpay;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;

@end
