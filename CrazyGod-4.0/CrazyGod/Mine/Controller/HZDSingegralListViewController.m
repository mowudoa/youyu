//
//  HZDSingegralListViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSingegralListViewController.h"
#import "HZDSintegralListTableViewCell.h"
#import "HZDSOrderModel.h"

@interface HZDSingegralListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *integralListTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *integralArray;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;
@end

@implementation HZDSingegralListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _integralArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    // 下拉加载
    self.integralListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [self initData];
    
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.integralListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
    }];
    
    if (_myLogType == moneyLogType) {
       
        self.navigationItem.title = @"资金日志";

    }else{
    
        self.navigationItem.title = @"积分日志";

    }
    
    
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSintegralListTableViewCell" bundle:nil];
   
    [_integralListTableView registerNib:nib forCellReuseIdentifier:@"integralListTableViewCell"];
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_logUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"积分日志列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.integralArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.integralListTableView.hidden = NO;
               
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.integralListTableView.hidden = YES;
                
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
                
                model.orderID = dict1[@"money_id"];
                
                model.orderTitle = dict1[@"type"];
                if (strongSelf.myLogType == moneyLogType) {
                    
                    model.orderPrice = dict1[@"money"];
                    
                }else if (strongSelf.myLogType == integralLogType){
                    
                    model.orderPrice = [dict1[@"money"] stringValue];
                    
                }
                model.orderStatus = dict1[@"intro"];
                
                model.orderTime = dict1[@"create_time"];
                
                [strongSelf.integralArray addObject:model];
            }
            
            [strongSelf.integralListTableView reloadData];
            
        }else{
            
        }
        
        [strongSelf.integralListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)initMoreData
{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_logUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"积分日志列表", dic);

        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
                
                model.orderID = dict1[@"money_id"];
              
                model.orderTitle = dict1[@"type"];
                
                model.orderStatus = dict1[@"intro"];
                
                if (strongSelf.myLogType == moneyLogType) {
                    
                    model.orderPrice = dict1[@"money"];
                    
                }else if (strongSelf.myLogType == integralLogType){
                    
                    model.orderPrice = [dict1[@"money"] stringValue];

                }
                
                model.orderTime = dict1[@"create_time"];
                
                [strongSelf.integralArray addObject:model];

            }
            
            [strongSelf.integralListTableView reloadData];
            
            [strongSelf.integralListTableView.mj_footer endRefreshing];

            if (arr.count > 0) {
                
            }else{
                
            [JKToast showWithText:NOMOREDATA_STRING];
                
            [strongSelf.integralListTableView.mj_footer endRefreshingWithNoMoreData];

            }
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}

#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _integralArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSintegralListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"integralListTableViewCell" forIndexPath:indexPath];
    
    HZDSOrderModel *model = _integralArray[indexPath.section];
    
    if (_myLogType == moneyLogType) {
     
        cell.integralNum.text = [NSString stringWithFormat:@"资金:%@",model.orderPrice];
        
    }else{
        
        
        cell.integralNum.text = [NSString stringWithFormat:@"积分:%@",model.orderPrice];
        
    }
  
    cell.integralType.text = [NSString stringWithFormat:@"类型:%@",model.orderTitle];
    
    cell.ingegralInfo.text = [NSString stringWithFormat:@"结算说明:%@",model.orderStatus];
    
    cell.integralTime.text = [NSString stringWithFormat:@"日期:%@",[self ConvertStrToTime:model.orderTime]];
    
    
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

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
    
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
