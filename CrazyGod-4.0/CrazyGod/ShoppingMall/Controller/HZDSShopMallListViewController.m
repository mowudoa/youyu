//
//  HZDSShopMallListViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/21.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSShopMallListViewController.h"
#import "HZDSMallDetailViewController.h"
#import "HZDSMallListTableViewCell.h"
#import "HZDSSubClassTableViewCell.h"
#import "HZDSBusinessModel.h"
#import "HZDSClassifyModel.h"
#import "HZDSSubClassModel.h"
@interface HZDSShopMallListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
{
 
    NSString *classString;
    
    NSString *areaIdString;
    
    NSString *choiceString;
    
}

@property (weak, nonatomic) IBOutlet UITableView *mallListTableView;

@property (weak, nonatomic) IBOutlet UITableView *classTableView;

@property (weak, nonatomic) IBOutlet UITableView *subClassTableView;

@property (weak, nonatomic) IBOutlet UITableView *sortTableview;

@property (weak, nonatomic) IBOutlet UIView *headerClassView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property (weak, nonatomic) IBOutlet UIView *backGroundViewWithNothing;

@property(nonatomic,strong) NSMutableArray *mallListArray;

@property(nonatomic,strong) NSMutableArray *classArray;

@property(nonatomic,strong) NSMutableArray *areaArray;

@property(nonatomic,strong) NSMutableArray *subClassArray;

@property(nonatomic,strong) NSMutableArray *sortArray;

@property(strong,nonatomic)UIView* headerView;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,assign) NSInteger totalPage;

@end

@implementation HZDSShopMallListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mallListArray = [[NSMutableArray alloc] init];
    
    _classArray = [[NSMutableArray alloc] init];
    
    _areaArray = [[NSMutableArray alloc] init];
    
    _sortArray = [[NSMutableArray alloc] init];
    
    _subClassArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
    
    [self initCLassData];
    
}
-(void)initUI
{
    
    _totalPage = 1;
    
    self.navigationItem.title = @"在线商城";
    
    [self.headerClassView addSubview:self.headerView];
   
    UIButton *btn = [self.headerView viewWithTag:10];
    
    if (_classNameString != nil) {
        
        [btn setTitle:_classNameString forState:UIControlStateNormal];
        
    }
    
    __weak __typeof(self) weakSelf = self;

    // 下拉加载
    self.mallListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        weakSelf.pageNum = 1;
       
        [self initData];
        
    }];
    
    // 上拉刷新
    self.mallListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageNum ++;

        [self initMoreData];

    }];

    [WYFTools autuLayoutNewMJ:_mallListTableView];
    
}

