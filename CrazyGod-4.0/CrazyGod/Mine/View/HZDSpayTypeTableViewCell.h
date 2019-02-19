//
//  HZDSpayTypeTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZDSpayTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payImage;

@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@end
