//
//  HZDSMallGoodsManageViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/28.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMallGoodsManageViewController.h"
#import "HZDSAddMallGoodsViewController.h"
#import "HZDSOrderTableViewCell.h"
#import "HZDSOrderModel.h"

@interface HZDSMallGoodsManageViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *mallGoodstableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *goodsListArray;

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDSMallGoodsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _goodsListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
}
-(void)initUI
{
    self.navigationItem.title = @"商城商品";
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    // 下拉加载
    self.mallGoodstableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [self initData];
    
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.mallGoodstableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
    }];
}
-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];;
      
        [button setFrame:CGRectMake(0, 5, 25, 25)];
        
        [button addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];

        [button setTitle:@"添加" forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _rightItem;
}

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSOrderTableViewCell" bundle:nil];
   
    [_mallGoodstableView registerNib:nib forCellReuseIdentifier:@"OrderTableViewCell"];
}
-(void)initData
{
 
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:MALL_MANAGE_GOODSLIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商品列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.goodsListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.mallGoodstableView.hidden = NO;
                
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.mallGoodstableView.hidden = YES;
                
                strongSelf.backGroundView.hidden = NO;
            }
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
                
                model.orderID = dict1[@"goods_id"];
               
                model.orderImage = dict1[@"photo"];
                
                model.orderTitle = dict1[@"title"];
                
                model.orderPrice = [dict1[@"mall_price"] stringValue];
                
                model.soldNum = dict1[@"sold_num"];
                
                model.orderNum = dict1[@"num"];
                
                model.orderTime = dict1[@"create_time"];
                
                model.orderStatus = dict1[@"guige"];
                
                model.orderType = dict1[@"audit"];
                
                [strongSelf.goodsListArray addObject:model];
            }
            
            [strongSelf.mallGoodstableView reloadData];
            
        }else{
            
            
        }
        
        [strongSelf.mallGoodstableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)initMoreData
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    
    [CrazyNetWork CrazyRequest_Post:MALL_MANAGE_GOODSLIST parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商品列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
                
                model.orderID = dict1[@"goods_id"];
               
                model.orderImage = dict1[@"photo"];
                
                model.orderTitle = dict1[@"title"];
                
                model.orderPrice = [dict1[@"mall_price"] stringValue];
                
                model.soldNum = dict1[@"sold_num"];
                
                model.orderNum = dict1[@"num"];
                
                model.orderTime = dict1[@"create_time"];
                
                model.orderStatus = dict1[@"guige"];
                
                model.orderType = dict1[@"audit"];

                [strongSelf.goodsListArray addObject:model];
            }
            
            [strongSelf.mallGoodstableView reloadData];
            
            [strongSelf.mallGoodstableView.mj_footer endRefreshing];

            if (arr.count > 0) {
                
            }else{
                
                [JKToast showWithText:NOMOREDATA_STRING];
                
                [strongSelf.mallGoodstableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _goodsListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    
    HZDSOrderModel *model = _goodsListArray[indexPath.section];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
    
    cell.titleLabel.text = model.orderTitle;
    
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"已售: %@ 库存: %@/%@",model.soldNum,model.orderNum,model.orderStatus];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"销售价:¥%@",model.orderPrice];
    
    cell.priceLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(143);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
    
    model = _goodsListArray[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
   
    [backView addSubview:view];
    
    UILabel *shanghu = [WYFTools createLabel:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20) bgColor:[UIColor clearColor] text:[NSString stringWithFormat:@"商品ID:%@",model.orderID] textFont:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft textColor:[UIColor blackColor] tag:section];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    
    [backView addSubview:view1];
    
    UILabel *dingdantime = [WYFTools createLabel:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20) bgColor:[UIColor clearColor] text:[NSString stringWithFormat:@"发布时间:%@",[WYFTools ConvertStrToTime:model.orderTime dateModel:@"yyyy-MM-dd" withDateMultiple:1]] textFont:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:[UIColor blackColor] tag:section];
    
    [view1 addSubview:dingdantime];
    
    return backView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
    model = _goodsListArray[section];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,39,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [view addSubview:lineLabel];
    
    UIButton *leftBtn1 = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75-75-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#b5b5b5"] title:@"" titleFont:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:nil vc:self];
    
    [WYFTools viewLayer:3 withView:leftBtn1];

    [view addSubview:leftBtn1];
    
    if ([model.orderType isEqualToString:@"0"]) {
        
        [leftBtn1 setTitle:@"待审" forState:UIControlStateNormal];

    }else{

        [leftBtn1 setTitle:@"正常" forState:UIControlStateNormal];
    }
    
    UIButton *leftBtn = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#ff9980"] title:@"编辑" titleFont:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:@selector(tapleftBtn:) vc:self];
    
    [WYFTools viewLayer:3 withView:leftBtn];
    
    [view addSubview:leftBtn];
    
    UIButton *rightBtn = [WYFTools createButton:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25) bgColor:[UIColor colorWithHexString:@"#ff9980"] title:@"删除" titleFont:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] slectedTitleColor:nil tag:section action:@selector(tapBtn:) vc:self];

    [WYFTools viewLayer:3 withView:rightBtn];
   
    [view addSubview:rightBtn];
    
    view.backgroundColor=[UIColor whiteColor];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}
-(void)tapleftBtn:(UIButton *)sender
{
    HZDSOrderModel *model = _goodsListArray[sender.tag];

    HZDSAddMallGoodsViewController *add = [[HZDSAddMallGoodsViewController alloc] init];
    
    add.addgoodsType = editMallGoodsType;
    
    add.goods_id = model.orderID;
    
    [self.navigationController pushViewController:add animated:YES];
 
}
-(void)tapBtn:(UIButton *)sender
{
    
    HZDSOrderModel *model = _goodsListArray[sender.tag];
    
    if ([sender.currentTitle isEqualToString:@"删除"]) {
    
        NSDictionary *dic = @{@"goods_id":model.orderID};
        
        [CrazyNetWork CrazyRequest_Post:MALL_MANAGE_GOODSLIST_DELETE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"删除商品", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self initData];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
    
}

//添加商品
-(void)addClick:(UIButton *)sender
{
    HZDSAddMallGoodsViewController *add = [[HZDSAddMallGoodsViewController alloc] init];
    
    add.addgoodsType = addMallGoodsType;
    
    [self.navigationController pushViewController:add animated:YES];
    
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
