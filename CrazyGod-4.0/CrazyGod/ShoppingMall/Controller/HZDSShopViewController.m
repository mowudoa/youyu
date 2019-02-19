//
//  HZDSShopViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/26.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSShopViewController.h"
#import "HZDSlikeGoodsCollectionViewCell.h"
#import "HZDSMallDetailViewController.h"
#import "HomeModel.h"

@interface HZDSShopViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *shopGoodsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitle;
@property (weak, nonatomic) IBOutlet UILabel *followNum;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImage;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,strong) NSMutableArray *goodsHomeDataSource;

@property(nonatomic,strong) NSMutableArray *goodsHotDataSource;

@property(nonatomic,strong) NSMutableArray *goodsNewDataSource;

@property(nonatomic,strong) NSMutableArray *goodsDataSource;

@end

@implementation HZDSShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self registeCell];
    
    [self initData];
}
-(void)initUI
{
    _goodsDataSource = [[NSMutableArray alloc] init];
    
    _goodsHotDataSource = [[NSMutableArray alloc] init];
    
    _goodsNewDataSource = [[NSMutableArray alloc] init];
    
    _goodsHomeDataSource = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"店铺详情";
 
    
    _lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,169,SCREEN_WIDTH/8,2)];
    _lineLabel.backgroundColor=[UIColor colorWithHexString:@"#FF0270"];
    
    _lineLabel.centerX = SCREEN_WIDTH/8;
    
    [self.view addSubview:_lineLabel];
    
    _followButton.layer.cornerRadius = 10;
    
    _followButton.layer.masksToBounds = YES;
}
-(void)registeCell
{
    
    UINib* cate = [UINib nibWithNibName:@"HZDSlikeGoodsCollectionViewCell" bundle:nil];
    [_shopGoodsCollectionView registerNib:cate forCellWithReuseIdentifier:@"likeGoodsCollectionViewCell"];
    
    
    
    self.shopGoodsCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [JKToast showWithText:@"没有更多了"];
        [self.shopGoodsCollectionView.mj_footer endRefreshing];
        
    }];
}
-(void)initData
{
  
    __weak typeof(self) weakSelf = self;
    
    NSDictionary* dic = @{@"shop_id":_shop_id};
    
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOP_DETAIL] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"店铺", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.goodsHomeDataSource removeAllObjects];
        [strongSelf.goodsNewDataSource removeAllObjects];
        [strongSelf.goodsHotDataSource removeAllObjects];
        [strongSelf.goodsDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSDictionary *dict = dic[@"datas"];
            
            NSArray *weidianArr = dict[@"weidian"];
            
            strongSelf.shopTitle.text = weidianArr[0][@"weidian_name"];
            
            strongSelf.followNum.text = [NSString stringWithFormat:@"已有%@人关注",dict[@"favnum"]];
            
            [strongSelf.shopIconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,weidianArr[0][@"logo"]]]];

            
            
            if (dict[@"goods"] == NULL || dict[@"goods"] == nil ||dict[@"goods"] == [NSNull null]) {
                
                
            }else{
               
                
                NSArray *arr = dict[@"goods"];
                
              
                for (NSDictionary *dictlist in arr) {
                    
                    HomeModel *model = [[HomeModel alloc] init];
                    
                    model.goodsName = dictlist[@"title"];
                    
                    model.goodsIcon = dictlist[@"photo"];
                    
                    model.goodsSoldNum = dictlist[@"sold_num"];
                    
                    model.goodsId = dictlist[@"goods_id"];
                    
                    model.goodsPrice = [dictlist[@"mall_price"] stringValue];
                    
                    
                    [strongSelf.goodsHomeDataSource addObject:model];
                }
                
                
                
            }
            if (dict[@"goods_rx"] == NULL || dict[@"goods_rx"] == nil ||dict[@"goods_rx"] == [NSNull null]) {
                
                
            }else{
             
                NSArray *arr = dict[@"goods_rx"];
                
                
                for (NSDictionary *dictlist in arr) {
                    
                    HomeModel *model = [[HomeModel alloc] init];
                    
                    model.goodsName = dictlist[@"title"];
                    
                    model.goodsIcon = dictlist[@"photo"];
                    
                    model.goodsSoldNum = dictlist[@"sold_num"];
                    
                    model.goodsId = dictlist[@"goods_id"];
                    
                    model.goodsPrice = [dictlist[@"mall_price"] stringValue];
                    
                    
                    [strongSelf.goodsHotDataSource addObject:model];
                }
                
            }
            if (dict[@"goods_sx"] == NULL || dict[@"goods_sx"] == nil ||dict[@"goods_sx"] == [NSNull null]) {
                
                
            }else{
                
                NSArray *arr = dict[@"goods_sx"];
                
                
                for (NSDictionary *dictlist in arr) {
                    
                    HomeModel *model = [[HomeModel alloc] init];
                    
                    model.goodsName = dictlist[@"title"];
                    
                    model.goodsIcon = dictlist[@"photo"];
                    
                    model.goodsSoldNum = dictlist[@"sold_num"];
                    
                    model.goodsId = dictlist[@"goods_id"];
                    
                    model.goodsPrice = [dictlist[@"mall_price"] stringValue];
                    
                    
                    [strongSelf.goodsNewDataSource addObject:model];
                }
            }
            
            
            if (dict[@"shop_favorites"] == NULL || dict[@"shop_favorites"] == nil ||dict[@"shop_favorites"] == [NSNull null]) {
                
                [strongSelf.followButton setTitle:@"关注" forState:UIControlStateNormal];
                
            }else{
                
                [strongSelf.followButton setTitle:@"已关注" forState:UIControlStateNormal];

            }
            
            
        }else{
            
            
        }
        
        [strongSelf.goodsDataSource addObjectsFromArray:strongSelf.goodsHomeDataSource];
        
        [self reloadData];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];

    
}
#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return _goodsDataSource.count;
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        
    HZDSlikeGoodsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"likeGoodsCollectionViewCell" forIndexPath:indexPath];
        
        
        HomeModel *model = _goodsDataSource[indexPath.row];
        
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.goodsIcon]]];
        cell.titleLabel.text = model.goodsName;
        
        cell.goodsInfo.text = [NSString stringWithFormat:@"已售:%@",model.goodsSoldNum];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥:%@",model.goodsPrice];
    
        return cell;
    
    
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        
        HomeModel *model = _goodsDataSource[indexPath.row];
        
        HZDSMallDetailViewController *detail = [[HZDSMallDetailViewController alloc] init];
        detail.goodsId = model.goodsId;
        
        [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 0, 2);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        
    return CGSizeMake((_shopGoodsCollectionView.frame.size.width-10)/2-2, ((_shopGoodsCollectionView.frame.size.width-10)/2-2) + 90);
        

    
}

