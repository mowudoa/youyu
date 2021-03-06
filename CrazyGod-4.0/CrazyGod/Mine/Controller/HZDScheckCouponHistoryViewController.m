//
//  HZDScheckCouponHistoryViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDScheckCouponHistoryViewController.h"
#import "HZDScheckCouponDetailViewController.h"
#import "HZDSmerchantOrderTableViewCell.h"
#import "HZDScouponModel.h"

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
                
                if ([strongSelf.checkHistoryUrl isEqualToString:MERCHANT_COUPON_CHECK_HISTORY]) {
                    
                    model.couponChecker = dict1[@"user_name"];

                }else{
                    
                    model.couponChecker = dict1[@"worker_name"];

                }
                
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
                
                if ([strongSelf.checkHistoryUrl isEqualToString:MERCHANT_COUPON_CHECK_HISTORY]) {
                    
                    model.couponChecker = dict1[@"user_name"];
                    
                }else{
                    
                    model.couponChecker = dict1[@"worker_name"];
                    
                }
                
                model.couponTime = dict1[@"create_time"];
                
                model.orderTime = dict1[@"used_time"];
                
                [strongSelf.counponListArray addObject:model];
            }
            
            [strongSelf.couponHistoryTableView reloadData];
            
            [strongSelf.couponHistoryTableView.mj_footer endRefreshing];

            if (arr.count > 0) {
                
            }else{
                
            [JKToast showWithText:NOMOREDATA_STRING];
                
            [strongSelf.couponHistoryTableView.mj_footer endRefreshingWithNoMoreData];
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
    
    cell.numLabel.text = [NSString stringWithFormat:@"下单日期:%@",[WYFTools ConvertStrToTime:model.couponTime dateModel:@"yyyy-MM-dd HH:mm:ss" withDateMultiple:1]];
    
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"验证码:%@",model.couponNUm];
    
    cell.oldPriceLabel.textColor = [UIColor colorWithHexString:@"#DCDCDC"];
    
    cell.numLabel.textColor = [UIColor colorWithHexString:@"#DCDCDC"];

    
    return cell;
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
   
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
   
    [backView addSubview:view];
    
    UILabel *shanghu = [WYFTools createLabel:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20) bgColor:[UIColor clearColor] text:[NSString stringWithFormat:@"ID:%@",model.couponID] textFont:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft textColor:[UIColor blackColor] tag:section];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    
    [backView addSubview:view1];

    UILabel *dingdantime = [WYFTools createLabel:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20) bgColor:[UIColor clearColor] text:[NSString stringWithFormat:@"验证日期:%@",[WYFTools ConvertStrToTime:model.orderTime dateModel:@"yyyy-MM-dd HH:mm:ss" withDateMultiple:1]] textFont:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:[UIColor blackColor] tag:section];
    
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
   
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    
    [view addSubview:lineLabel];
    

    UIButton *rightBtn = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#B5B5B5"] title:[NSString stringWithFormat:@"验证-%@",model.couponChecker] titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:nil vc:self];
    
    [WYFTools viewLayer:3 withView:rightBtn];

    [view addSubview:rightBtn];
    
    CGSize size = [rightBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, rightBtn.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : rightBtn.titleLabel.font} context:nil].size;
    
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - size.width, rightBtn.mj_y,size.width + 10, rightBtn.height);
    
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
