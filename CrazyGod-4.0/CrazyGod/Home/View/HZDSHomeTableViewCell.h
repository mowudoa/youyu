//
//  HZDSHomeTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HZDSHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *goodIconImage;

@property(nonatomic,strong) HomeModel *homeModel;

@end
