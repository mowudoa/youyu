//
//  HZDSShopOrderViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/22.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSShopOrderViewController.h"
#import "HZDSMallOrderDetailViewController.h"
#import "HZDSshopAddressViewController.h"
#import "HZDSpayTypeTableViewCell.h"
#import "HZDSOrderTableViewCell.h"
#import "HZDSShoopTypeModel.h"
#import "HZDSClassifyModel.h"
#import "HZDSOrderModel.h"
#import "WXApi.h"


@interface HZDSShopOrderViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate
>
@property (weak, nonatomic) IBOutlet UIButton *uploadOrderButton;

@property (weak, nonatomic) IBOutlet UIButton *selecteAddressButton;

@property (weak, nonatomic) IBOutlet UITableView *payTypeTableView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *userdetailLabel;

@property(nonatomic,strong) NSMutableArray *payTypeDataSource;

@property(nonatomic,strong) NSMutableArray *payTypeArray;

@property(nonatomic,strong) NSMutableArray *shopNameArray;

@property(nonatomic,copy) NSString *payTypeString;

@property(nonatomic,copy) NSString *payNameString;

@end

@implementation HZDSShopOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _payTypeDataSource = [[NSMutableArray alloc] init];
    
    _shopNameArray = [[NSMutableArray alloc] init];
    
    _payTypeArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
}
-(void)initUI
{
    self.navigationItem.title = @"订单设定";
    
    [WYFTools viewLayer:_uploadOrderButton.height/16*3 withView:_uploadOrderButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifuchonggongWithMall:) name:@"zhifuchenggongWithMall" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifushibaiWithMall:) name:@"zhifushibaiWithall" object:nil];

}
-(void)registercell
{
    
    UINib* nib = [UINib nibWithNibName:@"HZDSOrderTableViewCell" bundle:nil];
    
    [_payTypeTableView registerNib:nib forCellReuseIdentifier:@"OrderTableViewCell"];
    
}
-(void)initData
{
        
    [_shopNameArray removeAllObjects];
    
    [_payTypeDataSource removeAllObjects];
    
    if ([_orderDic[@"datas"][@"defaultAddress"] isKindOfClass:[NSDictionary class]]) {
     
        _userNameLabel.text = _orderDic[@"datas"][@"defaultAddress"][@"xm"];
        
        _userPhoneLabel.text = _orderDic[@"datas"][@"defaultAddress"][@"tel"];
        
        _userdetailLabel.text = [NSString stringWithFormat:@"%@%@",_orderDic[@"datas"][@"defaultAddress"][@"area_str"],_orderDic[@"datas"][@"defaultAddress"][@"info"]];
        
    }else{
        
        [JKToast showWithText:@"请先选择收货地址"];
        
        [_uploadOrderButton setTitle:@"选择收货地址" forState:UIControlStateNormal];
    }
            
        NSArray *keysarr = [_orderDic[@"datas"][@"ordergoods"] allKeys];
            
        for (NSString *keyStr in keysarr) {
                
            NSArray *goodsArr = _orderDic[@"datas"][@"ordergoods"][keyStr];
                
            HZDSShoopTypeModel *model = [[HZDSShoopTypeModel alloc] init];
                
            model.shopId = keyStr;
                
            for (NSDictionary *dict1 in goodsArr) {
                 
                    
                HZDSOrderModel *order = [[HZDSOrderModel alloc] init];
                    
                order.orderID = dict1[@"goods_id"];
                    
                order.orderNum = dict1[@"num"];
                    
                order.orderPrice = [dict1[@"price"] stringValue];
                    
                order.orderImage = dict1[@"photo"];
                    
                order.orderTitle = dict1[@"goods_name"];
                    
                order.orderNeedPayPrice = [dict1[@"total_price"] stringValue];
                    
                [model.goodsArray addObject:order];
                
            }

                [_payTypeDataSource addObject:model];
                
        }
            
            NSDictionary *shopDic = _orderDic[@"datas"][@"shop"];

            NSArray *shopNameArr = [shopDic allKeys];
            
            for (NSString *str1 in shopNameArr) {
                
                HZDSClassifyModel *model2 = [[HZDSClassifyModel alloc] init];
                
                model2.classId = str1;
                
                model2.className = shopDic[str1];
                
                [_shopNameArray addObject:model2];
                
            }
    
        [_payTypeTableView reloadData];
        

}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _payTypeDataSource.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HZDSShoopTypeModel *model = _payTypeDataSource[section];
    
    return model.goodsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZDSOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    
    HZDSShoopTypeModel *order = _payTypeDataSource[indexPath.section];
    
    HZDSOrderModel *model = order.goodsArray[indexPath.row];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.orderImage]]];
    
    cell.titleLabel.text = model.orderTitle;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"小计:￥%@ X %@ = ￥%@",model.orderPrice,model.orderNum,model.orderNeedPayPrice];
    
    cell.priceLabel.textColor = [UIColor redColor];
    
    return cell;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSShoopTypeModel *model = _payTypeDataSource[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [backView addSubview:lineLabel];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20,20)];

    for (HZDSClassifyModel *model1 in _shopNameArray) {
        
        if ([model1.classId isEqualToString:model.shopId]) {
            
            shanghu.text = model1.className;
        }
        
    }
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    
    shanghu.font=[UIFont systemFontOfSize:12];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    
    [backView addSubview:shanghu];
    
    return backView;
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(143);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (IBAction)uploadOrder:(UIButton *)sender {

    
    if ([sender.currentTitle isEqualToString:@"提交订单"]) {
    
        __weak typeof(self) weakSelf = self;
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,PAYTYPE_LIST] parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"支付类型", dic);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.payTypeArray removeAllObjects];
            
            if (SUCCESS) {
                
                NSArray *arr = dic[@"datas"][@"payment"];
                
                for (NSDictionary *dict1 in arr) {
                    
                    HZDSOrderModel *order = [[HZDSOrderModel alloc] init];
                    
                    order.orderID = dict1[@"payment_id"];
                    
                    order.orderTitle = dict1[@"name"];
                    
                    order.orderStatus = dict1[@"code"];
                    
                    order.orderImage = dict1[@"mobile_logo"];
                    
                    [strongSelf.payTypeArray addObject:order];
                    
                }
                
                [self showPayType];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }else if ([sender.currentTitle isEqualToString:@"选择收货地址"]){
        
        HZDSshopAddressViewController *address = [[HZDSshopAddressViewController alloc] init];
        
        [USER_DEFAULT setObject:@"1" forKey:@"choiceAddress"];
        
        if (_orderId != nil) {
            
            address.orderID = _orderId;
        }
        if (_logId != nil) {
            
            address.LogID = _logId;
        }
        
        [self.navigationController pushViewController:address animated:YES];
    }


}
-(void)showPayType
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付方式选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    for (HZDSOrderModel *model in _payTypeArray) {
        
        [alert addAction:[UIAlertAction actionWithTitle:model.orderTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self actionsheetSelected:model];
            
        }]];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)actionsheetSelected:(HZDSOrderModel *)model
{
    //单个商品支付和多个商品支付接口不一样,根据商品数量判断调用那个接口
    if ([model.orderTitle isEqualToString:@"微信支付"]) {
        
        _payNameString = @"微信支付";
        
        if (![WXApi isWXAppInstalled]) {
            
            [JKToast showWithText:@"推荐安装微信后使用"];
            
            return;
        }
        
        if (_orderId != nil) {
            
            [self payOneGoods:model.orderStatus];
        }
        if (_logId != nil) {
            
            [self payMoreGoods:model.orderStatus];
        }
        
    }else if ([model.orderTitle isEqualToString:@"余额支付"]){
        
        _payNameString = @"余额支付";

        if (_orderId != nil) {
            
            [self payOneGoods:model.orderStatus];
        }
        if (_logId != nil) {
            
            [self payMoreGoods:model.orderStatus];
        }
    }
    
}

