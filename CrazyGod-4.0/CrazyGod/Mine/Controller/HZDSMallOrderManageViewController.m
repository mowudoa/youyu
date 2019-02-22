//
//  HZDSMallOrderManageViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/28.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMallOrderManageViewController.h"
#import "HZDSSendByExpressViewController.h"
#import "HZDSMallOrderDetailViewController.h"
#import "HZDSOrderTableViewCell.h"
#import "HZDSOrderModel.h"
#import "HZDSShopMallModel.h"
@interface HZDSMallOrderManageViewController ()<
UITableViewDataSource,
UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *orderListArray;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,copy) NSString *orderStatus;

@property(nonatomic,copy) NSString *orderUrl;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDSMallOrderManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _orderListArray = [[NSMutableArray alloc] init];

    [self initUI];
    
    [self registercell];
    
    [self initData];
}
-(void)initUI
{
    _orderUrl = MALL_MANAGE_ORDER;
    
    self.navigationItem.title = @"订单列表";
    
    _pageNum = 1;
    
    _totalPage = 1;
    
    _orderStatus = @"1";
    
    //  mallOrderStatus = @"1";
    
    // 下拉加载
    self.orderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.orderListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.orderListTableView.mj_footer endRefreshing];

    }];
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,40,SCREEN_WIDTH/2,2)];
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"FF0270"];
    [self.view addSubview:_lineLabel];
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSOrderTableViewCell" bundle:nil];
    [_orderListTableView registerNib:nib forCellReuseIdentifier:@"OrderTableViewCell"];
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_orderUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.orderListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"$list"];
            
            if (arr.count > 0) {
                
                strongSelf.orderListTableView.hidden = NO;
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.orderListTableView.hidden = YES;
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSShopMallModel *model = [[HZDSShopMallModel alloc] init];
                
                model.orderID = dict1[@"order_id"];
                model.orderPrice = [dict1[@"total_price"] stringValue];
                model.orderStatus = dict1[@"status"];
                
                model.orderType = dict1[@"is_mobile"];
                
                model.orderTime = dict1[@"create_time"];
                
                NSArray *goodsArr = dict1[@"goods"];
                
                for (NSDictionary *dic1 in goodsArr) {
                    
                    HZDSOrderModel *model1 = [[HZDSOrderModel alloc] init];
                    
                    model1.orderID = dic1[@"goods_id"];
                    model1.orderImage = dic1[@"photo"];
                    model1.orderTitle = dic1[@"title"];
                    model1.orderPrice = [dic1[@"mall_price"] stringValue];
                    model1.orderNeedPayPrice = [dic1[@"price"] stringValue];
                    
                    model1.orderNum = dic1[@"num"];
                    model1.orderStatus = dic1[@"status"];
                    
                    [model.mallGoodsArray addObject:model1];
                }
                
                
                [strongSelf.orderListArray addObject:model];
            }
            
            [strongSelf.orderListTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.orderListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)initMoreData
{
    __weak typeof(self) weakSelf = self;
    
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_orderUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"$list"];
          
            for (NSDictionary *dict1 in arr) {
                
                HZDSShopMallModel *model = [[HZDSShopMallModel alloc] init];
                
                model.orderID = dict1[@"order_id"];
                model.orderPrice = [dict1[@"total_price"] stringValue];
                model.orderStatus = dict1[@"status"];
                
                model.orderType = dict1[@"is_mobile"];
                
                model.orderTime = dict1[@"create_time"];
                
                NSArray *goodsArr = dict1[@"goods"];
                
                for (NSDictionary *dic1 in goodsArr) {
                    
                    HZDSOrderModel *model1 = [[HZDSOrderModel alloc] init];
                    
                    model1.orderID = dic1[@"goods_id"];
                    model1.orderImage = dic1[@"photo"];
                    model1.orderTitle = dic1[@"title"];
                    model1.orderPrice = [dic1[@"mall_price"] stringValue];
                    model1.orderNeedPayPrice = [dic1[@"price"] stringValue];
                    
                    model1.orderNum = dic1[@"num"];
                    model1.orderStatus = dic1[@"status"];
                    
                    [model.mallGoodsArray addObject:model1];
                }
                
                
                [strongSelf.orderListArray addObject:model];
            }
            
            
            [strongSelf.orderListTableView reloadData];
            
            if (arr.count > 0) {
                
            }else{
                
                [JKToast showWithText:@"没有更多了"];
            }
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HZDSShopMallModel *model = _orderListArray[section];
    
    return model.mallGoodsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    
    HZDSShopMallModel *model = _orderListArray[indexPath.section];
    
    HZDSOrderModel *model1 = model.mallGoodsArray[indexPath.row];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model1.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
    
    cell.titleLabel.text = model1.orderTitle;
    
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"原价:￥%@",model1.orderPrice];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"价格:￥%@",model1.orderNeedPayPrice];

    cell.priceLabel.textColor = [UIColor redColor];
    
    return cell;
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZDSShopMallModel *model = _orderListArray[indexPath.section];
    
    HZDSMallOrderDetailViewController *detail = [[HZDSMallOrderDetailViewController alloc] init];
    
    detail.order_Id = model.orderID;
    
    detail.order_Url = MALL_MANAGE_ORDERDETAIL;
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSShopMallModel *model = [[HZDSShopMallModel alloc] init];
    model = _orderListArray[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20)];
    shanghu.text = [NSString stringWithFormat:@"订单ID:%@",model.orderID];
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    shanghu.font=[UIFont systemFontOfSize:12];
    shanghu.adjustsFontSizeToFitWidth = YES;
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    [backView addSubview:view1];
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20)];
    dingdantime.text =[NSString stringWithFormat:@"交易时间:%@",[self ConvertStrToTime:model.orderTime]];
    
    dingdantime.textAlignment = NSTextAlignmentRight;
    dingdantime.font = [UIFont systemFontOfSize:12];
    // dingdantime.textColor = [UIColor colorWithHexString:@"f5f5f5"];
    // dingdantime.adjustsFontSizeToFitWidth = YES;
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
    model = _orderListArray[section];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,39,SCREEN_WIDTH,1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    [view addSubview:lineLabel];
    
    UILabel* zongjia = [[UILabel alloc]initWithFrame:CGRectMake(15, 13,100, 20)];
    zongjia.font=[UIFont systemFontOfSize:14];
    zongjia.textAlignment = NSTextAlignmentLeft;
    zongjia.textColor = [UIColor colorWithHexString:@"BEC2C9"];
    //  zongjia.text = [NSString stringWithFormat:@"共%ld件商品",(long)goodsNum];
    
    [view addSubview:zongjia];
    
    UILabel* price = [[UILabel alloc]initWithFrame:CGRectMake(120, 13,SCREEN_WIDTH - 120 -75 -5, 20)];
    [view addSubview:price];
    
    //  price.text =  [NSString stringWithFormat:@"合计 :￥%.2f",goodstotalPirce];
    price.tag = section;
    price.textColor = [UIColor colorWithHexString:@"#BEC2C9"];
    price.font=[UIFont systemFontOfSize:14];
    price.textAlignment = NSTextAlignmentLeft;
    // price.adjustsFontSizeToFitWidth = YES;
    
    
    //    UILabel* postLabel = [UILabel alloc]initWithFrame:CGRectMake(150, 5, <#CGFloat width#>, <#CGFloat height#>)
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(SCREEN_WIDTH-75-75, 8, 70, 25)];
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius = 3;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"#b5b5b5"];
    //  leftBtn.layer.borderWidth = 0.5;
    leftBtn.tag = section;
    [leftBtn addTarget:self action:@selector(tapleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"exitlogin.png"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor colorWithHexString:@"#b5b5b5"];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.tag = section;
    [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    
    view.backgroundColor=[UIColor whiteColor];
    
    
    if ([model.orderStatus isEqualToString:@"0"]) {
        
        [rightBtn setTitle:@"等待付款" forState:UIControlStateNormal];
        
    }else if ([model.orderStatus isEqualToString:@"1"]){
        
        
        if ([_orderStatus isEqualToString:@"1"]) {
          
            [rightBtn setTitle:@"等待发货" forState:UIControlStateNormal];

            
        }else if ([_orderStatus isEqualToString:@"2"]){
            
            [rightBtn setTitle:@"发货" forState:UIControlStateNormal];

            rightBtn.backgroundColor = [UIColor colorWithHexString:@"#ff9980"];

        }
        
        
    }else if ([model.orderStatus isEqualToString:@"2"]){
        
        [rightBtn setTitle:@"仓库已捡货" forState:UIControlStateNormal];
        
        
    }else if ([model.orderStatus isEqualToString:@"8"]){
        
            [rightBtn setTitle:@"已完成配送" forState:UIControlStateNormal];
 
    }else if ([model.orderStatus isEqualToString:@"4"]){
        
        [rightBtn setTitle:@"申请退款中" forState:UIControlStateNormal];
    
    }else if ([model.orderStatus isEqualToString:@"5"]){
        
        [rightBtn setTitle:@"已退款" forState:UIControlStateNormal];
        
    }
    
    if ([model.orderType isEqualToString:@"1"]) {
        
        [leftBtn setTitle:@"手机订单" forState:UIControlStateNormal];

    }else{
        
        [leftBtn setTitle:@"电脑订单" forState:UIControlStateNormal];

    }
    
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
    
}
-(void)tapleftBtn:(UIButton *)sender
{
    
  
}
-(void)tapBtn:(UIButton *)sender
{
    HZDSShopMallModel *model = _orderListArray[sender.tag];
    
    if ([sender.currentTitle isEqualToString:@"发货"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认发货?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"快递发货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self sendGoodsByExpress:model.orderID];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"无需物流发货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self sendGoodsNoExpress:model.orderID];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

    
}
//发货
-(void)sendGoodsByExpress:(NSString *)orderId
{
    HZDSSendByExpressViewController *express = [[HZDSSendByExpressViewController alloc] init];
    
    express.orderId = orderId;
    
    [self.navigationController pushViewController:express animated:YES];
}
//一键发货
-(void)sendGoodsNoExpress:(NSString *)orderId
{
    NSDictionary *dic = @{@"order_id":orderId};
    
    [CrazyNetWork CrazyRequest_Post:MALL_ORDER_NOEXPRESS parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"一键发货", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)moveLineLabel:(NSInteger)index
{
    
    switch (index) {
        case 0:
            _orderStatus = @"1";
            _orderUrl = MALL_MANAGE_ORDER;
            self.navigationItem.title = @"卖出订单";
            break;
        case 1:
            _orderStatus = @"2";
            _orderUrl = MALL_MANAGE_ORDER_PAY;
            self.navigationItem.title = @"付款订单";
            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.frame.origin.x,_lineLabel.frame.origin.y,SCREEN_WIDTH/2, _lineLabel.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        lineFrame.origin.x =  index* SCREEN_WIDTH/2;
        
        self->_lineLabel.frame = lineFrame;
    }];
    
    [self initData];
}
- (IBAction)changeNav:(UIButton *)sender {

    
    NSInteger num = sender.tag - 400;
    
    
    [self moveLineLabel:num];
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
