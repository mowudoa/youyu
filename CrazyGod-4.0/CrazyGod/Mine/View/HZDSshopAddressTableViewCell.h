//
//  HZDSshopAddressTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/23.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZDSAddressModel.h"

@protocol deleteBtnDelagate <NSObject>

-(void)buttonDelete:(NSString *)addressId;

-(void)buttonEdit:(NSString *)addressId withMode:(HZDSAddressModel *)model;

@end


@interface HZDSshopAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property(strong,nonatomic)HZDSAddressModel* addressmodel;

@property (nonatomic, weak) id<deleteBtnDelagate> delegate;

@end
