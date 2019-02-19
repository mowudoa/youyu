//
//  HZDSshopAddressTableViewCell.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/23.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSshopAddressTableViewCell.h"

@implementation HZDSshopAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [_defaultButton setImage:[UIImage imageNamed:@"radioed.png"] forState:UIControlStateSelected];
    [_defaultButton setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    
}
-(void)setAddressmodel:(HZDSAddressModel *)addressmodel
{
    _addressmodel = addressmodel;
    
    _nameLabel.text = addressmodel.userName;
    
    _phoneLabel.text = addressmodel.userPhone;
    
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",addressmodel.address,addressmodel.addressDetail];
    
    if ([addressmodel.is_default isEqualToString:@"1"]) {
        
        _defaultButton.selected = YES;
        
        _deleteButton.hidden = YES;
    }else{
        
        _defaultButton.selected = NO;
        
        _deleteButton.hidden = NO;
    }
}

- (IBAction)editAddress:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(buttonEdit:withMode:)]) {
        
        [self.delegate buttonEdit:_addressmodel.addressId withMode:_addressmodel];
    }
}
- (IBAction)deleteAddress:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(buttonDelete:)]) {
        
        [self.delegate buttonDelete:_addressmodel.addressId];
    }
    
}

@end
