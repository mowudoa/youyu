//
//  HZDSClassTableViewCell.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSClassTableViewCell.h"

@implementation HZDSClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClassArray:(NSArray *)classArray
{
    _classArray  = classArray;
    
    for (int i = 0; i < _classArray.count; i ++ ) {
        
        switch (i) {
            case 0:
                
                [_titleBtn1 sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_classArray[i][@"photo"]]] forState:UIControlStateNormal];
                
                _titleLabel1.text = _classArray[i][@"nav_name"];
                
                break;
            case 1:
                
                [_titleBtn2 sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_classArray[i][@"photo"]]] forState:UIControlStateNormal];
                
                _ttitleLabel2.text = _classArray[i][@"nav_name"];
                
                break;
             
            case 2:
                
                [_titleBtn3 sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_classArray[i][@"photo"]]] forState:UIControlStateNormal];
                
                _titleLabel3.text = _classArray[i][@"nav_name"];
                
                break;
            case 3:
                
                [_titleBtn4 sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_classArray[i][@"photo"]]] forState:UIControlStateNormal];
                
                _titleLable4.text = _classArray[i][@"nav_name"];
                
                break;
            case 4:
                
                [_titleBtn5 sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_classArray[i][@"photo"]]] forState:UIControlStateNormal];
                
                _titleLabel5.text = _classArray[i][@"nav_name"];
                
                break;


            default:
                break;
        }
        
    }
    
    
}
- (IBAction)btnSelected:(UIButton *)sender {

    
    
    if ([self.delegate respondsToSelector:@selector(buttonSleected:buttonID:)]) {
        
        
        [self.delegate buttonSleected: _classArray[sender.tag - 101][@"nav_name"] buttonID:_classArray[sender.tag - 101][@"cat_num"]];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
