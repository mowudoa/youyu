//
//  HZDSLogListViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/15.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSLogListViewController.h"
#import "HZDSLogListTableViewCell.h"
#import "HZDSLogListModel.h"

@interface HZDSLogListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *logListTableView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *logListArray;

@property(nonatomic,assign) NSInteger pageNum;

@end

@implementation HZDSLogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
    

}
-(void)initUI
{
    _logListArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"余额日志";
    
    // 下拉加载
    self.logListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.logListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.logListTableView.mj_footer endRefreshing];

    }];
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSLogListTableViewCell" bundle:nil];
    [_logListTableView registerNib:nib forCellReuseIdentifier:@"LogListTableViewCell"];
    
    
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    
    [CrazyNetWork CrazyRequest_Post:MYBALANCE_LOGLIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"余额日志列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.logListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.logListTableView.hidden = NO;
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.logListTableView.hidden = YES;
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSLogListModel *model = [[HZDSLogListModel alloc] init];
                
                model.money = [dict1[@"money"] stringValue];
                model.intro = dict1[@"intro"];
                
                model.time = dict1[@"create_time"];
                
                [strongSelf.logListArray addObject:model];
            }
            
            [strongSelf.logListTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.logListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)initMoreData
{
 
    
    __weak typeof(self) weakSelf = self;
    
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:MYBALANCE_LOGLIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"余额日志列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSLogListModel *model = [[HZDSLogListModel alloc] init];
                
                model.money = [dict1[@"money"] stringValue];
                model.intro = dict1[@"intro"];
                
                model.time = dict1[@"create_time"];
                
                [strongSelf.logListArray addObject:model];
            }
            
            [strongSelf.logListTableView reloadData];
            
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _logListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSLogListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LogListTableViewCell" forIndexPath:indexPath];
    
    HZDSLogListModel *model = _logListArray[indexPath.row];
    
    
    cell.logMoneyInfo.text = [NSString stringWithFormat:@"金额:￥%@元, %@",model.money,model.intro];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"时间:%@",[self ConvertStrToTime:model.time]];
    
    
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
    
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(80);
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
