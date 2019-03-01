//
//  HZDSEmployeeViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSEmployeeViewController.h"
#import "HZDSaddEmployeeViewController.h"
#import "HZDSemployeeListTableViewCell.h"
#import "HZDSemployeeListModel.h"

@interface HZDSEmployeeViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@property(nonatomic,strong) NSMutableArray *employeeDataSource;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;
@end

@implementation HZDSEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _employeeDataSource = [[NSMutableArray alloc] init];
    
    [self registercell];
    
    [self initUI];
   
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    // 下拉加载
    self.enmloyeeListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self initData];
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.enmloyeeListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.enmloyeeListTableView.mj_footer endRefreshing];

    }];
    
    self.navigationItem.title = @"员工设置";
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
}
-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setFrame:CGRectMake(0, 0, 30, 30)];
        
        [btn setTitle:@"添加" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}
-(void)rightAction:(UIButton *)sender
{
    HZDSaddEmployeeViewController *add = [[HZDSaddEmployeeViewController alloc] init];
    
    add.addUrl = EMPLOYEE_ADD;
    
    add.employeeType = addType;
    
    [self.navigationController pushViewController:add animated:YES];
    
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;

    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]
                          };
    
    [CrazyNetWork CrazyRequest_Post:EMPLOYEE_LIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"员工列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.employeeDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
             
                strongSelf.enmloyeeListTableView.hidden = NO;
                
                strongSelf.backGroundView.hidden = YES;
            }else{
                
                strongSelf.enmloyeeListTableView.hidden = YES;
                
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSemployeeListModel *model = [[HZDSemployeeListModel alloc] init];
                
                model.employeeID = dict1[@"worker_id"];
                
                model.employeeName = dict1[@"name"];
                
                model.employeeQQ = dict1[@"qq"];
                
                model.employeeWchat = dict1[@"weixin"];
                
                model.employeeJob = dict1[@"work"];
                
                model.userID = dict1[@"user_id"];

                model.employeeTel  =dict1[@"tel"];
                
                model.employeeAddress = dict1[@"addr"];
                
                model.employeePhone  =dict1[@"mobile"];

                model.employeePower = dict1[@"tuan"];
                
                model.createTime = dict1[@"last_time"];
                
                [strongSelf.employeeDataSource addObject:model];
                
            }
            
            [strongSelf.enmloyeeListTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.enmloyeeListTableView.mj_header endRefreshing];

    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
}
-(void)initMoreData
{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]
                          };
    
    [CrazyNetWork CrazyRequest_Post:EMPLOYEE_LIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"员工列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
                
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSemployeeListModel *model = [[HZDSemployeeListModel alloc] init];
                
                model.employeeID = dict1[@"worker_id"];
                
                model.employeeName = dict1[@"name"];
                
                model.employeeQQ = dict1[@"qq"];
                
                model.employeeWchat = dict1[@"weixin"];
                
                model.employeeJob = dict1[@"work"];
                
                model.userID = dict1[@"user_id"];

                model.employeeTel  =dict1[@"tel"];
                
                model.employeeAddress = dict1[@"addr"];
                
                model.employeePhone  =dict1[@"mobile"];
                
                model.employeePower = dict1[@"tuan"];

                model.createTime = dict1[@"last_time"];
                
                [strongSelf.employeeDataSource addObject:model];
                
            }
            
            [strongSelf.enmloyeeListTableView reloadData];
            
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
    
    UINib* nib = [UINib nibWithNibName:@"HZDSemployeeListTableViewCell" bundle:nil];
    
    [_enmloyeeListTableView registerNib:nib forCellReuseIdentifier:@"employeeListTableViewCell"];
}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _employeeDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSemployeeListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"employeeListTableViewCell" forIndexPath:indexPath];
    
    HZDSemployeeListModel *model = _employeeDataSource[indexPath.section];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"员工姓名:%@",model.employeeName];
    
    cell.jobLabel.text = [NSString stringWithFormat:@"员工职位:%@",model.employeeJob];
    
    cell.telLabel.text = [NSString stringWithFormat:@"员工tel:%@",model.employeeTel];

    cell.phoneLabel.text = [NSString stringWithFormat:@"员工手机:%@",model.employeePhone];

    cell.qqWchatLabel.text = [NSString stringWithFormat:@"QQ/微信:%@/%@",model.employeeQQ,model.employeeWchat];

    cell.addressLabel.text = [NSString stringWithFormat:@"员工地址:%@",model.employeeAddress];

    cell.timeLabel.text = [NSString stringWithFormat:@"最后登录时间:%@",model.createTime];

    
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
    return 210;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,SCREEN_WIDTH - 20,1)];
    
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
    
    [leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    leftBtn.layer.cornerRadius = 3;
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    leftBtn.layer.masksToBounds = YES;
    
    leftBtn.backgroundColor = [UIColor redColor];
   
    leftBtn.tag = section;
    
    [leftBtn addTarget:self action:@selector(tapLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    
    rightBtn.backgroundColor = [UIColor colorWithHexString:@"46a0fc"];
    
    rightBtn.layer.cornerRadius = 3;
    
    rightBtn.layer.masksToBounds = YES;
    
    rightBtn.tag = section;
    
    [rightBtn addTarget:self action:@selector(tapRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:rightBtn];
    
    view.backgroundColor=[UIColor whiteColor];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
    
}
-(void)tapLeftBtn:(UIButton *)sender
{
    HZDSaddEmployeeViewController *add = [[HZDSaddEmployeeViewController alloc] init];
    
    HZDSemployeeListModel *model = [[HZDSemployeeListModel alloc] init];
    
    model = _employeeDataSource[sender.tag];
    
    add.addUrl = EMPLOYEE_EDIT;
    
    add.employeeType = editType;
    
    add.employModel = model;
    
    [self.navigationController pushViewController:add animated:YES];
    
}
-(void)tapRightBtn:(UIButton *)sender
{
    HZDSemployeeListModel *model = [[HZDSemployeeListModel alloc] init];
    
    model = _employeeDataSource[sender.tag];
    
    NSDictionary *dic = @{@"worker_id":model.employeeID
                          };
    
    [CrazyNetWork CrazyRequest_Post:EMPLOYEE_DELETE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"删除员工", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
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
