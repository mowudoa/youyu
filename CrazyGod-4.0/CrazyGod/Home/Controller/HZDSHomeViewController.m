//
//  HZDSHomeViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSHomeViewController.h"
#import "scrollPhotos.h"
#import "DCCycleScrollView.h"
#import "HZDSHomeTableViewCell.h"
#import "HZDSClassTableViewCell.h"
#import "HZDSImageTableViewCell.h"
#import "HZDSBusinessDetailViewController.h"
#import "HZDSLinkWebViewController.h"
#import "HZDSCityListViewController.h"
#import "HZDSSearchViewController.h"
#import "HZDSBusinessViewController.h"
#import "SWQRCode.h"


#import "HomeModel.h"

@interface HZDSHomeViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
DCCycleScrollViewDelegate,
classBtnDelagate,
cityChoiceDelegate
>
{
    NSMutableArray *_shopArray;;
    
    NSMutableArray *_hotShopArray;
    
    NSMutableArray *_bannerArray;
    
    NSMutableArray *_classArray;
    
    NSMutableArray *_titleArray;
    
    NSMutableArray *_advArray;
    
    NSString *_locationAndTemperature;
}
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;

@property(strong,nonatomic)UIImageView* searchImage;

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@property(strong,nonatomic)UIBarButtonItem* leftItem;

@property(nonatomic,strong)DCCycleScrollView* scrollImageView;

@property(nonatomic,strong)scrollPhotos* headView;

@end

@implementation HZDSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNav];
    
    [self registercell];
    
}

-(void)initNav
{
    
      self.navigationItem.titleView = self.searchImage;
    
    
    //  self.navigationItem.rightBarButtonItem = self.rightItem;
//        self.GoodsCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self requestData];
//        }];
    
    _hotShopArray = [[NSMutableArray alloc] init];
    
    _shopArray = [[NSMutableArray alloc] init];
    
    _bannerArray  = [[NSMutableArray alloc] init];
    
    _classArray  = [[NSMutableArray alloc] init];
    
    _titleArray  = [[NSMutableArray alloc] init];
    
    _advArray = [[NSMutableArray alloc] init];
}
-(void)initData
{
    
//    NSDictionary* dic = @{@"userId":[USER_DEFAULT objectForKey:@"uid"]};
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,HOMEINFO] parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"首页", dic);
        
        [self->_shopArray removeAllObjects];
        [self->_hotShopArray removeAllObjects];
        [self->_classArray removeAllObjects];
        [self->_bannerArray removeAllObjects];
        [self->_titleArray removeAllObjects];
        [self->_advArray removeAllObjects];
        
        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            NSDictionary* List = dic[@"datas"];
            
            //附近商家
            for (NSDictionary *dictlist in List[@"ele"]) {
                
                HomeModel *model = [[HomeModel alloc] init];

                model.goodsName = dictlist[@"shop_name"];
                
                model.goodsIcon = dictlist[@"photo"];
                
                model.distance = dictlist[@"d"];
                
                model.goodsId = dictlist[@"shop_id"];
                
                [model.tagArray addObjectsFromArray:dictlist[@"tags"]];
                
                
                [self->_shopArray addObject:model];
            }
            
            //轮播
            [self->_bannerArray addObjectsFromArray:List[@"slide"]];
            //热门
            if (List[@"hot_shop"] == NULL || List[@"hot_shop"] == nil ||List[@"hot_shop"] == [NSNull null]) {
                
            }else{
              
                [self->_hotShopArray addObjectsFromArray:List[@"hot_shop"]];
            }
            
            //分类
            [self->_classArray addObjectsFromArray:List[@"nav"]];
            //滚动通知
            [self->_titleArray addObjectsFromArray:List[@"news"]];
            //中间广告
            [self->_advArray addObject:List[@"ads"]];
            
            self->_locationAndTemperature = List[@"wendu"];
            
            self.navigationItem.leftBarButtonItem = self.leftItem;

            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self reloadData];
        });
        
        [self->_homeTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}

-(void)registercell
{
    
    
    UINib* nib = [UINib nibWithNibName:@"HZDSHomeTableViewCell" bundle:nil];
    [_homeTableView registerNib:nib forCellReuseIdentifier:@"HomeTableViewCell"];
    
    
    
    UINib* nib1 = [UINib nibWithNibName:@"HZDSClassTableViewCell" bundle:nil];
    [_homeTableView registerNib:nib1 forCellReuseIdentifier:@"ClassTableViewCell"];
    
    
    
    UINib* nib2 = [UINib nibWithNibName:@"HZDSImageTableViewCell" bundle:nil];
    [_homeTableView registerNib:nib2 forCellReuseIdentifier:@"ImageTableViewCell"];
    
    
    self.homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
}
#pragma mark PRIVATE

