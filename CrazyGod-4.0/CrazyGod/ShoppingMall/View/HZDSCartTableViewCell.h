//
//  HZDSCartTableViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/22.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZDSCartModel.h"

@protocol deleteBtnDelagate <NSObject>

-(void)buttonDelete:(NSString *)goodsId goodsSpec:(NSString *)goodsSpec;

@end

@interface HZDSCartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UITextField *numTF;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *specLabel;

@property(strong,nonatomic)HZDSCartModel* carModel;

@property (nonatomic, weak) id<deleteBtnDelagate> delegate;

@end