-(void)reloadData
{
    
    if (_goodsDataSource.count > 0) {
        
        _backGroundView.hidden = YES;
        
        _shopGoodsCollectionView.hidden = NO;
        
    }else{
        
        _backGroundView.hidden = NO;
        
        _shopGoodsCollectionView.hidden = YES;

    }
    
    [_shopGoodsCollectionView reloadData];
    
    
}
-(void)moveLineLabel:(NSInteger)index
{
    [_goodsDataSource removeAllObjects];
    
    switch (index) {
        case 0:
            
            [_goodsDataSource addObjectsFromArray:_goodsHomeDataSource];
            
            break;
        case 1:
            
            [_goodsDataSource addObjectsFromArray:_goodsHomeDataSource];

            break;
        case 2:
            [_goodsDataSource addObjectsFromArray:_goodsHotDataSource];

            break;
        case 3:
            [_goodsDataSource addObjectsFromArray:_goodsNewDataSource];
            
            break;
        default:
            break;
    }
    
    __block CGRect lineFrame  = CGRectMake(_lineLabel.frame.origin.x,_lineLabel.frame.origin.y,SCREEN_WIDTH/8, _lineLabel.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self->_lineLabel.frame = lineFrame;
        
        self->_lineLabel.centerX = (index * 2 + 1) * SCREEN_WIDTH / 8;
    }];
    
    [self reloadData];
}
- (IBAction)followShop:(UIButton *)sender {

   
    NSDictionary *dic = @{@"shop_id":_shop_id                         };
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:SHOP_FOLLOW parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"店铺收藏", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            [strongSelf.followButton setTitle:@"已关注" forState:UIControlStateNormal];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];

}
- (IBAction)shopGoodsType:(UIButton *)sender {

    NSInteger num = sender.tag - 400;
    
    [self moveLineLabel:num];
    
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
