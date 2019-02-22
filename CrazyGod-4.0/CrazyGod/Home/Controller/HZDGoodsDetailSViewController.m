//
//  HZDGoodsDetailSViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/5.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDGoodsDetailSViewController.h"
#import "HZDSuploadOrderViewController.h"
#import "HZDSLoginViewController.h"
#import "scrollPhotos.h"

@interface HZDGoodsDetailSViewController ()
{
    NSMutableArray *_thumbArray;
    
    NSString *rushIntroduce;
    
    NSString *rushInfo;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsSaleNum;


@property(nonatomic,strong)scrollPhotos* headView;
@property (weak, nonatomic) IBOutlet UIView *businessDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property(nonatomic,copy) NSString *tuanID;
@end

@implementation HZDGoodsDetailSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"抢购详情";
    
    _thumbArray = [[NSMutableArray alloc] init];
    
    [self initData];
}
-(void)initData
{
    NSDictionary* dic = @{@"tuan_id":_goodsID};
    
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,RUSHTOBUYDETAIL] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"抢购详情", dic);
        

        [self->_thumbArray removeAllObjects];
        if (SUCCESS) {
            
            // [JKToast showWithText:@"购物车列表"];
            
            NSDictionary* List = dic[@"datas"];
            
            self->_goodsNameLabel.text = List[@"detail"][@"title"];
            
            
            self->_goodsPrice.text = [NSString stringWithFormat:@"现价:￥%@",[List[@"detail"][@"tuan_price"] stringValue]];

            self->_tuanID = List[@"detail"][@"tuan_id"];
            
            self->_goodsOldPrice.text = [NSString stringWithFormat:@"原价:￥%@",[List[@"detail"][@"price"] stringValue]];

            self->_goodsInfoLabel.text = List[@"detail"][@"intro"];
            
            self->_goodsSaleNum.text = [NSString stringWithFormat:@"已售:%@",List[@"detail"][@"sold_num"]];
            
            [self->_thumbArray addObjectsFromArray:List[@"thumb"]];
            
            self->rushIntroduce = List[@"tuandetails"][@"instructions"];
            
            self->rushInfo = List[@"tuandetails"][@"details"];

            
            if (dic[@"datas"][@"tuan_favorites"] == NULL || dic[@"datas"][@"tuan_favorites"] == nil ||dic[@"datas"][@"tuan_favorites"] == [NSNull null]) {
                
                self->_collectImage.image = [UIImage imageNamed:@"星星x"];
                
            }else{
                
                self->_collectImage.image = [UIImage imageNamed:@"星星"];

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
-(UIView*)headView
{
    if (_headView == nil) {
        _headView = [[scrollPhotos alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_WIDTH/8*5)];
        _headView.delegate = self;
        
        _headView.tag = 10001;
        
        _headView.photos = _thumbArray;
        
        
        // [_headView addSubview:self.searchImage];
    }
    
    
    return _headView;
}
-(void)reloadData
{
    [self.headerView addSubview:self.headView];
 
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,_businessDetailView.mj_y + _businessDetailView.height,SCREEN_WIDTH - 40,30)];
    
    label.text = @"抢购介绍";
    
    label.font = [UIFont systemFontOfSize:13];
    
    label.textColor = [UIColor redColor];
        
    
    UILabel *label1 = [[UILabel alloc] init];
    
  //  label1.text = rushIntroduce;
    
    
    NSString *rushIntroduceStr = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",SCREEN_WIDTH - 40,rushIntroduce];
    
    NSData *data = [rushIntroduceStr dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                
                                                               options:options
                                
                                                    documentAttributes:nil
                                
                                                                 error:nil];
    
    
    label1.attributedText = html;
    
    CGSize size = [label1.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    label1.frame = CGRectMake(20,label.mj_y + label.height, SCREEN_WIDTH - 40,size.height);
    
    label1.numberOfLines = 0;
    
    label1.font  = [UIFont systemFontOfSize:12];
    
    [_backgroundView addSubview:label];
    [_backgroundView addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20,label1.mj_y + label1.height,SCREEN_WIDTH - 40,30)];
    
    label2.text = @"抢购须知";
    
    label2.font = [UIFont systemFontOfSize:13];
    
    label2.textColor = [UIColor redColor];
    
    
    UILabel *label3 = [[UILabel alloc] init];
    
   // label3.text = rushInfo;
    
    NSString *rushInfoStr = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",SCREEN_WIDTH - 40,rushInfo];

    
    NSData *data1 = [rushInfoStr dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSDictionary *options1 = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *html1 = [[NSAttributedString alloc]initWithData:data1
                                 
                                                                options:options1
                                 
                                                     documentAttributes:nil
                                 
                                                                  error:nil];
    
    
    
    label3.attributedText = html1;
    
    CGSize size1 = [label3.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    label3.frame = CGRectMake(20,label2.mj_y + label2.height, SCREEN_WIDTH - 40,size1.height);
    label3.numberOfLines = 0;
    
    label3.font  = [UIFont systemFontOfSize:12];
    
    [_backgroundView addSubview:label2];
    [_backgroundView addSubview:label3];
    
    
    _backgroundView.frame = CGRectMake(0,0,SCREEN_WIDTH, label3.frame.origin.y+label3.frame.size.height+44 + 10);
    
    view.frame = CGRectMake(0,_businessDetailView.mj_y + _businessDetailView.height + 1,SCREEN_WIDTH,label3.frame.origin.y+label3.frame.size.height + 44 + 10 - _businessDetailView.mj_y - _businessDetailView.height - 1);
    
    _myScrollView.contentSize = CGSizeMake(0,_backgroundView.frame.size.height);
    
}
- (IBAction)goBuy:(UIButton *)sender {

    
    if ([USER_DEFAULT boolForKey:@"isLogin"]) {
        
     
        HZDSuploadOrderViewController *uplaod = [[HZDSuploadOrderViewController alloc] init];
        
        uplaod.goodId = _tuanID;
        
        [self.navigationController pushViewController:uplaod animated:YES];
    }else{
        
        [JKToast showWithText:@"请先登录"];
     
        HZDSLoginViewController *login = [[HZDSLoginViewController alloc] init];
        
        [self.navigationController pushViewController:login animated:YES];
    }
    
    

}
- (IBAction)collectGoods:(UIButton *)sender {

    NSDictionary *dic = @{@"tuan_id":_tuanID                          };
    
    
    [CrazyNetWork CrazyRequest_Get:FAVORITES_GOODS parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"收藏", dic);
        
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];
            
            self->_collectImage.image = [UIImage imageNamed:@"星星"];

        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
- (IBAction)seeShopDetail:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
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
