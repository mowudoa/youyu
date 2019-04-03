//
//  HZDScashHistoryViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDScashHistoryViewController.h"
#import "HZDScashHistoryTableViewCell.h"
#import "HZDScashHistoryModel.h"
@interface HZDScashHistoryViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *cahsHistoryTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *cashListArray;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDScashHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _cashListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    // 下拉加载
    self.cahsHistoryTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [self initData];
        
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.cahsHistoryTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
    }];
    
    self.navigationItem.title = @"提现日志";
    
   
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDScashHistoryTableViewCell" bundle:nil];
   
    [_cahsHistoryTableView registerNib:nib forCellReuseIdentifier:@"cashHistoryTableViewCell"];
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_logUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"提现列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.cashListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.cahsHistoryTableView.hidden = NO;
                
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.cahsHistoryTableView.hidden = YES;
                
                strongSelf.backGroundView.hidden = NO;
            }

            
            for (NSDictionary *dict1 in arr) {
                
                HZDScashHistoryModel *model = [[HZDScashHistoryModel alloc] init];
                
                model.cashID = dict1[@"cash_id"];
                
                if ([strongSelf.logUrl isEqualToString:MYBALANCE_CASHLIST]) {
                  
                    model.cashNum = dict1[@"money"];

                }else{
                    model.cashNum = [dict1[@"gold"] stringValue];

                }
                
                model.bankName = dict1[@"bank_name"];
                
                model.bankNum = dict1[@"bank_num"];
                
                model.userName = dict1[@"bank_realname"];
                
                model.cashStatus = dict1[@"status"];
     
                model.cashTime = dict1[@"addtime"];
                
                [strongSelf.cashListArray addObject:model];
            }
            
            [strongSelf.cahsHistoryTableView reloadData];
            
        }else{
            
            
        }
        
        [strongSelf.cahsHistoryTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)initMoreData
{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_logUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"提现列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            for (NSDictionary *dict1 in arr) {
                
                HZDScashHistoryModel *model = [[HZDScashHistoryModel alloc] init];
                
                model.cashID = dict1[@"cash_id"];
               
                model.cashNum = [dict1[@"gold"] stringValue];
                
                model.bankName = dict1[@"bank_name"];
                
                model.bankNum = dict1[@"bank_num"];
                
                model.userName = dict1[@"bank_realname"];
                
                model.cashStatus = dict1[@"status"];
                
                model.cashTime = dict1[@"addtime"];
                
                [strongSelf.cashListArray addObject:model];
            }
            
            [strongSelf.cahsHistoryTableView reloadData];
            
            [strongSelf.cahsHistoryTableView.mj_footer endRefreshing];

            if (arr.count > 0) {
                
            }else{
                
            [JKToast showWithText:NOMOREDATA_STRING];
                
            [strongSelf.cahsHistoryTableView.mj_footer endRefreshingWithNoMoreData];

            }
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}


#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cashListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDScashHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cashHistoryTableViewCell" forIndexPath:indexPath];
    
    HZDScashHistoryModel *model = _cashListArray[indexPath.section];
    
    cell.moneyNumlabel.text = [NSString stringWithFormat:@"提现金额:%@",model.cashNum];
    
    cell.bankNameLabel.text = [NSString stringWithFormat:@"提现银行:%@",model.bankName];
    
    cell.bankNumLabel.text = [NSString stringWithFormat:@"银行账户:%@",model.bankNum];
    
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"提现户名:%@",model.userName];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDScashHistoryModel *model = [[HZDScashHistoryModel alloc] init];
    
    model = _cashListArray[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
    
    [backView addSubview:view];
    
    UILabel *shanghu = [WYFTools createLabel:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20) bgColor:[UIColor clearColor] text:[NSString stringWithFormat:@"提现编号:%@",model.cashID] textFont:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft textColor:[UIColor blackColor] tag:section];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    
    [backView addSubview:view1];
    
    UILabel *dingdantime = [WYFTools createLabel:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20) bgColor:[UIColor clearColor] text:@"" textFont:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:[UIColor blackColor] tag:section];
    
    if (_myCashLogType == moneyCashLogType) {
       
        dingdantime.text = [NSString stringWithFormat:@"申请日期:%@",[WYFTools ConvertStrToTime:model.cashTime dateModel:@"yyyy-MM-dd HH:mm:ss" withDateMultiple:1]];

    }else if (_myCashLogType == integralCashLogType){
     
        dingdantime.text = [NSString stringWithFormat:@"申请日期:%@",model.cashTime];

    }

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
    
    HZDScashHistoryModel *model = [[HZDScashHistoryModel alloc] init];
    
    model = _cashListArray[section];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,39,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    
    [view addSubview:lineLabel];
    
 //   UIButton *leftBtn = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#c6c6c6"] title:@"" titleFont:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:nil vc:self];
    
 //   [WYFTools viewLayer:3 withView:leftBtn];
    
    UIButton *rightBtn = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#B5B5B5"] title:@"" titleFont:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:nil vc:self];

    [WYFTools viewLayer:3 withView:rightBtn];

    rightBtn.tag = section;

    [view addSubview:rightBtn];
    
    view.backgroundColor=[UIColor whiteColor];
    
    if ([model.cashStatus isEqualToString:@"0"]) {
        
        [rightBtn setTitle:@"未审" forState:UIControlStateNormal];
                
    }else if ([model.cashStatus isEqualToString:@"1"]){
     
        [rightBtn setTitle:@"已审" forState:UIControlStateNormal];

    }
    
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