-(UIImageView*)searchImage
{
    if (_searchImage == nil) {
        _searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 30)];
        _searchImage.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
        UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(8,8,14,14)];
      //  ima.image = [UIImage imageNamed:@"searchIma"];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20,0,100, 30)];
        
        label.text = @"你想要的...";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentLeft;
        // label.backgroundColor = [UIColor redColor];
        [_searchImage addSubview:label];
        
        _searchImage.layer.cornerRadius = _searchImage.frame.size.height/2;
        _searchImage.userInteractionEnabled = YES;
       // [_searchImage addSubview:self.searchTextField];
        [_searchImage addSubview:ima];
        
        UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(0, 0,self.searchImage.frame.size.width,self.searchImage.frame.size.height)];
        
        [rightBtn setTitle:@"" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn setTitleColor:[UIColor colorWithHexString:@"#949494"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(touchsearch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchImage addSubview:rightBtn];
        
    }
    return  _searchImage;
}
-(UIBarButtonItem*)leftItem
{
    if (_leftItem == nil) {
        
        
        
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];;
        [button setFrame:CGRectMake(0, 0, 100, 30)];
      //  [button addTarget:self action:@selector(touchCityList:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
       // [button setBackgroundImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@℃ | 大同",_locationAndTemperature] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = button.frame.size.height/2;

        button.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
        UIView *leftCustomView = [[UIView alloc] initWithFrame: button.frame];

        [leftCustomView addSubview:button];
        
        _leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftCustomView];
    }
    return _leftItem;
}
-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];;
        [button setFrame:CGRectMake(0, 5, 25, 25)];
        [button addTarget:self action:@selector(touchScan:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
         [button setBackgroundImage:[UIImage imageNamed:@"addbtn"] forState:UIControlStateNormal];
      //  [button setTitle:@"+" forState:UIControlStateNormal];
        
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _rightItem;
}
-(UIView*)headView
{
    if (_headView == nil) {
        _headView = [[scrollPhotos alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        _headView.delegate = self;
        
     //   HomeModel *model = [[HomeModel alloc] init];

        
        _headView.photos = _bannerArray;
        
        // [_headView addSubview:self.searchImage];
    }
    
    
    return _headView;
}
-(DCCycleScrollView *)scrollImageView
{
    
    if (_scrollImageView == nil) {
        
        
     //   [_scrollViewSource addObjectsFromArray:_hotShopArray];
        
        _scrollImageView = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 30, SCREEN_WIDTH,(SCREEN_WIDTH - 100)/2) shouldInfiniteLoop:YES imageGroups:_hotShopArray];
        //    banner.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
        //    banner.cellPlaceholderImage = [UIImage imageNamed:@"placeholderImage"];
        _scrollImageView.backgroundColor = [UIColor whiteColor];
        _scrollImageView.autoScrollTimeInterval = 5;
        _scrollImageView.autoScroll = YES;
        _scrollImageView.isZoom = YES;
        _scrollImageView.itemSpace = 0;
        _scrollImageView.imgCornerRadius = self.view.frame.size.width/40;
        _scrollImageView.itemWidth = self.view.frame.size.width - 100;
        _scrollImageView.delegate = self;
    }
    
    
    return _scrollImageView;
}
-(void)touchCityList:(UIButton *)sender
{
    HZDSCityListViewController *city  = [[HZDSCityListViewController alloc] init];
    
    city.delegate = self;
    
    [self.navigationController pushViewController:city animated:YES];
}
-(void)touchsearch:(UIButton *)sender
{
    HZDSSearchViewController *search = [[HZDSSearchViewController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
    
}
-(void)touchScan:(UIButton *) sender
{
    SWQRCodeConfig *config = [[SWQRCodeConfig alloc]init];
    config.scannerType = SWScannerTypeBoth;
    
    SWQRCodeViewController *qrcodeVC = [[SWQRCodeViewController alloc]init];
    qrcodeVC.codeConfig = config;
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return _classArray.count/5;
    }else if (section == 1){
        
        return _advArray.count;
    }
    
    return _shopArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH,30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,30)];
    
    label.font = [UIFont systemFontOfSize:14];
   
    label.backgroundColor = [UIColor whiteColor];

    if (_titleArray.count > 0) {
        
        label.text = _titleArray[0][@"title"];
        
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    
    if (section == 0) {
        
    }else if (section == 1){
     
        label.text = @"热门商家";
        
        
        if (_hotShopArray.count > 0) {
            
            view.frame  = CGRectMake(0,0 , SCREEN_WIDTH,(SCREEN_WIDTH - 100)/2 + 40);

            [view addSubview:self.scrollImageView];
        }
        
        
    }else{

        
       
        label.text = @"附近商家";
        
    
    }
    return view;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        HZDSClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ClassTableViewCell" forIndexPath:indexPath];

        cell.delegate = self;
        
        [cell setClassArray:_classArray];
        
        return cell;
    }else if (indexPath.section == 1){
      
        HZDSImageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell" forIndexPath:indexPath];

        NSDictionary *dic = _advArray[indexPath.row][indexPath.row];
        
        
        [cell.advImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"photo"]]]];
        
        return cell;
    }
    
    HZDSHomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    
    //    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:@"http://115.28.133.70/uploads/image/20151009/1444395668.jpg"]];
    
 //   [cell setCarModel:_cartArray[indexPath.row]];
    
    if (_shopArray.count > 0) {
     
        [cell setHomeModel:_shopArray[indexPath.row]];

    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (indexPath.section == 2) {
        
        HomeModel *model =[[HomeModel alloc] init];
        
        model = _shopArray[indexPath.row];
        
        HZDSBusinessDetailViewController *detail = [[HZDSBusinessDetailViewController alloc] init];
        
        detail.shopID = model.goodsId;
        [self.navigationController pushViewController:detail animated:YES];
    }else if (indexPath.section == 1){
        
        NSDictionary *dic = _advArray[indexPath.row][indexPath.row];

        HZDSLinkWebViewController *web = [[HZDSLinkWebViewController alloc] init];
        
        web.adv_id = dic[@"val"];

        
        [self.navigationController pushViewController:web animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return _classArray.count/5*75;
        
    }else if (indexPath.section == 2){
        
        return 164;
    }else{
       
        HomeModel *model;
        if (_shopArray.count > 0) {
            
            model = _shopArray[indexPath.row];
            
            return model.cellHeight;
        }
        
     
        return 103;

    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 30;
    }else if (section == 1){
        
        if (_hotShopArray.count > 0) {
         
            return (SCREEN_WIDTH - 100)/2 + 40;

        }else{
            
            return 30;
        }
        
    }
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)reloadData
{
    self.homeTableView.tableHeaderView = self.headView;
  //  self.tableView.tableFooterView = self.footerView;
    [_homeTableView reloadData];
    
}
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    NSLog(@"index = %ld",index);
    
    HZDSBusinessDetailViewController *detail = [[HZDSBusinessDetailViewController alloc] init];
    
    detail.shopID = _hotShopArray[index][@"shop_id"];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}
