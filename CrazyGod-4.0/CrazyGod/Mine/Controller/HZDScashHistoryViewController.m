//
//  HZDScashHistoryViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/14.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDScashHistoryViewController.h"
#import "HZDScashHistoryModel.h"
#import "HZDScashHistoryTableViewCell.h"
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
        
        [self.cahsHistoryTableView.mj_footer endRefreshing];

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
    return 115;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDScashHistoryModel *model = [[HZDScashHistoryModel alloc] init];
    model = _cashListArray[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20)];
    shanghu.text = [NSString stringWithFormat:@"提现编号:%@",model.cashID];
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    shanghu.font=[UIFont systemFontOfSize:12];
    shanghu.adjustsFontSizeToFitWidth = YES;
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    [backView addSubview:view1];
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20)];
    dingdantime.text =[NSString stringWithFormat:@"申请日期:%@",[self ConvertStrToTime:model.cashTime]];
    
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
    
    HZDScashHistoryModel *model = [[HZDScashHistoryModel alloc] init];
    model = _cashListArray[section];
    
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
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"exitlogin.png"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor colorWithHexString:@"#b5b5b5"];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.tag = section;
 //   [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
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
