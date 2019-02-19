//
//  HZDSbusinessGoodsCollectionViewCell.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/5.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZDSbusinessGoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfo;

@end
