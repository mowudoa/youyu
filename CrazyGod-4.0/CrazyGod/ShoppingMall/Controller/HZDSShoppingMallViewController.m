//
//  HZDSShoppingMallViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/18.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSShoppingMallViewController.h"
#import "HZDSgoodGoodsCollectionViewCell.h"
#import "HZDSMallClassCollectionViewCell.h"
#import "HZDSlikeGoodsCollectionViewCell.h"
#import "HZDSShopMallListViewController.h"
#import "HZDSShopMallListViewController.h"
#import "HZDSHotGoodsCollectionViewCell.h"
#import "HZDSMallDetailViewController.h"
#import "scrollPhotos.h"
#import "HomeModel.h"

@interface HZDSShoppingMallViewController ()<
UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *shoppingMallCollectionView;

@property(strong,nonatomic)UIView* searchView;

@property(strong,nonatomic)UITextField* searchTextField;

//分类
@property(nonatomic,strong) NSMutableArray *classArray;
//热门商家
@property(nonatomic,strong) NSMutableArray *hotListArray;
//轮播图
@property(nonatomic,strong) NSMutableArray *advArray;
//新人专区
@property(nonatomic,strong) NSMutableArray *userGoodsArray;

@property(nonatomic,strong) NSMutableArray *userGoodsArray2;
//优选好物
@property(nonatomic,strong) NSMutableArray *goodArray;
//猜你喜欢
@property(nonatomic,strong) NSMutableArray *likeArray;

@property(nonatomic,strong)scrollPhotos* headView;

@property (strong, nonatomic) IBOutlet UIView *userView;

@property (weak, nonatomic) IBOutlet UIButton *userLeftButton;

@property (weak, nonatomic) IBOutlet UIButton *userRightButton1;

@property (weak, nonatomic) IBOutlet UIButton *userRightButton2;

@property (strong, nonatomic) IBOutlet UIView *likeHeaderView;

@property (strong, nonatomic) IBOutlet UIView *goodHeaderView;

@property (strong, nonatomic) IBOutlet UIView *hotHeaderView;

@end

