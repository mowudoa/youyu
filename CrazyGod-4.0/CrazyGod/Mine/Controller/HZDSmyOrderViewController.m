//
//  HZDSmyOrderViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmyOrderViewController.h"
#import "HZDSOrderDetailViewController.h"
#import "HZDSRushEvaluateViewController.h"
#import "HZDSOrderTableViewCell.h"
#import "HZDSPayViewController.h"
#import "HZDSOrderModel.h"

@interface HZDSmyOrderViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
{
    
    NSString *couponStatus;
}
@property (weak, nonatomic) IBOutlet UITableView *myOrderListTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,strong) NSMutableArray *orderListDataSource;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDSmyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _orderListDataSource = [[NSMutableArray alloc] init];

    [self initUI];

    [self registercell];
    
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    couponStatus = @"0";
    
    // 下拉加载
    self.myOrderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.myOrderListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.myOrderListTableView.mj_footer endRefreshing];

    }];
    
    self.navigationItem.title = @"我的订单";
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,40,SCREEN_WIDTH/3,2)];
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"FF0270"];
    [self.view addSubview:_lineLabel];
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSOrderTableViewCell" bundle:nil];
    [_myOrderListTableView registerNib:nib forCellReuseIdentifier:@"OrderTableViewCell"];
}
-(void)initData
{

    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"aready":couponStatus
                          };
    
    
    
    [CrazyNetWork CrazyRequest_Post:MY_ORDER parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.orderListDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.myOrderListTableView.hidden = NO;
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.myOrderListTableView.hidden = YES;
                strongSelf.backGroundView.hidden = NO;
            }
            
            
            for (NSDictionary *dict1 in arr) {
              
                HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
                
                model.orderID = dict1[@"order_id"];
                model.orderImage = dict1[@"photo"];
                model.orderTitle = dict1[@"title"];
                model.orderPrice = [dict1[@"total_price"] stringValue];
                model.orderStatus = dict1[@"status"];

                model.orderType = dict1[@"is_dianping"];
                
                model.orderTime = dict1[@"create_time"];
                
                [strongSelf.orderListDataSource addObject:model];
            }
            
            [strongSelf.myOrderListTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.myOrderListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
-(void)initMoreData
{
 
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"aready":couponStatus
                          };
    
    [CrazyNetWork CrazyRequest_Post:MY_ORDER parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
                
                model.orderID = dict1[@"order_id"];
                model.orderImage = dict1[@"photo"];
                model.orderTitle = dict1[@"title"];
                model.orderPrice = [dict1[@"total_price"] stringValue];
                model.orderStatus = dict1[@"status"];
                
                model.orderType = dict1[@"is_dianping"];

                model.orderTime = dict1[@"create_time"];

                [strongSelf.orderListDataSource addObject:model];
            }
            
            [strongSelf.myOrderListTableView reloadData];
            
            if (arr.count > 0) {
                
            }else{
                
                [JKToast showWithText:@"没有更多了"];
            }
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
- (IBAction)orderStatus:(UIButton *)sender {

    NSInteger num = sender.tag - 400;
    
    
    [self moveLineLabel:num];
}
-(void)moveLineLabel:(NSInteger)index
{
    
    switch (index) {
        case 0:
            couponStatus = @"0";
            break;
        case 1:
            couponStatus = @"1";
            break;
        case 2:
            couponStatus = @"8";
            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.frame.origin.x,_lineLabel.frame.origin.y,SCREEN_WIDTH/3, _lineLabel.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        lineFrame.origin.x = index* SCREEN_WIDTH /3;
        
        self->_lineLabel.frame = lineFrame;
    }];
    
    [self initData];
}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderListDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    
    HZDSOrderModel *model = _orderListDataSource[indexPath.section];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
    
    cell.titleLabel.text = model.orderTitle;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"价格:%@",model.orderPrice];
    
    return cell;
}
-(NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       HZDSOrderModel *model = _orderListDataSource[indexPath.section];
    
    HZDSOrderDetailViewController *detail = [[HZDSOrderDetailViewController alloc] init];
    
    detail.orderId = model.orderID;
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(143);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
    model = _orderListDataSource[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
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
    
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20)];
    
    dingdantime.text =[NSString stringWithFormat:@"下单时间:%@",model.orderTime];
    
    dingdantime.textAlignment = NSTextAlignmentRight;
    
    dingdantime.font = [UIFont systemFontOfSize:12];

    [view1 addSubview:dingdantime];
    
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
    
    model = _orderListDataSource[section];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,39,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [view addSubview:lineLabel];
    
    UILabel* zongjia = [[UILabel alloc]initWithFrame:CGRectMake(15, 13,100, 20)];
    
    zongjia.font=[UIFont systemFontOfSize:14];
    
    zongjia.textAlignment = NSTextAlignmentLeft;
    
    zongjia.textColor = [UIColor colorWithHexString:@"BEC2C9"];
    
    [view addSubview:zongjia];
    
    UILabel* price = [[UILabel alloc]initWithFrame:CGRectMake(120, 13,SCREEN_WIDTH - 120 -75 -5, 20)];
    
    [view addSubview:price];
    
    price.tag = section;
    
    price.textColor = [UIColor colorWithHexString:@"#BEC2C9"];
    
    price.font=[UIFont systemFontOfSize:14];
    
    price.textAlignment = NSTextAlignmentLeft;
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBtn setFrame:CGRectMake(SCREEN_WIDTH-75-75, 8, 70, 25)];
    
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    
    leftBtn.layer.cornerRadius = 3;
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    leftBtn.layer.masksToBounds = YES;
    
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"#ff9980"];
    
    leftBtn.tag = section;
    
    [leftBtn addTarget:self action:@selector(tapleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [rightBtn setTitle:@"" forState:UIControlStateNormal];

    rightBtn.backgroundColor = [UIColor colorWithHexString:@"#b5b5b5"];

    rightBtn.layer.cornerRadius = 3;

    rightBtn.layer.masksToBounds = YES;

    rightBtn.tag = section;

    [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:rightBtn];
    
    view.backgroundColor=[UIColor whiteColor];
    
    if ([model.orderStatus isEqualToString:@"0"]) {
        
        [rightBtn setTitle:@"付款" forState:UIControlStateNormal];
       
        rightBtn.userInteractionEnabled = YES;
        
        rightBtn.backgroundColor = [UIColor colorWithHexString:@"#ff9980"];

        rightBtn.hidden = NO;
        
        [leftBtn setTitle:@"取消抢购" forState:UIControlStateNormal];
        
        leftBtn.userInteractionEnabled = YES;
        
        leftBtn.hidden = NO;
        
    }else if ([model.orderStatus isEqualToString:@"1"]){
        
        [rightBtn setTitle:@"已付款" forState:UIControlStateNormal];
       
        rightBtn.userInteractionEnabled = NO;
        
        rightBtn.hidden = NO;
        
        leftBtn.hidden = YES;

    }else if ([model.orderStatus isEqualToString:@"8"]){
     
        [rightBtn setTitle:@"已完成" forState:UIControlStateNormal];
        
        rightBtn.userInteractionEnabled = NO;
        
        rightBtn.hidden = NO;
        
        if ([model.orderType isEqualToString:@"0"]) {
           
            [leftBtn setTitle:@"点评" forState:UIControlStateNormal];

        }else if ([model.orderType isEqualToString:@"1"]){
            
            
            [leftBtn setTitle:@"已评价" forState:UIControlStateNormal];
            
            leftBtn.backgroundColor = [UIColor colorWithHexString:@"#b5b5b5"];
        }
    }
    
    
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
    
}
-(void)tapleftBtn:(UIButton *)sender
{
    
    HZDSOrderModel *model = _orderListDataSource[sender.tag];
    
    if ([sender.currentTitle isEqualToString:@"取消抢购"]) {
    
        NSDictionary *dic = @{@"order_id":model.orderID};
        
        [CrazyNetWork CrazyRequest_Post:MY_ORDER_DELETE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"取消抢购", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self initData];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
    }else if ([sender.currentTitle isEqualToString:@"点评"]){
        
        HZDSRushEvaluateViewController *evaluate = [[HZDSRushEvaluateViewController alloc] init];
        
        evaluate.order_id = model.orderID;
        
        [self.navigationController pushViewController:evaluate animated:YES];
        
    }
    
    
   
}
-(void)tapBtn:(UIButton *)sender
{

     HZDSOrderModel *model = _orderListDataSource[sender.tag];
    
    if ([sender.currentTitle isEqualToString:@"付款"]) {
       
        HZDSPayViewController *pay = [[HZDSPayViewController alloc] init];
        
        pay.orderId = model.orderID;
        
        [self.navigationController pushViewController:pay animated:YES];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];
    
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
