//
//  HZDSMySubordinateViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/2/16.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMySubordinateViewController.h"
#import "HZDSSubordinteTableViewCell.h"
#import "HZDSSubRoradinteModel.h"

@interface HZDSMySubordinateViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *mySubordinateTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *subordinateListArray;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,copy) NSString *subordinateLevel;

@property(nonatomic,assign) NSInteger pageNum;

@end

@implementation HZDSMySubordinateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _subordinateListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
}
-(void)initUI
{
    self.navigationItem.title = @"我的顾客";
    
    _pageNum = 1;
    
    // 下拉加载
    self.mySubordinateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self initData];
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.mySubordinateTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.mySubordinateTableView.mj_footer endRefreshing];

    }];
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,40,SCREEN_WIDTH/2,2)];
    
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"FF0270"];
    
    [self.view addSubview:_lineLabel];
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSSubordinteTableViewCell" bundle:nil];
    
    [_mySubordinateTableView registerNib:nib forCellReuseIdentifier:@"SubordinteTableViewCell"];
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"level":_subordinateLevel
                          };
    
    [CrazyNetWork CrazyRequest_Post:MYSUBORDINATE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"余额日志列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.subordinateListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.mySubordinateTableView.hidden = NO;
                
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.mySubordinateTableView.hidden = YES;
                
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSSubRoradinteModel *model = [[HZDSSubRoradinteModel alloc] init];
                
                model.account = dict1[@"account"] ;
                
                model.nickName = dict1[@"nickname"];
                
                model.registerTime = dict1[@"reg_time"];
                
                model.SubRoradinteID = dict1[@"user_id"];
                
                if (dict1[@"email"] == NULL || dict1[@"email"] == nil ||dict1[@"email"] == [NSNull null]) {
                    
                    model.email = @"暂未设置";
                    
                }else{
                    
                    model.email = dict1[@"email"];
                }
                
                [strongSelf.subordinateListArray addObject:model];
            }
            
            [strongSelf.mySubordinateTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.mySubordinateTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)initMoreData
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          @"level":_subordinateLevel
                          };
    
    
    [CrazyNetWork CrazyRequest_Post:MYSUBORDINATE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"余额日志列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            

            for (NSDictionary *dict1 in arr) {
                
                HZDSSubRoradinteModel *model = [[HZDSSubRoradinteModel alloc] init];
                
                model.account = dict1[@"account"] ;
                
                model.nickName = dict1[@"nickname"];
                
                model.registerTime = dict1[@"reg_time"];
                
                model.SubRoradinteID = dict1[@"user_id"];
                
                [strongSelf.subordinateListArray addObject:model];
            }
            
            [strongSelf.mySubordinateTableView reloadData];
            
            if (arr.count > 0) {
                
            }else{
                
                [JKToast showWithText:@"没有更多了"];
            }
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
- (IBAction)buttonCLick:(UIButton *)sender {

    NSInteger num = sender.tag - 400;
    
    
    [self moveLineLabel:num];
}
-(void)moveLineLabel:(NSInteger)index
{
    
    switch (index) {
        case 0:
            _subordinateLevel = @"1";
           
            break;
        case 1:
            _subordinateLevel = @"2";
           
            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.frame.origin.x,_lineLabel.frame.origin.y,SCREEN_WIDTH/2, _lineLabel.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        lineFrame.origin.x =  index* SCREEN_WIDTH/2;
        
        self->_lineLabel.frame = lineFrame;
    }];
    
    [self initData];
}
-(void)initnavBtn
{
    
    
    NSInteger num = 0;
    switch (_SubordinateType) {
            
        case MySubordinateFirst:
            num = 0;
            break;
        case MySubordinateSecond:
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
    return _subordinateListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSSubordinteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubordinteTableViewCell" forIndexPath:indexPath];
    
    HZDSSubRoradinteModel *model = _subordinateListArray[indexPath.section];
    
    cell.userAccount.text = [NSString stringWithFormat:@"账户:%@",model.account];
    
    cell.userNickName.text = [NSString stringWithFormat:@"昵称:%@",model.nickName];
    
    cell.userEmail.text = [NSString stringWithFormat:@"EMAIL:%@",model.email];

    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(84);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSSubRoradinteModel *model = [[HZDSSubRoradinteModel alloc] init];
    
    model = _subordinateListArray[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
    
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20)];
    
    shanghu.text = [NSString stringWithFormat:@"ID:%@",model.SubRoradinteID];
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    
    shanghu.font=[UIFont systemFontOfSize:13];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    
    [backView addSubview:view1];
    
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20)];
    
    dingdantime.text =[NSString stringWithFormat:@"注册时间:%@",model.registerTime];
    
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
