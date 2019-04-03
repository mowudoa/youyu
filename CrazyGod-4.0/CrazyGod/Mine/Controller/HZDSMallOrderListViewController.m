//
//  HZDSMallOrderListViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/24.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMallOrderListViewController.h"
#import "HZDSMallOrderDetailViewController.h"
#import "HZDSShopOrderViewController.h"
#import "HZDSEvaluateViewController.h"
#import "HZDSOrderTableViewCell.h"
#import "HZDSShopMallModel.h"
#import "HZDSOrderModel.h"

@interface HZDSMallOrderListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
{
    
    NSString *mallOrderStatus;
}

@property (weak, nonatomic) IBOutlet UITableView *mallOrderListTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroudView;

@property(nonatomic,strong) NSMutableArray *mallOrderDataSource;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDSMallOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mallOrderDataSource = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
}
-(void)initUI
{
 
    _pageNum = 1;
    
    _totalPage = 1;
    
  //  mallOrderStatus = @"1";
    
    // 下拉加载
    self.mallOrderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
   
        [self initData];
    
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.mallOrderListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
    }];
    
    self.navigationItem.title = @"商城订单";
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(1,41,(SCREEN_WIDTH - 2)/6,2)];
   
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"#FF0270"];
    
    [self.view addSubview:_lineLabel];
    
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSOrderTableViewCell" bundle:nil];
    
    [_mallOrderListTableView registerNib:nib forCellReuseIdentifier:@"OrderTableViewCell"];
    
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"aready":mallOrderStatus
                          };
    
    
    [CrazyNetWork CrazyRequest_Post:SHOPPING_MALL_ORDER parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商城订单列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.mallOrderDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
            strongSelf.mallOrderListTableView.hidden = NO;
               
            strongSelf.backGroudView.hidden = YES;
                
            }else{
                
            strongSelf.mallOrderListTableView.hidden = YES;
            
            strongSelf.backGroudView.hidden = NO;
                
            }
            
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSShopMallModel *model = [[HZDSShopMallModel alloc] init];
                
                model.orderID = dict1[@"order_id"];
                
                model.orderPrice = [dict1[@"total_price"] stringValue];
               
                model.orderStatus = dict1[@"status"];
                
                model.orderType = dict1[@"is_dianping"];
                
                model.orderTime = dict1[@"create_time"];
                
                NSArray *goodsArr = dict1[@"goods"];
                
                for (NSDictionary *dic1 in goodsArr) {
                    
                    HZDSOrderModel *model1 = [[HZDSOrderModel alloc] init];
                    
                    model1.orderID = dic1[@"id"];
                   
                    model1.orderImage = dic1[@"photo"];
                    
                    model1.orderTitle = dic1[@"title"];
                    
                    model1.orderNeedPayPrice = [dic1[@"total_price"] stringValue];
                    
                    model1.orderPrice = [dic1[@"price"] stringValue];

                    model1.orderNum = dic1[@"num"];
                    
                    model1.orderStatus = dic1[@"status"];
                    
                    model1.orderTime = dic1[@"create_time"];
                   
                    [model.mallGoodsArray addObject:model1];
                }
                
                
                [strongSelf.mallOrderDataSource addObject:model];
            }
            
            [strongSelf.mallOrderListTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.mallOrderListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
-(void)initMoreData
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"aready":mallOrderStatus
                          };
        
    [CrazyNetWork CrazyRequest_Post:SHOPPING_MALL_ORDER parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商城订单列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSShopMallModel *model = [[HZDSShopMallModel alloc] init];
                
                model.orderID = dict1[@"order_id"];
               
                model.orderPrice = [dict1[@"total_price"] stringValue];
                
                model.orderStatus = dict1[@"status"];
                
                model.orderTime = dict1[@"create_time"];
                
                model.orderType = dict1[@"is_dianping"];
                
                NSArray *goodsArr = dict1[@"goods"];
                
                for (NSDictionary *dic1 in goodsArr) {
                    
                    HZDSOrderModel *model1 = [[HZDSOrderModel alloc] init];
                    
                    model1.orderID = dic1[@"id"];
                    
                    model1.orderImage = dic1[@"photo"];
                    
                    model1.orderTitle = dic1[@"title"];
                    
                    model1.orderNeedPayPrice = [dic1[@"total_price"] stringValue];
                    
                    model1.orderPrice = [dic1[@"price"] stringValue];
                    
                    model1.orderNum = dic1[@"num"];
                    
                    model1.orderStatus = dic1[@"status"];
                    
                    model1.orderTime = dic1[@"create_time"];
                    
                    [model.mallGoodsArray addObject:model1];
                }
                
                [strongSelf.mallOrderDataSource addObject:model];
            }
            
            [strongSelf.mallOrderListTableView reloadData];
            
            [strongSelf.mallOrderListTableView.mj_footer endRefreshing];

            if (arr.count > 0) {
                
            }else{
                
            [JKToast showWithText:NOMOREDATA_STRING];
                
            [strongSelf.mallOrderListTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mallOrderDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HZDSShopMallModel *model = _mallOrderDataSource[section];
    
    return model.mallGoodsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    
    HZDSShopMallModel *model = _mallOrderDataSource[indexPath.section];
    
    HZDSOrderModel *model1 = model.mallGoodsArray[indexPath.row];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model1.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
    
    cell.titleLabel.text = model1.orderTitle;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"小计:￥%@X%@ = ￥%@",model1.orderPrice,model1.orderNum,model1.orderNeedPayPrice];
   
    cell.priceLabel.textColor = [UIColor redColor];
    
    cell.priceLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    HZDSShopMallModel *model = _mallOrderDataSource[indexPath.section];
    
    HZDSMallOrderDetailViewController *detail = [[HZDSMallOrderDetailViewController alloc] init];
    
    detail.order_Id = model.orderID;
    
    detail.order_Url = SHOPPING_MALL_ORDER_DETAIL;
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(143);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSShopMallModel *model = [[HZDSShopMallModel alloc] init];
   
    model = _mallOrderDataSource[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
   
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
   
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20)];
    
    shanghu.text = [NSString stringWithFormat:@"ID:%@",model.orderID];
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    
    shanghu.font=[UIFont systemFontOfSize:12];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    
    [backView addSubview:view1];
    
    UILabel *dingdantime = [WYFTools createLabel:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20) bgColor:[UIColor clearColor] text:[NSString stringWithFormat:@"下单时间:%@",[WYFTools ConvertStrToTime:model.orderTime dateModel:@"yyyy-MM-dd HH:mm:ss" withDateMultiple:1]] textFont:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:[UIColor blackColor] tag:section];

    dingdantime.adjustsFontSizeToFitWidth = YES;
    
    [view1 addSubview:dingdantime];
    
    return backView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    HZDSShopMallModel *model = [[HZDSShopMallModel alloc] init];
   
    model = _mallOrderDataSource[section];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,39,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    
    [view addSubview:lineLabel];
    
    UIButton *leftBtn = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#FF9980"] title:@"" titleFont:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:@selector(tapleftBtn:) vc:self];
    
    [WYFTools viewLayer:3 withView:leftBtn];

    [view addSubview:leftBtn];
    
    UIButton *rightBtn = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#FF9980"] title:@"" titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:@selector(tapBtn:) vc:self];
    
    [WYFTools viewLayer:3 withView:rightBtn];

    [view addSubview:rightBtn];
    
    view.backgroundColor=[UIColor whiteColor];
    
    if ([model.orderStatus isEqualToString:@"0"]) {
        
        [rightBtn setTitle:@"付款" forState:UIControlStateNormal];
       
        rightBtn.userInteractionEnabled = YES;
        
        rightBtn.hidden = NO;
        
        [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
       
        leftBtn.userInteractionEnabled = YES;
        
        leftBtn.hidden = NO;
        
    }else if ([model.orderStatus isEqualToString:@"1"]){
        
        [rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
       
        rightBtn.userInteractionEnabled = YES;
        
        rightBtn.hidden = NO;
        
        [leftBtn setTitle:@"已付款" forState:UIControlStateNormal];
       
        leftBtn.userInteractionEnabled = NO;
        
        leftBtn.backgroundColor = [UIColor colorWithHexString:@"#B5B5B5"];
        
        leftBtn.hidden = NO;
        
    }else if ([model.orderStatus isEqualToString:@"2"]){
        
        [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
       
        rightBtn.userInteractionEnabled = YES;
        
        rightBtn.hidden = NO;
        
        leftBtn.hidden = YES;
        
    }else if ([model.orderStatus isEqualToString:@"8"]){
        
        if ([model.orderType isEqualToString:@"0"]) {
           
            [rightBtn setTitle:@"我要评价" forState:UIControlStateNormal];

        }else if ([model.orderType isEqualToString:@"1"]){
            
            [rightBtn setTitle:@"已评价" forState:UIControlStateNormal];
            
            rightBtn.backgroundColor = [UIColor colorWithHexString:@"#B5B5B5"];

        }
        
        rightBtn.userInteractionEnabled = YES;
        
        rightBtn.hidden = NO;
        
        leftBtn.hidden = YES;
        
    }else if ([model.orderStatus isEqualToString:@"4"]){
        
        [rightBtn setTitle:@"取消退款" forState:UIControlStateNormal];
        rightBtn.userInteractionEnabled = YES;
        
        rightBtn.hidden = NO;
        
        leftBtn.hidden = YES;
        
    }else if ([model.orderStatus isEqualToString:@"5"]){
        
        rightBtn.hidden = YES;
        
        leftBtn.hidden = YES;
    }

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
    
}
-(void)tapleftBtn:(UIButton *)sender
{
    
    HZDSShopMallModel *model = _mallOrderDataSource[sender.tag];
    
    NSDictionary *dic = @{@"order_id":model.orderID};
    
    
    [CrazyNetWork CrazyRequest_Post:SHOPPING_MALL_ORDER_DELETE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"取消订单", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)tapBtn:(UIButton *)sender
{

    HZDSShopMallModel *model = _mallOrderDataSource[sender.tag];

    NSDictionary *dic = @{@"order_id":model.orderID};

    if ([sender.currentTitle isEqualToString:@"付款"]) {

        HZDSShopOrderViewController *order = [[HZDSShopOrderViewController alloc] init];
        
        order.orderId = model.orderID;
        
        [USER_DEFAULT setObject:@"2" forKey:@"choiceAddress"];

        [USER_DEFAULT synchronize];
        
        [self.navigationController pushViewController:order animated:YES];
       
    }else if ([sender.currentTitle isEqualToString:@"申请退款"]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"申请退款?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self orderRefund:dic];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else if ([sender.currentTitle isEqualToString:@"确认收货"]){
      
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认收货?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self receiveGoods:dic];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if ([sender.currentTitle isEqualToString:@"我要评价"]){
       
        HZDSEvaluateViewController *evaluate = [[HZDSEvaluateViewController alloc] init];
        
        evaluate.order_id = model.orderID;
        
        [self.navigationController pushViewController:evaluate animated:YES];
        
        
    }else if ([sender.currentTitle isEqualToString:@"取消退款"]){
     
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消退款?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self cancleRefund:dic];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


- (IBAction)changeOrderStatus:(UIButton *)sender {

    NSInteger num = sender.tag - 500;
    
    [self moveLineLabel:num];
    
}
-(void)initnavBtn
{
    
    
    NSInteger num = 0;
    switch (_orderType) {
        case WXMyOrderUnPay:
            num = 0;
            break;
        case WXMyOrderUnSend:
            num = 1;
            break;
        case WXMyOrderUnReceive:
            num = 2;
            break;
        case WXMyOrderUnEvaluate:
            num = 3;
            break;
        case WXMyOrderUnRefund:
            num = 4;
            break;
        case WXMyOrderRefunded:
            num = 5;
            break;
        default:
            break;
    }
    
    [self moveLineLabel:num];
    
}
-(void)moveLineLabel:(NSInteger)index
{
    
    switch (index) {
        case 0:
            mallOrderStatus = @"1";
            
            _orderType = WXMyOrderUnPay;
            break;
        case 1:
            mallOrderStatus = @"2";
            _orderType = WXMyOrderUnSend;

            break;
        case 2:
            mallOrderStatus = @"11";
            _orderType = WXMyOrderUnReceive;

            break;
        case 3:
            mallOrderStatus = @"8";
            _orderType = WXMyOrderUnEvaluate;

            break;
        case 4:
            mallOrderStatus = @"4";
            _orderType = WXMyOrderUnRefund;

            break;
        case 5:
            mallOrderStatus = @"5";
            _orderType = WXMyOrderRefunded;

            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.frame.origin.x,_lineLabel.frame.origin.y,(SCREEN_WIDTH - 2)/6, _lineLabel.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        lineFrame.origin.x = 1 + index* (SCREEN_WIDTH - 2)/6;
        
        self->_lineLabel.frame = lineFrame;
    }];
    
    [self initData];
}

//申请退款
-(void)orderRefund:(NSDictionary *)dic
{
    [CrazyNetWork CrazyRequest_Post:SHOPPING_MALL_ORDER_REFUND parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"申请退款", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}

//确认收货
-(void)receiveGoods:(NSDictionary *)dic
{
 
    [CrazyNetWork CrazyRequest_Post:SHOPPING_MALL_ORDER_RECEIVE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"确认收货", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}

//取消退款
-(void)cancleRefund:(NSDictionary *)dic
{
    
    [CrazyNetWork CrazyRequest_Post:SHOPPING_MALL_ORDER_CANCEL_REFUND parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"取消退款", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initnavBtn];

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
