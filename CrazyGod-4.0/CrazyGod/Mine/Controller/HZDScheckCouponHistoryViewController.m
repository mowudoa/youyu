//
//  HZDScheckCouponHistoryViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDScheckCouponHistoryViewController.h"
#import "HZDSmerchantOrderTableViewCell.h"
#import "HZDScouponModel.h"
#import "HZDScheckCouponDetailViewController.h"

@interface HZDScheckCouponHistoryViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *couponHistoryTableView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *counponListArray;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDScheckCouponHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _counponListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    
    // 下拉加载
    self.couponHistoryTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.couponHistoryTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.couponHistoryTableView.mj_footer endRefreshing];

    }];
    
    self.navigationItem.title = @"验证记录";
    
   
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSmerchantOrderTableViewCell" bundle:nil];
    [_couponHistoryTableView registerNib:nib forCellReuseIdentifier:@"merchantOrderTableViewCell"];
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    
    [CrazyNetWork CrazyRequest_Post:_checkHistoryUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"消费券列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.counponListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.couponHistoryTableView.hidden = NO;
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.couponHistoryTableView.hidden = YES;
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDScouponModel *model = [[HZDScouponModel alloc] init];
                
                model.couponID = dict1[@"code_id"];
                model.couponImage = dict1[@"photo"];
                
                if (dict1[@"title"] == NULL || dict1[@"title"] == nil || dict1[@"title"] == [NSNull null]) {
                    
                    model.couponTite = @"";

                }else{
                    model.couponTite = dict1[@"title"];

                }
                
                model.couponNUm = dict1[@"code"];
                
                model.couponChecker = dict1[@"user_name"];
                
                model.couponTime = dict1[@"create_time"];
                
                model.orderTime = dict1[@"used_time"];
                
                [strongSelf.counponListArray addObject:model];
            }
            
            [strongSelf.couponHistoryTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.couponHistoryTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)initMoreData
{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_checkHistoryUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"验证记录列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            
            for (NSDictionary *dict1 in arr) {
                
                HZDScouponModel *model = [[HZDScouponModel alloc] init];
                
                model.couponID = dict1[@"code_id"];
                model.couponImage = dict1[@"photo"];

                if (dict1[@"title"] == NULL || dict1[@"title"] == nil || dict1[@"title"] == [NSNull null]) {
                    
                    model.couponTite = @"";
                    
                }else{
                    model.couponTite = dict1[@"title"];
                    
                }
                
                model.couponNUm = dict1[@"code"];
                
                model.couponTime = dict1[@"create_time"];
                
                model.orderTime = dict1[@"used_time"];
                
                [strongSelf.counponListArray addObject:model];
            }
            
            [strongSelf.couponHistoryTableView reloadData];
            
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
    return _counponListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSmerchantOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchantOrderTableViewCell" forIndexPath:indexPath];
    
    HZDScouponModel *model = _counponListArray[indexPath.section];
    
    [cell.orderIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.couponImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"名称:%@",model.couponTite];
    
    
    cell.numLabel.text = [NSString stringWithFormat:@"下单日期:%@",[self ConvertStrToTime:model.couponTime]];
    
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"验证码:%@",model.couponNUm];
    
    cell.oldPriceLabel.textColor = [UIColor colorWithHexString:@"#dcdcdc"];
    
    cell.numLabel.textColor = [UIColor colorWithHexString:@"#dcdcdc"];

    
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
    HZDScouponModel *model = _counponListArray[indexPath.section];

    HZDScheckCouponDetailViewController *detail = [[HZDScheckCouponDetailViewController alloc] init];

    if ([_checkHistoryUrl isEqualToString:MERCHANT_COUPON_CHECK_HISTORY]) {
       
        detail.detailUrl = MERCHANT_COUPON_CHECK_DETAIL;
        
    }else if ([_checkHistoryUrl isEqualToString:EMPLOYEE_COUPON_CHECK_HISTORY]){
        
        detail.detailUrl = EMPLOYEE_COUPON_CHECK_DETAIL;
    }
    
    
    detail.couponId = model.couponID;

    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDScouponModel *model = [[HZDScouponModel alloc] init];
    model = _counponListArray[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20)];
    shanghu.text = [NSString stringWithFormat:@"ID:%@",model.couponID];
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    shanghu.font=[UIFont systemFontOfSize:12];
    shanghu.adjustsFontSizeToFitWidth = YES;
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    [backView addSubview:view1];
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20)];
    dingdantime.text =[NSString stringWithFormat:@"验证日期:%@",[self ConvertStrToTime:model.orderTime]];
    
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
    
    HZDScouponModel *model = [[HZDScouponModel alloc] init];
    model = _counponListArray[section];
    
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
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"#c6c6c6"];
    //  leftBtn.layer.borderWidth = 0.5;
    leftBtn.tag = section;
    //  [leftBtn addTarget:self action:@selector(tapleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    //  [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:[NSString stringWithFormat:@"验证-%@",model.couponChecker] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor colorWithHexString:@"#b5b5b5"];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.tag = section;
    //   [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    
    view.backgroundColor=[UIColor whiteColor];
    
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
    
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
