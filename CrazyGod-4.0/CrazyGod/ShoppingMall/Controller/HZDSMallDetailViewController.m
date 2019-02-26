//
//  HZDSMallDetailViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/21.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMallDetailViewController.h"
#import "HZDSShopCartViewController.h"
#import "HZDSShopViewController.h"
#import "HZDSShopOrderViewController.h"
#import "HZDSLoginViewController.h"
#import "HZDSMallEvaluateListViewController.h"
#import "scrollPhotos.h"

@interface HZDSMallDetailViewController ()
{
    NSInteger num;

}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldNumPrice;
@property (weak, nonatomic) IBOutlet UILabel *collectNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockNunLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIView *goodsInfoDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;

@property (weak, nonatomic) IBOutlet UILabel *evaluateNumLabel;
@property(nonatomic,strong)scrollPhotos* headScrollView;

@property(nonatomic,copy) NSString *goodsInfo;

@property(nonatomic,copy) NSString *goodsDetail;

@property(nonatomic,copy) NSString *goodsSpec;//规格

@property(nonatomic,copy) NSString *goodsShopID;//店铺id

@property(nonatomic,copy) NSString *goodsID;//商品id

@property(nonatomic,strong) NSMutableArray *headerScrImgArray;

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@end

@implementation HZDSMallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _headerScrImgArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"商品详情";
    
    self.navigationItem.rightBarButtonItem  =self.rightItem;
    
    _numLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    _numLabel.layer.borderWidth = 1;
    
    _numLabel.layer.cornerRadius = 3;
    
    _numLabel.layer.masksToBounds = YES;
    
    _numLabel.text = @"1";
    
}
-(void)initData
{
  
    __weak typeof(self) weakSelf = self;
    
    NSDictionary* dic = @{@"goods_id":_goodsId};

    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_DETAIL] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"产品详情", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        if (SUCCESS) {
            
            NSDictionary *dict = dic[@"datas"];
            
            strongSelf.goodsID = dict[@"detail"][@"goods_id"];
            
            strongSelf.titleLabel.text = dict[@"detail"][@"title"];
            
            strongSelf.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dict[@"detail"][@"mall_price"] stringValue]];

            strongSelf.oldPriceLabel.text = [NSString stringWithFormat:@"原价:￥%@",[dict[@"detail"][@"price"] stringValue]];

            strongSelf.soldNumPrice.text =  [NSString stringWithFormat:@"销量:%@笔",dict[@"detail"][@"sold_num"]];
            
            strongSelf.collectNumLabel.text =  [NSString stringWithFormat:@"收藏人数:%@",dict[@"count_goodsfavorites"]];

            strongSelf.stockNunLabel.text =  [NSString stringWithFormat:@"(库存:%@)",dict[@"detail"][@"num"]];

            strongSelf.goodsInfo = dict[@"detail"][@"instructions"];
            
            strongSelf.goodsDetail = dict[@"detail"][@"details"];
            
            strongSelf.goodsSpec = dict[@"detail"][@"guige"];
            
            [strongSelf.headerScrImgArray addObject:@{@"photo":dict[@"detail"][@"photo"]}];
            
            strongSelf.goodsShopID = dict[@"shop"][@"shop_id"];

            
            
            NSArray *picArr = dict[@"pics"];
            
            //轮播图为photo+pics里面的图片总和
            if (picArr.count > 0) {
             
                [strongSelf.headerScrImgArray addObjectsFromArray:dict[@"pics"] ];

            }
            
            
            
            strongSelf.evaluateNumLabel.text = [NSString stringWithFormat:@"%@人评价了该商品",dict[@"pingnum"]];
            
            
            if (dic[@"datas"][@"goodsfavorites"] == NULL || dic[@"datas"][@"goodsfavorites"] == nil ||dic[@"datas"][@"goodsfavorites"] == [NSNull null]) {
                
                strongSelf.collectionImage.image = [UIImage imageNamed:@"星星x"];
                
            }else{
                
                strongSelf.collectionImage.image = [UIImage imageNamed:@"星星"];
                
            }
            
            
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];

                [self.navigationController popViewControllerAnimated:YES];
            }
        
        [self reloadData];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];

    
    
}
-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];;
        [button setFrame:CGRectMake(0, 0, 25, 25)];
        [button addTarget:self action:@selector(goShopCart:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setBackgroundImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIView *rightCustomView = [[UIView alloc] initWithFrame: button.frame];
        
        [rightCustomView addSubview:button];
        
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightCustomView];
    }
    return _rightItem;
}