@implementation HZDSShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self registeCell];
    
    [self initData];
    
}
-(void)initUI
{
    
    self.navigationItem.titleView = self.searchView;
    
    _classArray = [[NSMutableArray alloc] init];
    
    _advArray = [[NSMutableArray alloc] init];
    
    _hotListArray = [[NSMutableArray alloc] init];
    
    _userGoodsArray = [[NSMutableArray alloc] init];
    
    _userGoodsArray2 = [[NSMutableArray alloc] init];
    
    _goodArray = [[NSMutableArray alloc] init];
    
    _likeArray = [[NSMutableArray alloc] init];

    self.shoppingMallCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self initData];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchMallGoodsByKeyWords:) name:@"searchMallGoods" object:nil];

}
-(void)registeCell
{
    
    UINib* cate = [UINib nibWithNibName:@"HZDSMallClassCollectionViewCell" bundle:nil];
    
    [_shoppingMallCollectionView registerNib:cate forCellWithReuseIdentifier:@"ClassCollectionViewCell"];
    
    UINib* cate1 = [UINib nibWithNibName:@"HZDSHotGoodsCollectionViewCell" bundle:nil];
    
    [_shoppingMallCollectionView registerNib:cate1 forCellWithReuseIdentifier:@"HotGoodsCollectionViewCell"];
    
    UINib* cate2 = [UINib nibWithNibName:@"HZDSgoodGoodsCollectionViewCell" bundle:nil];
    
    [_shoppingMallCollectionView registerNib:cate2 forCellWithReuseIdentifier:@"goodGoodsCollectionViewCell"];
    
    UINib* cate3 = [UINib nibWithNibName:@"HZDSlikeGoodsCollectionViewCell" bundle:nil];
    
    [_shoppingMallCollectionView registerNib:cate3 forCellWithReuseIdentifier:@"likeGoodsCollectionViewCell"];
    
    [_shoppingMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_shoppingMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2"];
    
    [_shoppingMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header3"];
    
      [_shoppingMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header4"];
    
    [_shoppingMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header5"];

    [_shoppingMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.shoppingMallCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [JKToast showWithText:NOMOREDATA_STRING];
        
        [self.shoppingMallCollectionView.mj_footer endRefreshingWithNoMoreData];
        
    }];
    
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;

    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL] parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商城", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf.classArray removeAllObjects];
        
        [strongSelf.advArray removeAllObjects];
        
        [strongSelf.hotListArray removeAllObjects];
        
        [strongSelf.userGoodsArray removeAllObjects];
        
        [strongSelf.userGoodsArray2 removeAllObjects];
        
        [strongSelf.likeArray removeAllObjects];
        
        [strongSelf.goodArray removeAllObjects];

        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            NSDictionary* List = dic[@"datas"];
            
            //猜你喜欢
            for (NSDictionary *dictlist in List[@"goods2"]) {
                
                HomeModel *model = [[HomeModel alloc] init];
                
                model.goodsName = dictlist[@"title"];
                
                model.goodsIcon = dictlist[@"photo"];
                
                model.goodsSoldNum = dictlist[@"sold_num"];
                
                model.goodsId = dictlist[@"goods_id"];
                
                model.goodsPrice = [dictlist[@"mall_price"] stringValue];
                
                [strongSelf.likeArray addObject:model];
            }
            
            //优选好物
            for (NSDictionary *dictlist in List[@"goods"]) {
                
                HomeModel *model = [[HomeModel alloc] init];
                
                model.goodsName = dictlist[@"title"];
                
                model.goodsIcon = dictlist[@"photo"];
                
                model.goodsId = dictlist[@"goods_id"];
                
                [strongSelf.goodArray addObject:model];
            }
            
            //轮播
            [strongSelf.advArray addObjectsFromArray:List[@"adList"]];
            //热门
            [strongSelf.hotListArray addObjectsFromArray:List[@"hostList"]];
            //分类
            [strongSelf.classArray addObjectsFromArray:List[@"goodscates"]];
            //新人专区左半边
            [strongSelf.userGoodsArray addObjectsFromArray:List[@"fuliList"]];
            //新人专区右半边
            [strongSelf.userGoodsArray2 addObjectsFromArray:List[@"zhxList"]];
            
            [self headView];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
        [self reloadData];
        
        [strongSelf.shoppingMallCollectionView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}
#pragma mark PRIVATE

//轮播
-(UIView*)headView
{
    if (_headView == nil) {
        
        _headView = [[scrollPhotos alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        
        _headView.delegate = self;
        
        _headView.photos = _advArray;
        
    }
    
    return _headView;
}
//搜索
-(UIView*)searchView
{
    if (_searchView == nil) {
        
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 30)];
        
        _searchView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
        UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.8 -30,8,14,14)];
        
        ima.image = [UIImage imageNamed:@"searchIma"];
        
        _searchView.layer.cornerRadius = _searchView.frame.size.height/2;
        
        _searchView.userInteractionEnabled = YES;
        
        [_searchView addSubview:self.searchTextField];
        
        [_searchView addSubview:ima];
        
    }
    
    return  _searchView;
}
-(UITextField*)searchTextField
{
    if (_searchTextField == nil) {
        
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH * 0.75 - 20, 30)];
        
        _searchTextField.placeholder = @"你想要的...";
        
        [_searchTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        _searchTextField.borderStyle = UITextBorderStyleNone;
        
        _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        _searchTextField.font = [UIFont systemFontOfSize:12];
        
        _searchTextField.delegate = self;
        
        _searchTextField.tag = 70001;
        
        _searchTextField.textColor = [UIColor lightGrayColor];
        
        _searchTextField.tintColor = [UIColor colorWithHexString:@"#1571fb"];
        
    }
    
    return _searchTextField;
}

#pragma mark - UITextFieldDelegate