-(void)payOneGoods:(NSString *)code
{
 
    NSDictionary *dic = @{@"order_id":_orderId,
                          @"code":code
                          };
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,PAY_WITHONEGOODS] parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"支付", dic);
        
        if (SUCCESS) {
            
            [self gopay:[dic[@"datas"][@"log_id"] stringValue]];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)payMoreGoods:(NSString *)code
{
    NSDictionary *dic = @{@"log_id":_logId,
                          @"code":code
                          };
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,PAY_WITHMOREGOODS] parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"支付", dic);

        if (SUCCESS) {
            
            [self gopay:[dic[@"datas"][@"log_id"] stringValue]];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)gopay:(NSString *)payCode
{
    
    if ([_payNameString isEqualToString:@"微信支付"]) {
      
        NSDictionary *dict = @{@"log_id":payCode
                               };
        
        [CrazyNetWork CrazyRequest_Post:PAY_WCHAT parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"微信支付", dic);
            
            if (SUCCESS) {
                
                PayReq *req  = [[PayReq alloc] init];
                
                req.openID = dic[@"datas"][@"pay"][@"appid"];
                
                req.partnerId = dic[@"datas"][@"pay"][@"partnerid"];
                
                req.prepayId = dic[@"datas"][@"pay"][@"prepayid"];
                
                req.package = dic[@"datas"][@"pay"][@"package"];
                
                req.nonceStr = dic[@"datas"][@"pay"][@"noncestr"];
                
                req.timeStamp = [dic[@"datas"][@"pay"][@"timestamp"] intValue];
                
                req.sign = dic[@"datas"][@"pay"][@"sign"];
                
                //调起微信支付
                if ([WXApi sendReq:req]) {
                    NSLog(@"吊起成功");
                    
                    [USER_DEFAULT setObject:@"1" forKey:@"payGoodsOrMall"];
                }
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }else if ([_payNameString isEqualToString:@"余额支付"]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
            UITextField *pass = alertController.textFields.firstObject;

            if (pass.text != nil) {
                
                NSDictionary *urlDict = @{@"pay_password":pass.text,
                      @"user_id":[USER_DEFAULT objectForKey:@"User_ID"]
                                          };
                [CrazyNetWork CrazyRequest_Post:PAY_BALANCE_CHECKPASS parameters:urlDict HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
                    
                    LOG(@"支付密码检测", dic);
                    
                    if (SUCCESS) {
                        
                        [self payWithBalance:payCode];
                        
                    }else{
                        
                        [JKToast showWithText:dic[@"datas"][@"error"]];
                        
                    }
                    
                } fail:^(NSError *error, NSString *url, NSString *Json) {
                    
                }];
                
                
            }
            
        }
        ];
            
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:okAction];
        
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:^{
                
        }];

    }
 
}
-(void)payWithBalance:(NSString *)logId
{
    
    NSDictionary *dict = @{@"logs_id":logId
                           };
    
    [CrazyNetWork CrazyRequest_Post:PAY_BALANCE parameters:dict HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"余额支付", dic);
        
        if (SUCCESS) {
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuchenggongWithMall" object:nil];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
-(void)zhifuchonggongWithMall:(NSNotification*)userinfo
{
    [JKToast showWithText:@"支付成功"];
    
    HZDSMallOrderDetailViewController *detail = [[HZDSMallOrderDetailViewController alloc] init];
    
    if (_orderId != nil) {
        
        detail.order_Id = _orderId;
    }
    if (_logId != nil) {
        
        detail.order_Id = _logId;
    }

    detail.order_Url = SHOPPING_MALL_ORDER_DETAIL;
    
    detail.orderPay = @"OrderPay";
    
    [self.navigationController pushViewController:detail animated:YES];
    
}
-(void)zhifushibaiWithMall:(NSNotification*)userinfo
{
    [JKToast showWithText:@"支付失败"];
    
}
- (IBAction)choiceAddress:(UIButton *)sender {

    HZDSshopAddressViewController *address = [[HZDSshopAddressViewController alloc] init];
    
    [USER_DEFAULT setObject:@"1" forKey:@"choiceAddress"];
    
    if (_orderId != nil) {
     
        address.orderID = _orderId;
    }
    if (_logId != nil) {
       
        address.LogID = _logId;
    }
    
    [self.navigationController pushViewController:address animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //选择地址有三个位置,直接购买选择,订单位置(地址不能更改),个人中心查看地址列表,须加以判断
    if ([[USER_DEFAULT objectForKey:@"choiceAddress"] isEqualToString:@"1"] || [[USER_DEFAULT objectForKey:@"choiceAddress"] isEqualToString:@"2"]) {
        
        if ([[USER_DEFAULT objectForKey:@"choiceAddress"] isEqualToString:@"2"]) {
           
            _selecteAddressButton.userInteractionEnabled = NO;
            
        }else{
            
            _selecteAddressButton.userInteractionEnabled = YES;

        }
        
        [self getAddressInfo];
        
        [USER_DEFAULT removeObjectForKey:@"choiceAddress"];
        
    }else{
        
        [self initData];

    }
    
}
-(void)getAddressInfo
{
    NSDictionary *dic;
    
    
    if (_orderId != nil) {
     
        dic = @{@"order_id":_orderId};
    }
    if (_logId != nil) {
        
        dic = @{@"log_id":_logId};
    }
    
    __weak typeof(self) weakSelf = self;

    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_ORDER_SET] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"获取地址信息", dic);
        
        
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf.shopNameArray removeAllObjects];
        
        [strongSelf.payTypeDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSDictionary *dict = dic[@"datas"][@"defaultAddress"];
          
            strongSelf.userNameLabel.text = dict[@"xm"];
            
            strongSelf.userPhoneLabel.text = dict[@"tel"];
            
            strongSelf.userdetailLabel.text = [NSString stringWithFormat:@"%@%@",dict[@"area_str"],dict[@"info"]];
            
            NSArray *keysarr = [dic[@"datas"][@"ordergoods"] allKeys];
            
            for (NSString *keyStr in keysarr) {
                
                NSArray *goodsArr = dic[@"datas"][@"ordergoods"][keyStr];
                
                HZDSShoopTypeModel *model = [[HZDSShoopTypeModel alloc] init];
                
                model.shopId = keyStr;
                
                for (NSDictionary *dict1 in goodsArr) {
                    
                    
                    HZDSOrderModel *order = [[HZDSOrderModel alloc] init];
                    
                    order.orderID = dict1[@"goods_id"];
                    
                    order.orderNum = dict1[@"num"];
                    
                    order.orderPrice = [dict1[@"price"] stringValue];
                    
                    order.orderImage = dict1[@"photo"];
                    
                    order.orderTitle = dict1[@"goods_name"];
                    
                    order.orderNeedPayPrice = [dict1[@"total_price"] stringValue];
                    
                    [model.goodsArray addObject:order];
                }
                
                
                [strongSelf.payTypeDataSource addObject:model];
                
            }
            
            NSDictionary *shopDic = dic[@"datas"][@"shop"];
            
            NSArray *shopNameArr = [shopDic allKeys];
            
            for (NSString *str1 in shopNameArr) {
                
                HZDSClassifyModel *model2 = [[HZDSClassifyModel alloc] init];
                
                model2.classId = str1;
                
                model2.className = shopDic[str1];
                
                [strongSelf.shopNameArray addObject:model2];
                
            }
            
            [strongSelf.payTypeTableView reloadData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
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