-(void)buttonSleected:(NSString *)buttonTitle buttonID:(NSString *)buttonId
{
    HZDSBusinessViewController *business = [[HZDSBusinessViewController alloc] init];
 
    business.classIDString = buttonId;
    
    business.classNameString = buttonTitle;
    
    business.isRootNav = YES;
    
    [self.navigationController pushViewController:business animated:YES];
}
-(void)citySleected:(NSString *)lngString withcouponlat:(NSString *)latString
{
    
    [self initData:lngString withcouponlat:latString];
    
}
-(void)initData :(NSString *)lngString withcouponlat:(NSString *)latString
{
    NSDictionary *dict = @{@"lat":latString,@"lng":lngString};
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,HOMEINFO] parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"首页", dic);
        
        [self->_shopArray removeAllObjects];
        [self->_hotShopArray removeAllObjects];
        [self->_classArray removeAllObjects];
        [self->_bannerArray removeAllObjects];
        [self->_titleArray removeAllObjects];
        [self->_advArray removeAllObjects];
        
        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            NSDictionary* List = dic[@"datas"];
            
            
            for (NSDictionary *dictlist in List[@"ele"]) {
                
                HomeModel *model = [[HomeModel alloc] init];
                
                model.goodsName = dictlist[@"shop_name"];
                
                model.goodsIcon = dictlist[@"photo"];
                
                model.distance = dictlist[@"d"];
                
                model.goodsId = dictlist[@"shop_id"];
                
                [model.tagArray addObjectsFromArray:dictlist[@"tags"]];
                
                
                [self->_shopArray addObject:model];
            }
            
            
            [self->_bannerArray addObjectsFromArray:List[@"slide"]];
            
            [self->_hotShopArray addObjectsFromArray:List[@"hot_shop"]];
            
            [self->_classArray addObjectsFromArray:List[@"nav"]];
            
            [self->_titleArray addObjectsFromArray:List[@"news"]];
            
            [self->_advArray addObject:List[@"ads"]];
            
            self->_locationAndTemperature = List[@"wendu"];
            
            self.navigationItem.leftBarButtonItem = self.leftItem;
            
            
            [self reloadData];
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        [self initData];
    });
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
