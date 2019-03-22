//
//  HZDSmyCollectionViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/13.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmyCollectionViewController.h"
#import "HZDGoodsDetailSViewController.h"
#import "HZDSMallDetailViewController.h"
#import "HZDSShopViewController.h"
#import "HZDSOrderTableViewCell.h"
#import "HZDSOrderModel.h"

@interface HZDSmyCollectionViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *collectionTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *collectionListArray;

@property(nonatomic,strong) NSMutableArray *collectionShopListArray;

@property(nonatomic,strong) NSMutableArray *collectionMallGoodsListArray;

@property(nonatomic,copy) NSString *urlString;

@property(nonatomic,copy) NSString *collectionType;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDSmyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _collectionListArray = [[NSMutableArray alloc] init];
   
    _collectionShopListArray = [[NSMutableArray alloc] init];
    
    _collectionMallGoodsListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
    
}
-(void)initUI
{
    _pageNum = 1;
    
    _totalPage = 1;
    
    // 下拉加载
    self.collectionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self initData];
        
    }];
    
    __weak __typeof(self) weakSelf = self;

    // 上拉刷新
    self.collectionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;
        
        [self initMoreData];
        
    }];
    
    _urlString = COLLECTION_MALLGOODS;
    
    _collectionType = @"0";
    
    self.navigationItem.title = @"商品收藏";
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,40,SCREEN_WIDTH/3,2)];
   
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"FF0270"];
    
    [self.view addSubview:_lineLabel];
    
    [WYFTools autuLayoutNewMJ:_collectionTableView];
    
}
-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"HZDSOrderTableViewCell" bundle:nil];
   
    [_collectionTableView registerNib:nib forCellReuseIdentifier:@"OrderTableViewCell"];
    
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    _pageNum = 1;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_urlString parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"收藏列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.collectionListArray removeAllObjects];
        
        [strongSelf.collectionShopListArray removeAllObjects];
        
        [strongSelf.collectionMallGoodsListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.collectionTableView.hidden = NO;
               
                strongSelf.backGroundView.hidden = YES;
                
            }else{
                
                strongSelf.collectionTableView.hidden = YES;
                
                strongSelf.backGroundView.hidden = NO;
            }
            
            if ([strongSelf.collectionType isEqualToString:@"0"]) {
                
                [self getMallGoods:dic];
                
            }else if ([strongSelf.collectionType isEqualToString:@"1"]){
                
                [self getShopList:dic];
                
            }else if ([strongSelf.collectionType isEqualToString:@"2"]){
                
                [self getRushToBuyList:dic];
                
            }
            
        }else{
            
            
        }
        [strongSelf.collectionTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)initMoreData
{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]                          };
    
    [CrazyNetWork CrazyRequest_Post:_urlString parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"收藏列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            if (strongSelf.pageNum > [dic[@"currentpgae"] integerValue]) {
             
            [JKToast showWithText:NOMOREDATA_STRING];
                
            [strongSelf.collectionTableView.mj_footer endRefreshing];

                return ;
            }
            
            if ([strongSelf.collectionType isEqualToString:@"0"]) {
                
                [self getMallGoods:dic];

            }else if ([strongSelf.collectionType isEqualToString:@"1"]){
                
                [self getShopList:dic];
                
            }else if ([strongSelf.collectionType isEqualToString:@"2"]){
                
                [self getRushToBuyList:dic];

            }
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}

//抢购列表
-(void)getRushToBuyList:(NSDictionary *)dic
{
 
    NSArray *arr = dic[@"datas"][@"list"];
    
    for (NSDictionary *dict1 in arr) {
        
        HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
        
        model.orderID = dict1[@"favorites_id"];
        
        model.orderImage = dict1[@"photo"];
        
        model.orderTitle = dict1[@"title"];
        
        model.orderPrice = [dict1[@"price"] stringValue];
        
        model.orderNeedPayPrice = [dict1[@"tuan_price"] stringValue];
        
        model.orderStatus = dict1[@"tuan_id"];

        [_collectionListArray addObject:model];
    }
    
    [_collectionTableView reloadData];
    
}
//线上店铺列表
-(void)getShopList:(NSDictionary *)dic
{
    
    NSArray *arr = dic[@"datas"][@"list"];
    
    for (NSDictionary *dict1 in arr) {
        
        HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
        
        model.orderID = dict1[@"favorites_id"];
       
        model.orderImage = dict1[@"logo"];
        
        model.orderTitle = dict1[@"weidian_name"];
        
        model.orderStatus = dict1[@"shop_id"];
        
        [_collectionShopListArray addObject:model];
    }
    
    [_collectionTableView reloadData];
}
//商品列表
-(void)getMallGoods:(NSDictionary *)dic
{
 
    NSArray *arr = dic[@"datas"][@"list"];
    
    for (NSDictionary *dict1 in arr) {
        
        HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
        
        model.orderID = dict1[@"favorites_id"];
        
        model.orderImage = dict1[@"photo"];
        
        model.orderTitle = dict1[@"title"];
        
        model.orderPrice = [dict1[@"price"] stringValue];
        
        model.orderNeedPayPrice = [dict1[@"mall_price"] stringValue];
        
        model.orderStatus = dict1[@"goods_id"];

        [_collectionMallGoodsListArray addObject:model];
    }
    
    [_collectionTableView reloadData];
}

