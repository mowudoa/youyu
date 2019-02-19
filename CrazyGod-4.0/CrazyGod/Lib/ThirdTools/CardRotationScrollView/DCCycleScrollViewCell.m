//
//  DCCycleScrollViewCell.m
//  DCCycleScrollView
//
//  Created by cheyr on 2018/2/27.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import "DCCycleScrollViewCell.h"
#import <AVFoundation/AVFoundation.h>
@interface DCCycleScrollViewCell()

@end

@implementation DCCycleScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.infoLabel];

    }
    return self;
}
-(void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height - 20);

    self.infoLabel.frame = CGRectMake(0,self.bounds.size.height - 20,self.bounds.size.width,20);

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:self.imgCornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height - 40);
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
}

-(UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
-(UILabel *)infoLabel
{
    if (_infoLabel == nil) {
        
        _infoLabel = [[UILabel alloc] init];
        
        _infoLabel.font = [UIFont systemFontOfSize:12];
        
        _infoLabel.textColor = [UIColor blackColor];
        
        _infoLabel.numberOfLines = 0;
        
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _infoLabel;
}
@end