-(void)reloadData
{
    [self.headerView addSubview:self.headScrollView];
    
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.backGroundView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,_goodsInfoDetailView.mj_y + _goodsInfoDetailView.height,SCREEN_WIDTH - 40,30)];
    
    label.text = @"购买须知";
    
    label.font = [UIFont systemFontOfSize:13];
    
    label.textColor = [UIColor redColor];
    
    
  //接口返回为html字符串,所以详情用label富文本加载html数据
    UILabel *label1 = [[UILabel alloc] init];

    
  //  label1.text = _goodsInfo;
    
    NSString *infoStr = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",SCREEN_WIDTH - 40,_goodsInfo];

    
    NSData *data = [infoStr dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                
                                                               options:options
                                
                                                    documentAttributes:nil
                                
                                                                 error:nil];
    
    if (_goodsInfo != nil && _goodsInfo != NULL) {
     
        label1.attributedText = html;

    }
    
    CGSize size = [label1.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    label1.frame = CGRectMake(20,label.mj_y + label.height, SCREEN_WIDTH - 40,size.height);
    
    
    label1.numberOfLines = 0;
    
    label1.font  = [UIFont systemFontOfSize:12];
    
    [_backGroundView addSubview:label];
    [_backGroundView addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20,label1.mj_y + label1.height,SCREEN_WIDTH - 40,30)];
    
    label2.text = @"商品介绍";
    
    label2.font = [UIFont systemFontOfSize:13];
    
    label2.textColor = [UIColor redColor];
    
    
    UILabel *label3 = [[UILabel alloc] init];
    
   // label3.text = _goodsDetail;
    
    
    //修改html样式
    NSString *detailStr = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",SCREEN_WIDTH - 40,_goodsDetail];
    
    
    NSData *data1 = [detailStr dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSDictionary *options1 = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *html1 = [[NSAttributedString alloc]initWithData:data1
                                
                                                               options:options1
                                
                                                    documentAttributes:nil
                                
                                                                 error:nil];

    if (_goodsDetail != nil && _goodsDetail != NULL) {
     
        label3.attributedText = html1;

    }

    CGSize size1 = [label3.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;

    label3.frame = CGRectMake(20,label2.mj_y + label2.height, SCREEN_WIDTH - 40,size1.height);
    
    label3.numberOfLines = 0;
    
    label3.font  = [UIFont systemFontOfSize:12];
    
    [_backGroundView addSubview:label2];
    [_backGroundView addSubview:label3];
    
    _backGroundView.frame = CGRectMake(0,0,SCREEN_WIDTH, label3.frame.origin.y+label3.frame.size.height+44 + 10);
    
    view.frame = CGRectMake(0,_goodsInfoDetailView.mj_y + _goodsInfoDetailView.height + 1,SCREEN_WIDTH,label3.frame.origin.y+label3.frame.size.height + 44 + 10 - _goodsInfoDetailView.mj_y - _goodsInfoDetailView.height - 1);
    
    _myScrollView.contentSize = CGSizeMake(0,_backGroundView.frame.size.height);
    
}
-(UIView*)headScrollView
{
    if (_headScrollView == nil) {
        _headScrollView = [[scrollPhotos alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_WIDTH/8*5)];
        _headScrollView.delegate = self;
        
        _headScrollView.photos = _headerScrImgArray;
        
        
        // [_headView addSubview:self.searchImage];
    }
    
    
    return _headScrollView;
}
- (IBAction)numClick:(UIButton *)sender {

    if (sender.tag == 10) {
        if (![self.numLabel.text isEqualToString:@"1"]) {
            
            num --;
        }else{
            
            [JKToast showWithText:@"商品数不能少于1"];
            return;
        }
    }else
    {
        num++;
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    
}
- (IBAction)addShopCart:(UIButton *)sender {

    if (![USER_DEFAULT boolForKey:@"isLogin"]){
        
        [JKToast showWithText:@"请先登录"];
        
        HZDSLoginViewController *login = [[HZDSLoginViewController alloc] init];
        
        [self.navigationController pushViewController:login animated:YES];
        
    }else{
        
    
        NSDictionary *dic = @{@"shop_id":_goodsShopID,
                              @"goods_id":_goodsID,
                              @"spec_key":_goodsSpec,
                              @"num":_numLabel.text
                              };
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_ADDSHOPCART] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"加入购物车", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
    }
    
    
  
    
}
- (IBAction)buyNow:(UIButton *)sender {

 
    if (![USER_DEFAULT boolForKey:@"isLogin"]){
        
        [JKToast showWithText:@"请先登录"];
        
        HZDSLoginViewController *login = [[HZDSLoginViewController alloc] init];
        
        [self.navigationController pushViewController:login animated:YES];
        
    }else{
     
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        
        [dict setObject:_numLabel.text forKey:[NSString stringWithFormat:@"num[%@|%@]",_goodsID,_goodsSpec]];
        
        
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_UPLOADORDER] parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"结算", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                
                HZDSShopOrderViewController *order = [[HZDSShopOrderViewController alloc] init];
                
                order.orderDic = dic;
                
                [USER_DEFAULT removeObjectForKey:@"choiceAddress"];

                
                NSArray *arr = [dic[@"datas"] allKeys];
                
                for (NSString *str in arr) {
                    
                    if ([str isEqualToString:@"log_id"]) {
                        
                        order.logId = [dic[@"datas"][str] stringValue];
                    }
                    if ([str isEqualToString:@"order_id"]) {
                        
                        order.orderId = [dic[@"datas"][str] stringValue];                    }
                    
                }
                
                [self.navigationController pushViewController:order animated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
    
  
}
-(void)jumpShopCart
{
    HZDSShopCartViewController *cart = [[HZDSShopCartViewController alloc] init];
    
    [self.navigationController pushViewController:cart animated:YES];
}
//收藏
- (IBAction)collectionGoods:(UIButton *)sender {

    
    NSDictionary *dic = @{@"goods_id":_goodsID                         };
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,SHOPPING_MALL_COLLECTION] parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"收藏", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            strongSelf.collectionImage.image = [UIImage imageNamed:@"星星"];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
}
-(void)goShopCart:(UIButton *)sender
{
    HZDSShopCartViewController *cart = [[HZDSShopCartViewController alloc] init];
    
    [self.navigationController pushViewController:cart animated:YES];
    
}
- (IBAction)shopDetail:(UIButton *)sender {

    HZDSShopViewController *shop = [[HZDSShopViewController alloc] init];
    
    shop.shop_id = _goodsShopID;
    
    [self.navigationController pushViewController:shop animated:YES];
    
}
//商品评价
- (IBAction)evaluate:(UIButton *)sender {

    HZDSMallEvaluateListViewController *evaluate = [[HZDSMallEvaluateListViewController alloc] init];
    
    evaluate.goods_id = _goodsID;
    
    [self.navigationController pushViewController:evaluate animated:YES];
    
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
