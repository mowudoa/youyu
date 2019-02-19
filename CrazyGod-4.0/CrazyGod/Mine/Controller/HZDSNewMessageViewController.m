//
//  HZDSNewMessageViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/11.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSNewMessageViewController.h"
#import "HZDSmessageTableViewCell.h"
#import "HZDSmyMessageDetailViewController.h"
#import "HZDSMessageModel.h"

@interface HZDSNewMessageViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *messageListTableView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *messageDataSource;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;
@end

@implementation HZDSNewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _messageDataSource = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    
    // 下拉加载
    self.messageListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.messageListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
        [self.messageListTableView.mj_footer endRefreshing];

    }];
    
    self.navigationItem.title = @"我的消息";
    
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSmessageTableViewCell" bundle:nil];
    [_messageListTableView registerNib:nib forCellReuseIdentifier:@"messageTableViewCell"];
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    
    [CrazyNetWork CrazyRequest_Post:_messageUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"消息列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.messageDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.messageListTableView.hidden = NO;
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.messageListTableView.hidden = YES;
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSMessageModel *model = [[HZDSMessageModel alloc] init];
                
                model.messageID = dict1[@"msg_id"];
                model.messageTime = dict1[@"create_time"];
                
                if (dict1[@"link_url"] == NULL || dict1[@"link_url"] == nil ||dict1[@"link_url"] == [NSNull null]) {
                    
                    
                }else{
                
                    model.messageUrl = dict1[@"link_url"];

                }
                
                
                model.messageTitle = dict1[@"title"];
                
                [strongSelf.messageDataSource addObject:model];
            }
            
            [strongSelf.messageListTableView reloadData];
            
        }else{
            
            
        }
        [strongSelf.messageListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
-(void)initMoreData
{
    __weak typeof(self) weakSelf = self;
    
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    
    [CrazyNetWork CrazyRequest_Post:_messageUrl parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"消息列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSMessageModel *model = [[HZDSMessageModel alloc] init];
                
                model.messageID = dict1[@"msg_id"];
                model.messageTime = dict1[@"create_time"];
                
                if (dict1[@"link_url"] == NULL || dict1[@"link_url"] == nil ||dict1[@"link_url"] == [NSNull null]) {
                    
                    
                }else{
                    
                    model.messageUrl = dict1[@"link_url"];
                    
                }
                
                
                model.messageTitle = dict1[@"title"];
                
                [strongSelf.messageDataSource addObject:model];
            }
            
            [strongSelf.messageListTableView reloadData];
           
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
    return _messageDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSmessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"messageTableViewCell" forIndexPath:indexPath];
    
    HZDSMessageModel *model = _messageDataSource[indexPath.section];

    cell.timeLabel.text = [NSString stringWithFormat:@"发布时间:%@",[self ConvertStrToTime:model.messageTime]];
    
    cell.titleLabel.text = model.messageTitle ;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
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
    [leftBtn setTitle:@"详细" forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius = 3;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"#ff9980"];
   // leftBtn.layer.borderWidth = 0.5;
    leftBtn.tag = section;
  //  [leftBtn addTarget:self action:@selector(tapLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
  //  [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"详细" forState:UIControlStateNormal];
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"exitlogin.png"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor colorWithHexString:@"46a0fc"];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.tag = section;
    [rightBtn addTarget:self action:@selector(tapRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    
    view.backgroundColor=[UIColor whiteColor];
    
    return view;
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


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
    
}
-(void)tapRightBtn:(UIButton *)sender
{
    
    HZDSMessageModel *model = _messageDataSource[sender.tag];

    HZDSmyMessageDetailViewController *detail = [[HZDSmyMessageDetailViewController alloc] init];
    
    if ([_messageUrl isEqualToString:MY_MESSAGE]) {
      
        detail.messageType = mineMessageType;
        
    }else if ([_messageUrl isEqualToString:MERCHANT_MESSAGE]){
      
        detail.messageType = merchantMessageType;

    }else if ([_messageUrl isEqualToString:EMPLOYEE_MESSAGE]){
        
        detail.messageType = employeeMessageType;

    }
    
    detail.messageID = model.messageID;
    [self.navigationController pushViewController:detail animated:YES];
    
    
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
