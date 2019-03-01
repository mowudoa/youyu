//
//  HZDSMyCouponTableViewCell.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMyCouponTableViewCell.h"

@implementation HZDSMyCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCouponModel:(HZDScouponModel *)couponModel
{
    _couponModel = couponModel;
    
    _titleLabel.text = [NSString stringWithFormat:@"名称:%@",couponModel.couponTite];
    
    _shopName.text = [NSString stringWithFormat:@"商家名称:%@",couponModel.couponShop];
    
    _couponID.text = [NSString stringWithFormat:@"消费券编号:%@",couponModel.couponID];
    
    _orderId.text = [NSString stringWithFormat:@"订单ID:%@",couponModel.couponOrderCode];
    
    _couponNum.text = [NSString stringWithFormat:@"消费码:%@",couponModel.couponNUm];
    
    _couponTime.text = [NSString stringWithFormat:@"生成时间:%@",couponModel.couponTime];
    
    _timeLabel.text = couponModel.couponTime;

    _couponTime.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}
- (IBAction)codeButton:(UIButton *)sender {

    
    if ([self.delegate respondsToSelector:@selector(couponSleected:withcouponID:)]) {
    
        [self.delegate couponSleected:_couponModel.couponStatus withcouponID:_couponModel.couponID];
    
    }
}

@end
