//
//  HZDSShopCartViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/22.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSShopCartViewController.h"
#import "HZDSCartTableViewCell.h"
#import "HZDSLoginViewController.h"
#import "HZDSShopOrderViewController.h"
#import "HZDSshopAddressViewController.h"
#import "HZDSCartModel.h"

@interface HZDSShopCartViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
deleteBtnDelagate
>
{
    
    double GoodsPrice;

}
@property (weak, nonatomic) IBOutlet UITableView *cartListTableView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@property(nonatomic,strong)NSMutableArray *cartListArray;
@end

@implementation HZDSShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _cartListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
}
-(void)registercell
{
    
    UINib* nib = [UINib nibWithNibName:@"HZDSCartTableViewCell" bundle:nil];
    [_cartListTableView registerNib:nib forCellReuseIdentifier:@"CartTableViewCell"];
}
-(void)initUI
{
    self.navigationItem.title = @"购物车";
    
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTotalPrice:) name:@"getToalMoney" object:nil];

    _tagLabel.layer.cornerRadius = _tagLabel.frame.size.height/2;
    
    _tagLabel.layer.masksToBounds = YES;
    
    _uploadButton.layer.cornerRadius = _uploadButton.frame.size.height/6;
    
    _uploadButton.layer.masksToBounds = YES;
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_CARTLIST] parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"购物车列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.cartListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"cart_goods"];
            
            if (arr.count > 0) {
                
                strongSelf.backGroundView.hidden = YES;
                
                strongSelf.cartListTableView.hidden = NO;
                
            }else{
                strongSelf.backGroundView.hidden = NO;
                
                strongSelf.cartListTableView.hidden = YES;
            }
            
            for (NSDictionary *cart in arr) {
                
                HZDSCartModel *model = [[HZDSCartModel alloc] init];
                
                model.goodsImageUrl = cart[@"photo"];
                
                model.goodsId = cart[@"goods_id"];
                
                model.goodstitle = cart[@"title"];
                
                model.goodsnum = cart[@"buy_num"];
                
                model.goodsSpec = cart[@"guige"];
                
                model.goodsStockNum = cart[@"num"];
                
                model.goodsIdAndSpec = cart[@"goods_spec"];
                
                model.goodssalesprice = [cart[@"mall_price"] stringValue];
                
                model.isSelect = NO;
                
                [strongSelf.cartListArray addObject:model];
            }
            
            if ([dic[@"datas"][@"check_user_addr"] isKindOfClass:[NSDictionary class]]) {
                
                [strongSelf.uploadButton setTitle:@"结算" forState:UIControlStateNormal];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉,您还没有添加收货地址"
                                                              delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"立即前往",nil];
                [alert show];
                
                [strongSelf.uploadButton setTitle:@"添加地址" forState:UIControlStateNormal];

            }

            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];

            strongSelf.backGroundView.hidden = NO;
            
            strongSelf.cartListTableView.hidden = YES;
        }
        [strongSelf.cartListTableView reloadData];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}
-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 30, 30)];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cartListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSCartTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell" forIndexPath:indexPath];
    
    //    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:@"http://115.28.133.70/uploads/image/20151009/1444395668.jpg"]];
    
    [cell setCarModel:_cartListArray[indexPath.row]];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(131);
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//商品删除
-(void)rightAction:(UIButton*)sender
{
   
    
    
}
-(void)getTotalPrice:(NSNotification*)userinfo
{
    GoodsPrice = 0;
    
    int seleceteNum = 0;
    
    for (HZDSCartModel* model in _cartListArray) {
        
        if (model.isSelect) {
            
            GoodsPrice +=([model.goodssalesprice doubleValue]*[model.goodsnum integerValue]);
           
            seleceteNum ++ ;
        }
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",GoodsPrice];
    
    _tagLabel.text = [NSString stringWithFormat:@"%d",seleceteNum];
    
}
- (IBAction)uoloadToOrder:(UIButton *)sender {

    if ([sender.currentTitle isEqualToString:@"结算"]) {
      
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        for (HZDSCartModel* model in _cartListArray) {
            
            if (model.isSelect) {
                
                [dict setObject:model.goodsnum forKey:[NSString stringWithFormat:@"num[%@]",model.goodsIdAndSpec]];
                
            }
        }
        
        if (dict == nil) {
            
            [JKToast showWithText:@"请选择商品"];
            
            return;
        }
        
        
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_UPLOADORDER] parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"结算", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                    
                    HZDSShopOrderViewController *order = [[HZDSShopOrderViewController alloc] init];
                    
                    NSArray *arr = [dic[@"datas"] allKeys];
                    
                    for (NSString *str in arr) {
                        
                        if ([str isEqualToString:@"order_id"]) {
                        
                            order.orderId = dic[@"datas"][str];
                        }
                        if ([str isEqualToString:@"log_id"]) {
                            
                            order.logId = dic[@"datas"][str];
                        }
                        
                    }
                
                [USER_DEFAULT removeObjectForKey:@"choiceAddress"];

                    order.orderDic = dic;
                
                    [self.navigationController pushViewController:order animated:YES];
                            
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }else if ([sender.currentTitle isEqualToString:@"添加地址"]){
       
        HZDSshopAddressViewController *address = [[HZDSshopAddressViewController alloc] init];
        
        [self.navigationController pushViewController:address animated:YES];
    
    }
    
    
}
-(void)buttonDelete:(NSString *)goodsId goodsSpec:(NSString *)goodsSpec
{
    
    NSDictionary *dic = @{@"goods_spec":goodsSpec
                          };
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_CARTLIST_DELETE] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"删除购物车", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}

#pragma mark UIALERTVIEWDELEGATE
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
      
       
        
    }else if (buttonIndex == 1){
        
        HZDSshopAddressViewController *address = [[HZDSshopAddressViewController alloc] init];
        
        [self.navigationController pushViewController:address animated:YES];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if ([USER_DEFAULT boolForKey:@"isLogin"]) {
        
        [self initData];

       
    }else{
        
        [JKToast showWithText:@"请先登录"];
        
        HZDSLoginViewController *login = [[HZDSLoginViewController alloc] init];
        
        [self.navigationController pushViewController:login animated:YES];
    }
    
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
