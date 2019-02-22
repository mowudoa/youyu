//
//  HZDSmyCouponViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmyCouponViewController.h"
#import "HZDScouponDetailViewController.h"
#import "HZDSMyCouponTableViewCell.h"
#import "HZDScouponModel.h"

@interface HZDSmyCouponViewController ()<
UITableViewDelegate,
UITableViewDataSource,
couponBtnDelagate
>
{
    
    NSString *couponStatus;
}
@property(nonatomic,strong) UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *couponListTableView;

@property(nonatomic,strong) NSMutableArray *couponListDataSource;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;
@end

@implementation HZDSmyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _couponListDataSource = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
    
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    couponStatus = @"3";
    
    // 下拉加载
    self.couponListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.couponListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.couponListTableView.mj_footer endRefreshing];

    }];
    
    self.navigationItem.title = @"消费券";
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,45,SCREEN_WIDTH/3,2)];
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"FF0270"];
    [self.view addSubview:_lineLabel];
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;

    _pageNum = 1;

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if ([couponStatus isEqualToString:@"3"]) {
        
        
    }else{
        
        [dic addEntriesFromDictionary:@{@"aready":couponStatus}];
    }
    
    [dic addEntriesFromDictionary:@{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]}];
    
    [CrazyNetWork CrazyRequest_Post:MY_COUPON parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"消费券列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.couponListDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
               
                strongSelf.couponListTableView.hidden = NO;
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.couponListTableView.hidden = YES;
                strongSelf.backGroundView.hidden = NO;
            }
            
            
            for (NSDictionary *dict1 in arr) {
                
                HZDScouponModel *model = [[HZDScouponModel alloc] init];
                
                model.couponID = dict1[@"code_id"];
                model.couponNUm = dict1[@"code"];

                if (dict1[@"title"] == NULL || dict1[@"title"] == nil || dict1[@"title"] == [NSNull null]) {
                    
                    model.couponTite = @"";
                    
                }else{
                    model.couponTite = dict1[@"title"];
                    
                }
                if (dict1[@"shop_name"] == NULL || dict1[@"shop_name"] == nil || dict1[@"shop_name"] == [NSNull null]) {
                    
                    model.couponShop = @"";
                    
                }else{
                    model.couponShop = dict1[@"shop_name"];
                    
                }
                
                model.couponOrderCode = dict1[@"order_id"];
                model.couponTime = dict1[@"create_time"];
                
                model.couponStatus = dict1[@"is_used"];
                
                [strongSelf.couponListDataSource addObject:model];
                
            }
            
            [strongSelf.couponListTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.couponListTableView.mj_header endRefreshing];

    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
-(void)initMoreData
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if ([couponStatus isEqualToString:@"3"]) {
        
        
    }else{
        
        [dic addEntriesFromDictionary:@{@"aready":couponStatus}];
    }
    
    [dic addEntriesFromDictionary:@{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]}];
    
    
    [CrazyNetWork CrazyRequest_Post:MY_COUPON parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"消费券列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            for (NSDictionary *dict1 in arr) {
                
                HZDScouponModel *model = [[HZDScouponModel alloc] init];
                
                model.couponID = dict1[@"code_id"];
                model.couponNUm = dict1[@"code"];

                if (dict1[@"title"] == NULL || dict1[@"title"] == nil || dict1[@"title"] == [NSNull null]) {
                    
                    model.couponTite = @"";
                    
                }else{
                    model.couponTite = dict1[@"title"];
                    
                }
                if (dict1[@"shop_name"] == NULL || dict1[@"shop_name"] == nil || dict1[@"shop_name"] == [NSNull null]) {
                    
                    model.couponShop = @"";
                    
                }else{
                    model.couponShop = dict1[@"shop_name"];

                }
                model.couponOrderCode = dict1[@"order_id"];
                model.couponTime = dict1[@"create_time"];
                
                model.couponStatus = dict1[@"is_used"];
                
                [strongSelf.couponListDataSource addObject:model];
                
            }
            
            [strongSelf.couponListTableView reloadData];
            
            if (arr.count > 0) {
                
            }else{
                
                [JKToast showWithText:@"没有更多了"];
            }
        }else{
            
            
        }

    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSMyCouponTableViewCell" bundle:nil];
    [_couponListTableView registerNib:nib forCellReuseIdentifier:@"CouponTableViewCell"];
}
-(void)moveLineLabel:(NSInteger)index
{
    
    switch (index) {
        case 0:
            couponStatus = @"3";
            break;
        case 1:
            couponStatus = @"1";
            break;
        case 2:
            couponStatus = @"2";
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

- (IBAction)couponStaus:(UIButton *)sender {

    
    NSInteger num = sender.tag - 300;
    
    
    [self moveLineLabel:num];
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponListDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSMyCouponTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell" forIndexPath:indexPath];
    
    
    cell.delegate = self;
    
    [cell setCouponModel:_couponListDataSource[indexPath.row]];
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)couponSleected:(NSString *)couponStatus withcouponID:(NSString *)couponId
{
    if ([couponStatus isEqualToString:@"0"]) {
        
        HZDScouponDetailViewController *detail = [[HZDScouponDetailViewController alloc] init];
        
        detail.couponId = couponId;
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([couponStatus isEqualToString:@"1"]){
        
        [JKToast showWithText:@"消费码已使用!"];
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