-(void)registercell
{
    
    UINib* nib = [UINib nibWithNibName:@"HZDSMallListTableViewCell" bundle:nil];
    
    [_mallListTableView registerNib:nib forCellReuseIdentifier:@"MallListTableViewCell"];
    
    UINib* nib1 = [UINib nibWithNibName:@"HZDSSubClassTableViewCell" bundle:nil];
    
    [_classTableView registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];
    
    [_subClassTableView registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];
    
    [_sortTableview registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];
    
}
-(UIView*)headerView
{
    if (_headerView == nil) {
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        
        for (int i = 0 ; i < 3; i++) {
            
            NSArray* arr = @[@"选择分类",@"选择地区",@"选择排序"];
            
            UIButton *button = [WYFTools createButton:CGRectMake(i*(SCREEN_WIDTH - 20)/3 + 5*(i + 1) ,0, (SCREEN_WIDTH - 20)/3, 35) bgColor:[UIColor clearColor] title:arr[i] titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor blackColor] slectedTitleColor:[UIColor colorWithHexString:@"#FC6621"]  tag:i + 10 action:@selector(touchheaderView:) vc:self];
            
            _headerView.userInteractionEnabled = YES;
            
            [_headerView addSubview:button];
            
            if (i < 2) {
             
                UILabel *label = [WYFTools createLabel:CGRectMake((i+ 1)*SCREEN_WIDTH/3 , 5,1, 25) bgColor:[UIColor colorWithHexString:@"#F5F5F5"] text:@"" textFont:[UIFont systemFontOfSize:15]  textAlignment:NSTextAlignmentCenter textColor:[UIColor clearColor] tag:i];
                
                [_headerView addSubview:label];
                
            }
           
        }
        
    }
    
    return _headerView;
}
-(void)initData
{
    _pageNum = 1;
    
    NSMutableDictionary *keyDic = [[NSMutableDictionary alloc] init];
    
    if (_classIDString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"cat":_classIDString}];
    }
    if (areaIdString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"business":areaIdString}];
    }
    if (choiceString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"order":choiceString}];
    }
    if (_keyWordString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"keyword":_keyWordString}];
    }
    
    [keyDic addEntriesFromDictionary: @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]}];
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_LIST] parameters:keyDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商城列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.mallListArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
                strongSelf.backGroundViewWithNothing.hidden = YES;
                
                strongSelf.mallListTableView.hidden = NO;
                
            }else{
                
                strongSelf.backGroundViewWithNothing.hidden = NO;
                
                strongSelf.mallListTableView.hidden = YES;
                
            }
            
            for (NSDictionary *business in arr) {
                
                HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
                
                model.businessIcon = business[@"photo"];
                
                model.businessId = business[@"goods_id"];
                
                model.businessName = business[@"title"];
                
                model.businessSaleNum = business[@"sold_num"];
                
                model.businessPrice = [business[@"mall_price"] stringValue];
                
                model.businessOldPrice = [business[@"price"] stringValue];
                
                [strongSelf.mallListArray addObject:model];
                
            }
            
        }
        
        [strongSelf.mallListTableView reloadData];
        
        [strongSelf.mallListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
    _keyWordString = nil;
    
    _backGroundView.hidden = YES;
    
}
-(void)initMoreData
{
  
    NSMutableDictionary *keyDic = [[NSMutableDictionary alloc] init];
    
    if (_classIDString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"cat":_classIDString}];
    }
    if (areaIdString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"business":areaIdString}];
    }
    if (choiceString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"order":choiceString}];
    }
    if (_keyWordString != nil) {
        
        [keyDic addEntriesFromDictionary:@{@"keyword":_keyWordString}];
    }
    
    [keyDic addEntriesFromDictionary: @{@"lastindex":[NSString stringWithFormat:@"%ld",(long)_pageNum]}];
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_LIST] parameters:keyDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商城列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            for (NSDictionary *business in arr) {
                
                HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
                
                model.businessIcon = business[@"photo"];
                
                model.businessId = business[@"goods_id"];
                
                model.businessName = business[@"title"];
                
                model.businessSaleNum = business[@"sold_num"];
                
                model.businessPrice = [business[@"mall_price"] stringValue];
                
                model.businessOldPrice = [business[@"price"] stringValue];
                
                [strongSelf.mallListArray addObject:model];
                
            }
        
            [strongSelf.mallListTableView reloadData];
            
            [strongSelf.mallListTableView.mj_footer endRefreshing];

            if (arr.count > 0) {
                
            }else{
                
                [JKToast showWithText:NOMOREDATA_STRING];

                [strongSelf.mallListTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }

    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
    _keyWordString = nil;
    
    _backGroundView.hidden = YES;
}
//分类
-(void)initCLassData
{
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_CLASS] parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"类别列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.classArray removeAllObjects];
        
        [strongSelf.areaArray removeAllObjects];
        
        [strongSelf.sortArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSDictionary *classDic = dic[@"datas"][@"shopcates"];
            
            NSArray *classArr = [classDic allKeys];
            
            [strongSelf.classArray addObject:@"全部分类"];
            
            for (NSString *str in classArr) {
                
                HZDSClassifyModel *model = [[HZDSClassifyModel alloc] init];
                
                model.classId = classDic[str][@"cate_id"];
                
                model.className = classDic[str][@"cate_name"];
                
                NSDictionary *subClassDic = classDic[str][@"son"];
                
                NSArray *subClassArr = [subClassDic allKeys];
                
                for (NSString *classString in subClassArr) {
                    
                    HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                    
                    model1.classId = subClassDic[classString][@"cate_id"];
                    
                    model1.className = subClassDic[classString][@"cate_name"];
                    
                    [model.subClassArray addObject:model1];
                    
                }
                
                [strongSelf.classArray addObject:model];
            }
            
            [strongSelf.areaArray addObject:@"全部地区"];
            
            NSArray *areaArray = dic[@"datas"][@"areas"];
            
            for (NSDictionary *areaDic in areaArray){
                
                HZDSClassifyModel *model = [[HZDSClassifyModel alloc] init];
                
                model.classId = areaDic[@"area_id"];
                
                model.className = areaDic[@"area_name"];
                
                NSArray *subArea = areaDic[@"business"];
                
                for (NSDictionary *subAreaDic in subArea) {
                    
                    HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                    
                    model1.classId = subAreaDic[@"business_id"];
                    
                    model1.className = subAreaDic[@"business_name"];
                    
                    [model.subClassArray addObject:model1];
                    
                }
                
                [strongSelf.areaArray addObject:model];
            }
            
        }
        
        [self initSortArray];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}

