//
//  HZDSClassTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol classBtnDelagate <NSObject>

-(void)buttonSleected:(NSString *)buttonTitle buttonID:(NSString *)buttonId;

@end


@interface HZDSClassTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) IBOutlet UIButton *titleBtn2;

@property (weak, nonatomic) IBOutlet UILabel *ttitleLabel2;

@property (weak, nonatomic) IBOutlet UIButton *titleBtn3;

@property (weak, nonatomic) IBOutlet UIButton *titleBtn5;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UIButton *titleBtn4;

@property (weak, nonatomic) IBOutlet UILabel *titleLable4;

@property(nonatomic,copy) NSArray *classArray;

@property (nonatomic, weak) id<classBtnDelagate> delegate;

@end
