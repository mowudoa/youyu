//
//  HZDSMyProfitListViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/16.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMyProfitListViewController.h"
#import "HZDSProfitTableViewCell.h"
#import "HZDSLogListModel.h"
@interface HZDSMyProfitListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *profitListTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *profitListArray;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,copy) NSString *profitTypeString;

@property(nonatomic,assign) NSInteger pageNum;

@end

@implementation HZDSMyProfitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _profitListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
}
-(void)initUI
{
    self.navigationItem.title = @"收益统计";
    
    _pageNum = 1;
    
    // 下拉加载
    self.profitListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self initData];
        
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.profitListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
    }];
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,40,SCREEN_WIDTH/2,2)];
    
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"FF0270"];
    
    [self.view addSubview:_lineLabel];
    
    [WYFTools autuLayoutNewMJ:_profitListTableView];
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSProfitTableViewCell" bundle:nil];
   
    [_profitListTableView registerNib:nib forCellReuseIdentifier:@"ProfitTableViewCell"];
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"status":_profitTypeString
                          };
    
    
    [CrazyNetWork CrazyRequest_Post:MYPROFITLIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"奖励列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.profitListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
            strongSelf.profitListTableView.hidden = NO;
                
            strongSelf.backGroundView.hidden = YES;
                
            }else{
                
            strongSelf.profitListTableView.hidden = YES;
                
            strongSelf.backGroundView.hidden = NO;
            
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSLogListModel *model = [[HZDSLogListModel alloc] init];
                
                double money = [dict1[@"money"] doubleValue]/100;
                
                model.money = [NSString stringWithFormat:@"%.2f",money];
                
                model.listId = dict1[@"log_id"];
                
                model.time = dict1[@"create_time"];
                
                model.listId2 = dict1[@"order_id"];
                
                model.status = dict1[@"order_type"];
                
                
                [strongSelf.profitListArray addObject:model];
            }
            
            [strongSelf.profitListTableView reloadData];
            
        }else{
            
            
        }
        
        [strongSelf.profitListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)initMoreData
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"status":_profitTypeString
                          };
    
    
    [CrazyNetWork CrazyRequest_Post:MYPROFITLIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"奖励列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];

            
            for (NSDictionary *dict1 in arr) {
                
                HZDSLogListModel *model = [[HZDSLogListModel alloc] init];
                
                double money = [dict1[@"money"] doubleValue]/100;
                
                model.money = [NSString stringWithFormat:@"%.2f",money];
                
                model.listId = dict1[@"log_id"];
                
                model.time = dict1[@"create_time"];
                
                model.listId2 = dict1[@"order_id"];
                
                model.status = dict1[@"order_type"];
                
                
                [strongSelf.profitListArray addObject:model];
            }
            
            [strongSelf.profitListTableView reloadData];
            
            [strongSelf.profitListTableView.mj_footer endRefreshing];

            if (arr.count > 0) {
                
            }else{
                
                [JKToast showWithText:NOMOREDATA_STRING];
                
                [strongSelf.profitListTableView.mj_footer endRefreshingWithNoMoreData];

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
            _profitTypeString = @"1";
            
            break;
        case 1:
            _profitTypeString = @"2";
            
            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.mj_x,_lineLabel.mj_y,SCREEN_WIDTH/2, _lineLabel.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        lineFrame.origin.x =  index* SCREEN_WIDTH/2;
        
        self->_lineLabel.frame = lineFrame;
    }];
    
    [self initData];
}
-(void)initnavBtn
{
    
    NSInteger num = 0;
    
    switch (_profitType) {
        case MyProfitTypeOk:
            num = 0;
            break;
        case MyProfitTypeCancle:
            num = 1;
            break;
        default:
            break;
    }
    
    [self moveLineLabel:num];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initnavBtn];
}

#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _profitListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSProfitTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfitTableViewCell" forIndexPath:indexPath];
    
    HZDSLogListModel *model = _profitListArray[indexPath.section];
    
    NSString *profitTypeStr;
    
    if ([model.status isEqualToString:@"0"]) {
        
        profitTypeStr = @"抢购";
   
    }else if ([model.status isEqualToString:@"1"]){
       
        profitTypeStr = @"商城";

    }else if ([model.status isEqualToString:@"2"]){
       
        profitTypeStr = @"优惠买单";

    }
    
    
    cell.profitType.text = [NSString stringWithFormat:@"奖励类型:%@",profitTypeStr];
    
    cell.profitInfo.text = [NSString stringWithFormat:@"收益金额:￥%@元  订单ID:%@",model.money,model.listId2];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(60);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSLogListModel *model = [[HZDSLogListModel alloc] init];
    model = _profitListArray[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
   
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
   
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20)];
    
    shanghu.text = [NSString stringWithFormat:@"编号:%@",model.listId];
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    
    shanghu.font=[UIFont systemFontOfSize:13];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    
    [backView addSubview:view1];
   
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20)];
    
    dingdantime.text =[NSString stringWithFormat:@"分成时间:%@",model.time];
    
    dingdantime.textAlignment = NSTextAlignmentRight;
    
    dingdantime.font = [UIFont systemFontOfSize:13];

    [view1 addSubview:dingdantime];
    
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
    
}
- (IBAction)buttonClick:(UIButton *)sender {

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
