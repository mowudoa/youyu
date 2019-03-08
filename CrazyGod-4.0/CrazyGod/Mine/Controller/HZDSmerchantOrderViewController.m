//
//  HZDSmerchantOrderViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/13.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmerchantOrderViewController.h"
#import "HZDmerchantOrderDetailSViewController.h"
#import "HZDSmerchantOrderTableViewCell.h"
#import "HZDSOrderModel.h"

@interface HZDSmerchantOrderViewController ()<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSString *couponStatus;
}

@property (weak, nonatomic) IBOutlet UITableView *merchantOrderListTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *orderListArray;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDSmerchantOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    _orderListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
    
}
- (IBAction)clickButotn:(UIButton *)sender {

    NSInteger num = sender.tag - 500;
    
    [self moveLineLabel:num];
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    couponStatus = @"0";
    
    // 下拉加载
    self.merchantOrderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self initData];
    
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.merchantOrderListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
    }];
    
    self.navigationItem.title = @"订单管理";
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,40,SCREEN_WIDTH/5,2)];
    
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"FF0270"];
   
    [self.view addSubview:_lineLabel];
    
    [WYFTools autuLayoutNewMJ:_merchantOrderListTableView];
    
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSmerchantOrderTableViewCell" bundle:nil];
   
    [_merchantOrderListTableView registerNib:nib forCellReuseIdentifier:@"merchantOrderTableViewCell"];
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"aready":couponStatus
                          };
    
    [CrazyNetWork CrazyRequest_Post:_OrderUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"订单列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.orderListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            
            if (arr.count > 0) {
            
            strongSelf.merchantOrderListTableView.hidden = NO;
                
            strongSelf.backGroundView.hidden = YES;
                
            }else{
                
            strongSelf.merchantOrderListTableView.hidden = YES;
               
            strongSelf.backGroundView.hidden = NO;
                
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
                
                model.orderID = dict1[@"order_id"];
               
                model.orderImage = dict1[@"photo"];
                
                model.orderTitle = dict1[@"title"];
                
                model.orderPrice = [dict1[@"total_price"] stringValue];
                
                model.orderNeedPayPrice = [dict1[@"need_pay"] stringValue];

                model.orderStatus = dict1[@"status"];
                
                model.orderNum = dict1[@"num"];
  
                model.orderType = dict1[@"is_mobile"];
                
                model.orderTime = dict1[@"create_time"];
                
                [strongSelf.orderListArray addObject:model];
            }
            
            [strongSelf.merchantOrderListTableView reloadData];
            
        }else{
            
            
        }
        
        [strongSelf.merchantOrderListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)initMoreData
{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"aready":couponStatus
                          };
    
    [CrazyNetWork CrazyRequest_Post:_OrderUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
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
                
                model.orderNeedPayPrice = [dict1[@"need_pay"] stringValue];
                
                model.orderType = dict1[@"is_mobile"];

                model.orderStatus = dict1[@"status"];
                
                model.orderNum = dict1[@"num"];
                
                model.orderTime = dict1[@"create_time"];
                
                [strongSelf.orderListArray addObject:model];
            }
            
        [strongSelf.merchantOrderListTableView reloadData];
            
        [strongSelf.merchantOrderListTableView.mj_footer endRefreshing];

        if (arr.count > 0) {
                
        }else{
                
        [JKToast showWithText:NOMOREDATA_STRING];
                
        [strongSelf.merchantOrderListTableView.mj_footer endRefreshingWithNoMoreData];

        }
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
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
            couponStatus = @"3";
            break;
        case 3:
            couponStatus = @"4";
            break;
        case 4:
            couponStatus = @"8";
            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.mj_x,_lineLabel.mj_y,SCREEN_WIDTH/5, _lineLabel.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        lineFrame.origin.x = index* SCREEN_WIDTH /5;
        
        self->_lineLabel.frame = lineFrame;
    }];
    
    [self initData];
}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSmerchantOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchantOrderTableViewCell" forIndexPath:indexPath];
    
    HZDSOrderModel *model = _orderListArray[indexPath.section];
    
    [cell.orderIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
    
    cell.titleLabel.text = model.orderTitle;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"实付金额:%@",model.orderNeedPayPrice];

    cell.numLabel.text = [NSString stringWithFormat:@"数量:%@",model.orderNum];

    cell.oldPriceLabel.text = [NSString stringWithFormat:@"订单金额:%@",model.orderPrice];
    
    
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
    HZDSOrderModel *model = _orderListArray[indexPath.section];
    
    HZDmerchantOrderDetailSViewController *detail = [[HZDmerchantOrderDetailSViewController alloc] init];

    detail.orderId = model.orderID;

    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
   
    model = _orderListArray[section];
    
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
    
    model = _orderListArray[section];
    
    
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
    
    [WYFTools viewLayer:3 withView:leftBtn];
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"#c6c6c6"];

    leftBtn.tag = section;

    [leftBtn addTarget:self action:@selector(tapleftBtn:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];

    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    [rightBtn setTitle:@"" forState:UIControlStateNormal];

    rightBtn.backgroundColor = [UIColor colorWithHexString:@"46a0fc"];

    [WYFTools viewLayer:3 withView:rightBtn];

    rightBtn.tag = section;

    [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:rightBtn];
    
    view.backgroundColor=[UIColor whiteColor];
    
    if ([model.orderStatus isEqualToString:@"0"]) {
        
        [leftBtn setTitle:@"未付款" forState:UIControlStateNormal];
        
    }else if ([model.orderStatus isEqualToString:@"1"]){
        
        [leftBtn setTitle:@"已付款" forState:UIControlStateNormal];
        
    }else if ([model.orderStatus isEqualToString:@"3"]){
        
        [leftBtn setTitle:@"退款中" forState:UIControlStateNormal];
        
    }else if ([model.orderStatus isEqualToString:@"4"]){
        
        [leftBtn setTitle:@"已退款" forState:UIControlStateNormal];
        
    }else if ([model.orderStatus isEqualToString:@"8"]){
        
        [leftBtn setTitle:@"已完成" forState:UIControlStateNormal];
        
    }
    
    if ([model.orderType isEqualToString:@"1"]) {
        
        [rightBtn setTitle:@"手机订单" forState:UIControlStateNormal];

    }else{
     
        [rightBtn setTitle:@"电脑订单" forState:UIControlStateNormal];

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
