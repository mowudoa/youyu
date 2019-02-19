//
//  HZDSBusinessDetailViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/5.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSBusinessDetailViewController.h"
#import "HZDSbusinessGoodsCollectionViewCell.h"
#import "HZDGoodsDetailSViewController.h"
#import "HZDSBusinessModel.h"


@interface HZDSBusinessDetailViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
    
    NSMutableArray *_tableSource;

    NSMutableArray *_tagsArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *businessCollectionView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIImageView *businessIcon;
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UILabel *businessEvaluate;
@property (weak, nonatomic) IBOutlet UILabel *businessSale;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *advTitleLabel;

@end

@implementation HZDSBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableSource = [[NSMutableArray alloc] init];
    
    _tagsArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"商家信息";
    
    [self registeCell];

    [self initData];
}
-(void)registeCell
{
    
    UINib* cate = [UINib nibWithNibName:@"HZDSbusinessGoodsCollectionViewCell" bundle:nil];
    [_businessCollectionView registerNib:cate forCellWithReuseIdentifier:@"GoodsCollectionViewCell"];
    
    
    [_businessCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_businessCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2"];


}
-(void)initData
{
    NSDictionary* dic = @{@"shop_id":_shopID};

    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,BUSINESSDETAIL] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"首页", dic);
        
        
        [self->_tableSource removeAllObjects];
        
        [self->_tagsArray removeAllObjects];
        
        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            NSDictionary* List = dic[@"datas"];
            
            self->_businessName.text = List[@"detail"][@"shop_name"];
            
            [self->_businessIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,List[@"detail"][@"photo"]]]];
            
            [self->_titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,List[@"detail"][@"dianzhao"]]]];

            
            self->_businessSale.text = [NSString stringWithFormat:@"月售:%@",List[@"detail"][@"yueshou"]];
            
            self->_businessEvaluate.text = [NSString stringWithFormat:@"%@分",List[@"detail"][@"pingjiafen"]];
            self->_phoneLabel.text = List[@"detail"][@"tel"];
            
            self->_locationLabel.text = List[@"detail"][@"addr"];

            self->_advTitleLabel.text = List[@"ad"][@"title"];
            
            [self->_tagsArray addObjectsFromArray:List[@"tags"]];
            
            for (int i = 0; i < 2; i ++) {
                
                HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
                
                if (i == 0) {
                    
                    if (List[@"tuans"] == nil || List[@"tuans"] == NULL || List[@"tuans"] == [NSNull null]) {
                      

                    }else{
                     
                        [model.goodsArray addObjectsFromArray:List[@"tuans"]];

                    }
                    
                    
                }else{
                    
                    if (List[@"tuandpzs"] == nil || List[@"tuandpzs"] == NULL || List[@"tuandpzs"] == [NSNull null]) {
                      
                    }else{
                        
                        [model.goodsArray addObjectsFromArray:List[@"tuandpzs"]];

                    }
                    

                }
             
                [self->_tableSource addObject:model];
            }
            
            [self reloadData];
            
        }else{
            
            [JKToast showWithText:dic[@"msg"]];
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return _tableSource.count + 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 0;
    }else{
        
        HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
        
        model = _tableSource[section - 1];
        
        return model.goodsArray.count;
        
    }
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        HZDSbusinessGoodsCollectionViewCell *cell  =[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionViewCell" forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        
    }else{
        
        HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
        
        model = _tableSource[indexPath.section - 1];
        
        cell.goodsInfo.text = model.goodsArray[indexPath.row][@"title"];
        
        cell.goodsPrice.text = [NSString stringWithFormat:@"现价:￥%@",[model.goodsArray[indexPath.row][@"tuan_price"] stringValue]];

        cell.goodsOldPrice.text = [NSString stringWithFormat:@"原价:￥%@",[model.goodsArray[indexPath.row][@"price"] stringValue]];

        cell.goodsPrice.adjustsFontSizeToFitWidth = YES;
        cell.goodsOldPrice.adjustsFontSizeToFitWidth = YES;
        cell.goodsInfo.adjustsFontSizeToFitWidth = YES;
        
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.goodsArray[indexPath.row][@"photo"]]] placeholderImage:[UIImage imageNamed:@"baseImage.png"]];

    }
    
        
        
        return cell;
    
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }else{
        
        HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
        
        model = _tableSource[indexPath.section - 1];
        
        HZDGoodsDetailSViewController *good = [[HZDGoodsDetailSViewController alloc] init];
        
        good.goodsID = model.goodsArray[indexPath.row][@"tuan_id"];
        
        if (indexPath.section == 1) {
           
            good.isHotGoods = YES;
        }else{
            
            good.isHotGoods = NO;
        }
        
        
        [self.navigationController pushViewController:good animated:YES];
    }
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        UICollectionReusableView* reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
       
        self.headerView.frame = CGRectMake(0,0,SCREEN_WIDTH,400);
        
        [reusable addSubview:self.headerView];
        
        return reusable;
        
    }else{
        
        UICollectionReusableView* reusable2 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2" forIndexPath:indexPath];
        
        UIView *viewq = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
        
        viewq.backgroundColor = [UIColor redColor];
        
        [reusable2 addSubview:[self createheader2ViewWithSection:indexPath.section]];
        
        return  reusable2;
        
        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(_businessCollectionView.frame.size.width,400);
        
    }else if (section == 1){
        
        return CGSizeMake(_businessCollectionView.frame.size.width,SCREEN_WIDTH/10);
        
    }else{
        
        return CGSizeMake(_businessCollectionView.frame.size.width,SCREEN_WIDTH/10+1);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 0, 2);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        
        return CGSizeMake(0, 0);
        
    }else{
        
        return CGSizeMake((_businessCollectionView.frame.size.width-20)/3 -2, ((_businessCollectionView.frame.size.width-20)/3 - 2) + 75);
        
    }
    
}
-(UIView*)createheader2ViewWithSection:(NSInteger)section
{
    UIView * subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_WIDTH/10)];
    //    headSubView2.backgroundColor = [UIColor colorWithHexString:@"#EA494E"];
    subTitleView.alpha = 0.8;
    subTitleView.userInteractionEnabled = YES;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-35, 0, 70, SCREEN_WIDTH/10)];
    
    if (section == 1) {
        
        label.text = @"活动专区";

    }else if (section == 2){
        
        label.text = @"商家推荐";

    }
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    //    label.backgroundColor = [UIColor redColor];
    [subTitleView addSubview:label];
    
    return subTitleView;
}
-(void)reloadData
{
    _businessIcon.layer.cornerRadius = _businessIcon.frame.size.height/2;
    _businessIcon.layer.masksToBounds = YES;
    
    [WYFTools createTagLabel:[UIFont systemFontOfSize:12] tagArray:_tagsArray itemSpace:2 itemHeight:20 currentX:0 currentY:0 superView:_tagsView];
    
    [self.businessCollectionView reloadData];
    
}
- (IBAction)callPhone:(UIButton *)sender {

    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
