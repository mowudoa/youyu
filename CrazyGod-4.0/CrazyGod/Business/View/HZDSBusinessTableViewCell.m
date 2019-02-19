//
//  HZDSBusinessTableViewCell.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/7.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSBusinessTableViewCell.h"

@implementation HZDSBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBussinessModel:(HZDSBusinessModel *)bussinessModel
{
    _bussinessModel = bussinessModel;
   
    _businessLocation.text = [NSString stringWithFormat:@"距离%@",bussinessModel.businessLocation];
    
    [_businessIcon sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,bussinessModel.businessIcon]]];
    
    _businessType.text = bussinessModel.businessType;
    
    _businessName.text = bussinessModel.businessName;
    
    _businessPrice.text = [NSString stringWithFormat:@"人均省钱￥%@元",bussinessModel.businessPrice];

    _businessSaleNum.text = [NSString stringWithFormat:@"月售%@",bussinessModel.businessSaleNum];

    
    _businessTagsView.width = SCREEN_WIDTH - 20 - _businessTagsView.mj_x;

    for (UIView *view in _businessTagsView.subviews)
    {
        
        [view removeFromSuperview];
    }
    
    [WYFTools createTagLabel:[UIFont systemFontOfSize:12] tagArray:_bussinessModel.goodsArray itemSpace:2 itemHeight:20 currentX:0 currentY:0 superView:_businessTagsView];

    _stareView.numofStar = [_bussinessModel.businessStarNum intValue];
    _stareView.selectingenabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
