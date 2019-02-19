//
//  HZDSCartTableViewCell.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/22.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSCartTableViewCell.h"

@implementation HZDSCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [self initcell];
}
-(void)initcell
{
    [_selectedButton setImage:[UIImage imageNamed:@"radioed.png"] forState:UIControlStateSelected];
    [_selectedButton setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    
    _numLabel.layer.cornerRadius = 4;
    
    _numLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _numLabel.layer.borderWidth = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:@"doneAction" object:nil];
    
}
-(void)setCarModel:(HZDSCartModel *)carModel
{
    _carModel = carModel;
    
    _selectedButton.selected = carModel.isSelect;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,carModel.goodsImageUrl]]];
    
    _titleLabel.text = carModel.goodstitle;
    
    _specLabel.text = [NSString stringWithFormat:@"规格:%@",carModel.goodsSpec];
    
    _priceLabel.text = [NSString stringWithFormat:@"单价:￥%@",carModel.goodssalesprice];
    
    _numTF.text = carModel.goodsnum;
}
- (IBAction)clickButton:(UIButton *)sender {

    NSInteger num = [_numTF.text integerValue];

    if ([_carModel.goodsStockNum integerValue]<=0) {
        
        [JKToast showWithText:@"没有剩余库存"];
        
        return;
    }else{
        
        if (sender.tag == 10) {
            if (![self.numTF.text isEqualToString:@"1"]) {
                
                num --;
            }else{

                [JKToast showWithText:@"数量不能少于1"];

                return;
            }
        }else
        {
            num++;
        }
        
        if (num > [_carModel.goodsStockNum integerValue]) {
            
            [JKToast showWithText:@"已达到最大库存限制"];

            return;
        }
        
    }
    
    _numTF.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    _carModel.goodsnum = _numTF.text;

    [self refreshCartList];
}
- (IBAction)slectedClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.carModel.isSelect = sender.selected;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getToalMoney" object:self userInfo:nil];
}
-(void)refreshCartList
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getToalMoney" object:self userInfo:nil];

}
- (void)done:(NSNotification *)notification{
    //done按钮的操作
    
    if (_numTF.text.length > 1) {
        
        NSString *firstStr = [_numTF.text substringToIndex:1];
        
        if ([firstStr isEqualToString:@"0"]) {
            
            _numTF.text = [_numTF.text substringFromIndex:1];
            
        }
        
    }
    
    
    if ([_carModel.goodsStockNum integerValue] <= 0) {
        
        [JKToast showWithText:@"没有剩余库存"];
        
        return;
    }else if ([_numTF.text integerValue] > [_carModel.goodsStockNum integerValue]){
        

        [JKToast showWithText:@"已达到最大库存限制"];
        
        _numTF.text = [NSString stringWithFormat:@"%ld",[_carModel.goodsStockNum integerValue]];
        
        [self refreshCartList];
        
        return;
        
    }else{
        
        
        
        
        if (_numTF.text.length > 0) {
            
            _carModel.goodsnum = _numTF.text;
            
            [self refreshCartList];
        }else if ([_numTF.text isEqualToString:@""] ||[_numTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || [_numTF.text isEqualToString:@"0"]){
            
            _numTF.text = @"1";
            
            _carModel.goodsnum = _numTF.text;
            
            [self refreshCartList];
            
        }
        
    }
    
}
- (IBAction)deleteGoods:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(buttonDelete:goodsSpec:)]) {
        
        
        [self.delegate buttonDelete:_carModel.goodsId goodsSpec:_carModel.goodsIdAndSpec];
    }
    
}

@end
