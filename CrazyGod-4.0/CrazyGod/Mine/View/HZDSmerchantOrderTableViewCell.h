//
//  HZDSmerchantOrderTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/13.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZDSmerchantOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
