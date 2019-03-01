//
//  HZDSMallListTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/21.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZDSMallListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *soldNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *titileIcon;

@end