//开始编辑时,清空原有的搜索内容
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 5;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return _classArray.count;
        
    }else if (section == 1){
        
        return _hotListArray.count;
        
    }else if (section == 2){
        
        return 0;
        
    }else if (section == 3){
        
        return _goodArray.count;
        
    }else{
        
        return _likeArray.count;
        
    }
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //section 0:分类 1:热门 2:新人 3:优选好物 4:猜你喜欢

    if (indexPath.section == 0) {
        
        HZDSMallClassCollectionViewCell *cell  =[collectionView dequeueReusableCellWithReuseIdentifier:@"ClassCollectionViewCell" forIndexPath:indexPath];
        
        [cell.classIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_classArray[indexPath.row][@"photo"]]]];
        
        cell.classTitle.text = _classArray[indexPath.row][@"cate_name"];
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        HZDSHotGoodsCollectionViewCell *cell  =[collectionView dequeueReusableCellWithReuseIdentifier:@"HotGoodsCollectionViewCell" forIndexPath:indexPath];
        
        [cell.hotImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_hotListArray[indexPath.row][@"photo"]]]];
        
        return cell;
        
    }else if (indexPath.section == 3){
        
        HZDSgoodGoodsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodGoodsCollectionViewCell" forIndexPath:indexPath];
        
        HomeModel *model = _goodArray[indexPath.row];
        
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.goodsIcon]]];
        
        cell.titleLabel.text = model.goodsName;
        
        return cell;
        
    }else{
        
        HZDSlikeGoodsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"likeGoodsCollectionViewCell" forIndexPath:indexPath];
        
        HomeModel *model = _likeArray[indexPath.row];
        
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.goodsIcon]]];
       
        cell.titleLabel.text = model.goodsName;
        
        cell.goodsInfo.text = [NSString stringWithFormat:@"已售:%@",model.goodsSoldNum];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥:%@",model.goodsPrice];
        
        return cell;
        
    }
    
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
      
        HZDSShopMallListViewController *list = [[HZDSShopMallListViewController alloc] init];
        
        list.classNameString = _classArray[indexPath.row][@"cate_name"];
        
        list.classIDString = _classArray[indexPath.row][@"cate_id"];

        [self.navigationController pushViewController:list animated:YES];
        
    }else if (indexPath.section == 1){
        
        HZDSMallDetailViewController *detail = [[HZDSMallDetailViewController alloc] init];
        
        detail.goodsId = _hotListArray[indexPath.row][@"val"];
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (indexPath.section == 2){
        
        
    }else if (indexPath.section == 3){
      
        HomeModel *model = _goodArray[indexPath.row];
        
        HZDSMallDetailViewController *detail = [[HZDSMallDetailViewController alloc] init];
        
        detail.goodsId = model.goodsId;
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
     
        HomeModel *model = _likeArray[indexPath.row];

        HZDSMallDetailViewController *detail = [[HZDSMallDetailViewController alloc] init];
       
        detail.goodsId = model.goodsId;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
    
        if (indexPath.section == 0) {
            
            UICollectionReusableView* reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/2+ 10)];
            
            view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            
            if (_advArray.count > 0) {
                
                [view addSubview:self.headView];
                
                [reusable addSubview:view];
                
            }
            
            return reusable;
            
        }else if (indexPath.section == 2){
            
            UICollectionReusableView* reusable3 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header3" forIndexPath:indexPath];
            
            _userView.frame = CGRectMake(0,0,SCREEN_WIDTH,(SCREEN_WIDTH - 60)/2+50);
            
            [reusable3 addSubview:self.userView];
            
            return reusable3;
            
        }else if (indexPath.section == 1){
            
            UICollectionReusableView* reusable2 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2" forIndexPath:indexPath];
            
            _hotHeaderView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/10);
            
            [reusable2 addSubview:_hotHeaderView];
            
            return  reusable2;
            
        }else if (indexPath.section == 3){
            
            UICollectionReusableView* reusable4 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header4" forIndexPath:indexPath];
            
            _goodHeaderView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/10);
            
            [reusable4 addSubview:_goodHeaderView];
            
            return reusable4;
            
        }else{
            
            UICollectionReusableView* reusable5 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header5" forIndexPath:indexPath];
            
            _likeHeaderView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/10 + 30);
            
            [reusable5 addSubview:_likeHeaderView];
            
            return reusable5;
        }
        
    }else{
     
        UICollectionReusableView* reusableFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        [reusableFooter addSubview:[self createheadSubView2]];
        
        return reusableFooter;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(_shoppingMallCollectionView.width, SCREEN_WIDTH/2 + 5);
        
    }else if (section == 2){
        
        return CGSizeMake(_shoppingMallCollectionView.width,(SCREEN_WIDTH - 60)/2+50);
        
    }else if (section == 4){
     
        return CGSizeMake(_shoppingMallCollectionView.width,SCREEN_WIDTH/10 + 30 +1);

    }else{
        
        return CGSizeMake(_shoppingMallCollectionView.width,SCREEN_WIDTH/10+1);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    return CGSizeMake(_shoppingMallCollectionView.width,10);

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 0, 2);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return CGSizeMake((_shoppingMallCollectionView.width - 20)/5 - 2, (_shoppingMallCollectionView.width - 20)/5 - 2);
        
    }else if (indexPath.section == 1){
        
        return CGSizeMake((_shoppingMallCollectionView.width-10)/2-2, ((_shoppingMallCollectionView.width-10)/2-2)*0.8);
        
    }else if (indexPath.section == 4){
        
        return CGSizeMake((_shoppingMallCollectionView.width-10)/2-2, ((_shoppingMallCollectionView.width-10)/2-2) + 90);
        
    }else{
        
        return CGSizeMake((_shoppingMallCollectionView.width-20)/3 -2, ((_shoppingMallCollectionView.width-20)/3 - 2) + 41);

    }
    
}
//新人专区加载
-(void)reloadData
{
    if (_userGoodsArray.count > 0) {
    
          [_userLeftButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_userGoodsArray[0][@"photo"]]] forState:UIControlStateNormal];
    }
    
    if (_userGoodsArray2.count > 0) {
        
        for (int i = 0; i < _userGoodsArray2.count; i ++) {
            
            if (i == 0) {
            
                [_userRightButton1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_userGoodsArray2[i][@"photo"]]] forState:UIControlStateNormal];

            }else if (i == 1){
                
                [_userRightButton2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,_userGoodsArray2[i][@"photo"]]] forState:UIControlStateNormal];

            }
            
        }
        
    }
    
    [_shoppingMallCollectionView reloadData];
    
}

