//
//  HZDSlikeGoodsCollectionViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/18.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZDSlikeGoodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsInfo;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
