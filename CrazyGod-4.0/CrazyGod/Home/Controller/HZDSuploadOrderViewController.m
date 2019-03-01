//
//  HZDSuploadOrderViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/12.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSuploadOrderViewController.h"
#import "HZDSPayViewController.h"

@interface HZDSuploadOrderViewController ()
{
    
    NSInteger num;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *reduceButton;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property(nonatomic,copy) NSString *price;

@end

@implementation HZDSuploadOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"提交订单";

    _numLabel.layer.borderColor = [UIColor grayColor].CGColor;
   
    _numLabel.layer.borderWidth = 0.5;
    
    _uploadButton.layer.cornerRadius = _uploadButton.frame.size.height/16*3;
    
    _uploadButton.layer.masksToBounds = YES;
}

-(void)initData
{
    NSDictionary* dic = @{@"tuan_id":_goodId};
    
    __weak typeof(self) weakSelf = self;

    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",UPLOAD_ORDER] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"抢购详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            NSDictionary* List = dic[@"datas"][@"detail"];
            
            strongSelf.titleLabel.text = List[@"title"];
            
            strongSelf.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",[List[@"price"] stringValue]];
            
            strongSelf.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",[List[@"price"] stringValue]];
            
            strongSelf.priceLabel.text = [NSString stringWithFormat:@"%@元",[List[@"tuan_price"] stringValue]];
            
            strongSelf.totalMoneyLabel.text = [NSString stringWithFormat:@"%@元",[List[@"tuan_price"] stringValue]];
            
            strongSelf.numLabel.text = @"1";
            
            strongSelf.price = [List[@"tuan_price"] stringValue];
            
            strongSelf.phoneLabel.text = dic[@"datas"][@"mobile"];
        }else{
            
            [JKToast showWithText:dic[@"msg"]];
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];

}
- (IBAction)uploadOrder:(UIButton *)sender {

 
    
    NSDictionary* dic = @{@"tuan_id":_goodId,
                          @"num":_numLabel.text
                          };
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@",CREATE_ORDER] parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"提交订单", dic);
        
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];

            HZDSPayViewController *pay = [[HZDSPayViewController alloc] init];
            
            pay.orderId = dic[@"datas"][@"order_id"];
            
            [self.navigationController pushViewController:pay animated:YES];
            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
    
}
- (IBAction)numaddOrReduce:(UIButton *)sender {

    if (sender.tag == 10) {
        
        if (![self.numLabel.text isEqualToString:@"1"]) {
            
            num --;
        }else{
            
            [JKToast showWithText:@"商品数不能少于1"];
            return;
        }
    }else
    {
        num++;
    }

    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    _totalMoneyLabel.text = [NSString stringWithFormat:@"%.f元",num *[_price doubleValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