//collectview尾部留空
-(UIView *)createheadSubView2
{
    UIView * headSubView2 = [[UIView alloc] initWithFrame:CGRectMake(0 ,0, SCREEN_WIDTH,10)];
    
    headSubView2.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    headSubView2.userInteractionEnabled = YES;
    
    return headSubView2;
}
//新人专区
- (IBAction)clickBton:(UIButton *)sender {

    HZDSMallDetailViewController *detail = [[HZDSMallDetailViewController alloc] init];
    
    if (sender.tag == 600) {
    
        if (_userGoodsArray.count > 0) {
            
            detail.goodsId = _userGoodsArray[0][@"val"];
        }
        
    }else if (sender.tag == 601){
        
        detail.goodsId = _userGoodsArray2[0][@"val"];

    }else if (sender.tag == 602){
        
        detail.goodsId = _userGoodsArray2[1][@"val"];

    }
    
    [self.navigationController pushViewController:detail animated:YES];

}
//查看更多
- (IBAction)seeMoreGoods:(UIButton *)sender {

    HZDSShopMallListViewController *list = [[HZDSShopMallListViewController alloc] init];
    
    [self.navigationController pushViewController:list animated:YES];
}
//关键字搜索
- (void)searchMallGoodsByKeyWords:(NSNotification *)notification{
    
//    if ([self.searchTextField.text isEqualToString:@""] ||[self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 ) {
//
//    }else{
    
        [self gosearchByKeyWord:self.searchTextField.text];
        
//    }
    
}
-(void)gosearchByKeyWord:(NSString *)keyWords
{
    HZDSShopMallListViewController *mall = [[HZDSShopMallListViewController alloc] init];
    
    mall.keyWordString = keyWords;
    
    [self.navigationController pushViewController:mall animated:YES];
    
    _searchTextField.text = @"";
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