//排序类别数组,由前台写死即可
-(void)initSortArray
{
    NSArray *sortId = @[@"0",@"1",@"2",@"3",@"4"];
    
    NSArray *sortName = @[@"默认排序",@"时间排序",@"销量优先",@"价格最高",@"价格最低"];
    
    for (int i = 0; i < sortId.count; i ++ ) {
        
        HZDSClassifyModel *model = [[HZDSClassifyModel alloc] init];
        
        model.classId = sortId[i];
        
        model.className = sortName[i];
        
        [_sortArray addObject:model];
        
    }
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mallListTableView) {
        
        return _mallListArray.count;
        
    }else if (tableView == _classTableView)
    {
        if ([classString isEqualToString:@"1"]) {
            
            return _classArray.count;
            
        }else{
            
            return  _areaArray.count;
        }
        
    }else if (tableView == _subClassTableView){
        
        return _subClassArray.count;
        
    }else{
        
        return _sortArray.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _mallListTableView) {
        
        HZDSMallListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MallListTableViewCell" forIndexPath:indexPath];
        
        HZDSBusinessModel *model = _mallListArray[indexPath.row];

        cell.nameLabel.text = model.businessName;
        
        [cell.titileIcon sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.businessIcon]]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.businessPrice];
        
        cell.soldNumLabel.text = [NSString stringWithFormat:@"已售:%@",model.businessSaleNum];
        
        NSString *textStr = [NSString stringWithFormat:@"￥%@", model.businessOldPrice];
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
        
        // 赋值
        cell.oldPriceLabel.attributedText = attribtStr;
            
        return cell;
        
    }else if (tableView == _classTableView)
    {
        HZDSSubClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubClassTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            if ([classString isEqualToString:@"1"]){
                
                cell.nameLabel.text = _classArray[indexPath.row];
                
            }else{
                
                cell.nameLabel.text = _areaArray[indexPath.row];
                
            }
            
        }else{
            
            if ([classString isEqualToString:@"1"]) {
                
                HZDSClassifyModel *model = _classArray[indexPath.row];
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.className];
            }else{
                
                HZDSClassifyModel *model = _areaArray[indexPath.row];
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.className];
            }
            
        }
        
        return cell;
        
    }else if (tableView == _subClassTableView){
        
        HZDSSubClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubClassTableViewCell" forIndexPath:indexPath];
        
        HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
        
        model1 = _subClassArray[indexPath.row];
        
        if ([classString isEqualToString:@"1"]) {
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model1.className];
            
        }else{
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model1.className];
            
        }
        
        
        return cell;
        
    }else{
        
        HZDSSubClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubClassTableViewCell" forIndexPath:indexPath];
        
        HZDSClassifyModel *model = _sortArray[indexPath.row];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.className];
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _classTableView) {
        
        if (indexPath.row == 0) {
            
            _classTableView.hidden = YES;
            
            _subClassTableView.hidden = YES;
            
            _backGroundView.hidden = YES;
            
            if ([classString isEqualToString:@"1"]) {
                
                UIButton *btn = [self.headerView viewWithTag:10];
                
                [btn setTitle:@"选择分类" forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                btn.selected = NO;
                
                _classIDString = nil;

                [self initData];
                
            }else{
                
                UIButton *btn = [self.headerView viewWithTag:11];
                
                [btn setTitle:@"选择地区" forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                btn.selected = NO;
                
                areaIdString = nil;
                
                [self initData];
                
            }
            
        }else{
            
            [self changeCellBackgroundColor:tableView withIndexPath:indexPath];
            
            [_subClassArray removeAllObjects];
            
            HZDSClassifyModel *model;
            
            if ([classString isEqualToString:@"1"]) {
                
                model =  _classArray[indexPath.row];
                
            }else{
                
                model = _areaArray[indexPath.row];
            }
            
            [_subClassArray addObjectsFromArray:model.subClassArray];
            
            _subClassTableView.hidden = NO;
            
            [_subClassTableView reloadData];
            
        }
        
    }else if (tableView == _subClassTableView){
        
        if ([classString isEqualToString:@"1"]) {
            
            UIButton *btn = [self.headerView viewWithTag:10];
            
            HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
            
            model1 = _subClassArray[indexPath.row];
            
            [btn setTitle:model1.className forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor colorWithHexString:@"#FC6621"] forState:UIControlStateNormal];

            _classIDString = model1.classId;
            
            [self initData];
            
            btn.selected = NO;
            
        }else{
            
            UIButton *btn = [self.headerView viewWithTag:11];
            
            HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
            
            model1 = _subClassArray[indexPath.row];
            
            [btn setTitle:model1.className forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor colorWithHexString:@"#FC6621"] forState:UIControlStateNormal];

            btn.selected = NO;
            
            areaIdString = model1.classId;
            
            [self initData];
        }
        
        _classTableView.hidden = YES;
        
        _subClassTableView.hidden = YES;
        
        [self changeCellBackgroundColor:_classTableView withIndexPath:nil];
        
    }else if (tableView == _sortTableview){
        
        UIButton *btn = [self.headerView viewWithTag:12];
        
        HZDSClassifyModel *model = _sortArray[indexPath.row];
        
        _sortTableview.hidden = YES;
        
        if ([model.classId isEqualToString:@"0"]) {
            
            choiceString = nil;
            
            [btn setTitle:@"选择排序" forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else{
         
            choiceString = model.classId;

            [btn setTitle:model.className forState:UIControlStateNormal];

            [btn setTitleColor:[UIColor colorWithHexString:@"#FC6621"] forState:UIControlStateNormal];

        }
        
        [self initData];
        
        btn.selected = NO;
        
    }else{
        
        
        HZDSMallDetailViewController *detail = [[HZDSMallDetailViewController alloc] init];
        
        HZDSBusinessModel *model = _mallListArray[indexPath.row];
        
        detail.goodsId = model.businessId;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mallListTableView) {
        
        return HEIGHT(150);
        
    }else{
        
        return 35;
    }
    
}

//分类点击事件
-(void)touchheaderView:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 10:
            
            classString = @"1";
            
            _classTableView.hidden = !sender.selected;
            
            _sortTableview.hidden = YES;
            
            _subClassTableView.hidden = YES;
            
            [_classTableView reloadData];
            
            break;
        case 11:
            
            classString = @"2";
            
            _classTableView.hidden = !sender.selected;
            
            _sortTableview.hidden = YES;
            
            _subClassTableView.hidden = YES;
            
            [_classTableView reloadData];
            
            break;
            
        case 12:
            
            classString = @"3";
            
            _classTableView.hidden = YES;
            
            _subClassTableView.hidden = YES;
            
            _sortTableview.hidden = !sender.selected;
            
            [_sortTableview reloadData];
            
            break;
        default:
            break;
    }
    
    _backGroundView.hidden = !sender.selected;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _classIDString = nil;
    
    areaIdString = nil;
    
    choiceString = nil;
    
    _classNameString = nil;
    
    [self initView];
    
}
-(void)initView
{
    
    _subClassTableView.hidden = YES;
    
    _classTableView.hidden = YES;
    
    _sortTableview.hidden = YES;
    
    _backGroundView.hidden = YES;
    
    NSArray* arr = [_headerView subviews];
    
    for (id obj in arr) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
           
            UIButton* btn = (UIButton*)obj;
            
            btn.selected = NO;
        }
    }
    
}

//改变选中cell的背景色颜色
-(void)changeCellBackgroundColor:(UITableView *)tableview withIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleCells = [tableview visibleCells];
    
    for (HZDSSubClassTableViewCell *cell in visibleCells){
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    
    if (indexPath != nil) {
   
        HZDSSubClassTableViewCell *celled = [tableview cellForRowAtIndexPath:indexPath];
        
        celled.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        
        celled.nameLabel.textColor = [UIColor colorWithHexString:@"#FC6621"];
    }
    
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
