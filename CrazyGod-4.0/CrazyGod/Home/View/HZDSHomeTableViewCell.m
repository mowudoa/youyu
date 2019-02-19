//
//  HZDSHomeTableViewCell.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSHomeTableViewCell.h"

@implementation HZDSHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
}
-(void)setHomeModel:(HomeModel *)homeModel
{
    for (UIView *view in _tagView.subviews) {
        
        [view removeFromSuperview];
    }
    
    _homeModel = homeModel;
    
    _titleLabel.text = _homeModel.goodsName;
    
    _distanceLabel.text = [NSString stringWithFormat:@"距离%@",_homeModel.distance];
    
    [_goodIconImage sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_homeModel.goodsIcon]]];
 
    _tagView.width = SCREEN_WIDTH - 34 - (self.height - 28);
    
    
    
    [WYFTools createTagLabel:[UIFont systemFontOfSize:12] tagArray:_homeModel.tagArray itemSpace:2 itemHeight:20 currentX:0 currentY:0 superView:_tagView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
