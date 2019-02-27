//
//  HZDSBusinessTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/7.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZDSBusinessModel.h"


@interface HZDSBusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *businessIcon;
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UILabel *businessLocation;
@property (weak, nonatomic) IBOutlet UILabel *businessType;
@property (weak, nonatomic) IBOutlet commentStar *stareView;
@property (weak, nonatomic) IBOutlet UIView *businessTagsView;
@property (weak, nonatomic) IBOutlet UILabel *businessSaleNum;
@property (weak, nonatomic) IBOutlet UILabel *businessPrice;



@property(nonatomic,strong) HZDSBusinessModel *bussinessModel;

@end