#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([_collectionType isEqualToString:@"0"]) {
        
        return _collectionMallGoodsListArray.count;
        
    }else if ([_collectionType isEqualToString:@"1"]){
        
        return _collectionShopListArray.count;
        
    }else{
        
        return _collectionListArray.count;

    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    
    if ([_collectionType isEqualToString:@"0"]) {
        
        HZDSOrderModel *model = _collectionMallGoodsListArray[indexPath.section];
        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
        
        cell.titleLabel.text = model.orderTitle;
        
        //cell.oldPriceLabel.text = [NSString stringWithFormat:@"原价:¥%@",model.orderPrice];
        
        NSString *oldPriceString = [NSString stringWithFormat:@"原价:¥%@",model.orderPrice];
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPriceString attributes:attribtDic];
        
        // 赋值
        cell.oldPriceLabel.attributedText = attribtStr;
        
        cell.oldPriceLabel.textColor = [UIColor colorWithHexString:@"#dcdcdc"];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"价格:¥%@",model.orderNeedPayPrice];
        
        cell.priceLabel.textColor = [UIColor redColor];
        
    }else if ([_collectionType isEqualToString:@"1"]){
     
        HZDSOrderModel *model = _collectionShopListArray[indexPath.section];
        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
        
        cell.titleLabel.text = model.orderTitle;
        
        cell.priceLabel.textColor = [UIColor redColor];
        
        cell.priceLabel.text = @"";
        
        cell.oldPriceLabel.text = @"";
        
    }else{
        
        HZDSOrderModel *model = _collectionListArray[indexPath.section];
        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.orderImage]] placeholderImage:[UIImage imageNamed:@"baseImage"]];
        
        cell.titleLabel.text = model.orderTitle;
        
        NSString *oldPriceString = [NSString stringWithFormat:@"原价:¥%@",model.orderPrice];
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPriceString attributes:attribtDic];
        
        // 赋值
        cell.oldPriceLabel.attributedText = attribtStr;
        
        cell.oldPriceLabel.textColor = [UIColor colorWithHexString:@"#dcdcdc"];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"价格:¥%@",model.orderNeedPayPrice];
        
        cell.priceLabel.textColor = [UIColor redColor];
    }
    

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_collectionType isEqualToString:@"0"]) {
        
    
        HZDSMallDetailViewController *detail = [[HZDSMallDetailViewController alloc] init];
        
        HZDSOrderModel *model = _collectionMallGoodsListArray[indexPath.section];
        
        detail.goodsId = model.orderStatus;
        
        [self.navigationController pushViewController:detail animated:YES];
    
    }else if ([_collectionType isEqualToString:@"1"]) {
        
        HZDSShopViewController *shop = [[HZDSShopViewController alloc] init];
        
        HZDSOrderModel *model = _collectionShopListArray[indexPath.section];

        shop.shop_id = model.orderStatus;
        
        [self.navigationController pushViewController:shop animated:YES];
        
    }else if ([_collectionType isEqualToString:@"2"]){
     
        HZDSOrderModel *model = [[HZDSOrderModel alloc] init];
        
        model = _collectionListArray[indexPath.section];
        
        HZDGoodsDetailSViewController *good = [[HZDGoodsDetailSViewController alloc] init];
        
        good.goodsID = model.orderStatus;
    
        [self.navigationController pushViewController:good animated:YES];
        
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(143);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    HZDSOrderModel *model = [[HZDSOrderModel alloc] init];

    if ([_collectionType isEqualToString:@"0"]) {
        
        model = _collectionMallGoodsListArray[section];
        
    }else if ([_collectionType isEqualToString:@"1"]){
        
        model = _collectionShopListArray[section];

    }else{
        
        model = _collectionListArray[section];

    }
    
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,39,SCREEN_WIDTH,1)];
   
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
    
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    
    [WYFTools viewLayer:3 withView:leftBtn];
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"#ff9980"];

    leftBtn.tag = section;

    [leftBtn addTarget:self action:@selector(tapleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];

    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];

    rightBtn.backgroundColor = [UIColor redColor];

    [WYFTools viewLayer:3 withView:rightBtn];

    rightBtn.tag = section;

    [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];

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
    
}
-(void)tapBtn:(UIButton *)sender
{
    NSString *deleteUrl;
    
    HZDSOrderModel *model;
    
    if ([_collectionType isEqualToString:@"0"]) {
        
        model = _collectionMallGoodsListArray[sender.tag];
        
        deleteUrl = COLLECTION_DELETE_MALLGOODS;
        
    }else if ([_collectionType isEqualToString:@"1"]){
        
        model = _collectionShopListArray[sender.tag];
        
        deleteUrl = COLLECTION_DELETE_SHOP;
        
    }else if ([_collectionType isEqualToString:@"2"]){
        
        model = _collectionListArray[sender.tag];
        
        deleteUrl = COLLECTION_DELETE_RUSH;
    }
    
    NSDictionary *dic = @{@"favorites_id":model.orderID};
    
    [CrazyNetWork CrazyRequest_Post:deleteUrl parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"删除收藏", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
   
    
}
- (IBAction)collectionType:(UIButton *)sender {

    NSInteger num = sender.tag - 400;
    
    [self moveLineLabel:num];
}
-(void)moveLineLabel:(NSInteger)index
{
    
    switch (index) {
        case 0:
            _collectionType = @"0";
            
            _urlString = COLLECTION_MALLGOODS;
            
            self.navigationItem.title = @"商品收藏";
            
            break;
        case 1:
            
            _collectionType = @"1";
            
            _urlString = COLLECTION_SHOP;
            
            self.navigationItem.title = @"线上店铺收藏";

            break;
        case 2:
            
            _collectionType = @"2";
            
            _urlString = COLLECTION_RUSHTOBUY;
            
            self.navigationItem.title = @"抢购收藏";

            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.mj_x,_lineLabel.mj_y,SCREEN_WIDTH/3, _lineLabel.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        lineFrame.origin.x = index* SCREEN_WIDTH /3;
        
        self->_lineLabel.frame = lineFrame;
    }];
    
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
