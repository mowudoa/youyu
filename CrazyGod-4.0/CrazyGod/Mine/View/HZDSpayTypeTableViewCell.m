//
//  HZDSpayTypeTableViewCell.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSpayTypeTableViewCell.h"

@implementation HZDSpayTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectedButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedButton:)]) {
        
        [self.delegate selectedButton:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
