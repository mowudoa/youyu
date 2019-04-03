//
//  HZDSMineViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMineViewController.h"
#import "HZDSBalanceRechargeViewController.h"
#import "HZDSemployeeCenterViewController.h"
#import "HZDSMallOrderListViewController.h"
#import "HZDSmyCollectionViewController.h"
#import "HZDSNewMessageViewController.h"
#import "HZDSUnderLineViewController.h"
#import "HZDSShopCartViewController.h"
#import "HZDSUserInfoViewController.h"
#import "HZDSMerchantViewController.h"
#import "HZDSmyCouponViewController.h"
#import "HZDSMyShareViewController.h"
#import "HZDSSetInfoViewController.h"
#import "HZDSmyOrderViewController.h"
#import "HZDSLoginViewController.h"
#import "HZDSMIneTableViewCell.h"


@interface HZDSMineViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIImageView *UserHeaderIcon;

@property (weak, nonatomic) IBOutlet UILabel *userPhone;

@property (weak, nonatomic) IBOutlet UITableView *mineTableView;

@property(nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation HZDSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self registercell];
    
}
-(void)initUI
{
    [WYFTools viewLayer:_UserHeaderIcon.frame.size.height/2 withView:_UserHeaderIcon];
    
    _dataSource = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconView:)];
    
    [_UserHeaderIcon addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserINfo) name:@"getUserInfo" object:nil];

}
-(void)registercell
{
    
    UINib* nib = [UINib nibWithNibName:@"HZDSMIneTableViewCell" bundle:nil];
    
    [_mineTableView registerNib:nib forCellReuseIdentifier:@"MIneTableViewCell"];
    
}
//收藏/余额/优惠券/购物车
- (IBAction)clickButton:(UIButton *)sender {

    if (sender.tag == 200) {
        
        HZDSmyCollectionViewController *collect = [[HZDSmyCollectionViewController alloc] init];
        
        [self.navigationController pushViewController:collect animated:YES];
        
    }else if (sender.tag == 201){
     
        HZDSBalanceRechargeViewController *recharg = [[HZDSBalanceRechargeViewController alloc] init];
        
        [self.navigationController pushViewController:recharg animated:YES];
        
    }else if (sender.tag == 202){
      
        HZDSmyCouponViewController *coupon = [[HZDSmyCouponViewController alloc] init];
        
        [self.navigationController pushViewController:coupon animated:YES];
        
    }else if (sender.tag == 203){
      
        HZDSShopCartViewController *cart = [[HZDSShopCartViewController alloc] init];
        
        [self.navigationController pushViewController:cart animated:YES];
        
    }

}
//设置
- (IBAction)setInfoButton:(UIButton *)sender {

    HZDSSetInfoViewController *set = [[HZDSSetInfoViewController alloc] init];
    
    [self.navigationController pushViewController:set animated:YES];
}
- (IBAction)lookNewMessage:(UIButton *)sender {

    HZDSNewMessageViewController *message = [[HZDSNewMessageViewController alloc] init];
        
    message.messageUrl = MY_MESSAGE;
    
    [self.navigationController pushViewController:message animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
   
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([USER_DEFAULT boolForKey:@"isLogin"]) {
        
        [self getUserINfo];
        
    }else{
        
        HZDSLoginViewController *login = [[HZDSLoginViewController alloc] init];
        
        [self.navigationController pushViewController:login animated:YES];
        
    }
    
}
//点击头像用户信息设置界面
-(void)tapIconView:(UITapGestureRecognizer *)tap
{
    HZDSUserInfoViewController *userInfo = [[HZDSUserInfoViewController alloc] init];
    
    [self.navigationController pushViewController:userInfo animated:YES];
    
}
//获取用户信息
-(void)getUserINfo
{
//  [NSString stringWithFormat:@"%@%@",HEADERURL_USER,GETUSERINFO]
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:GETUSERINFO_MINE parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"获取用户信息", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.dataSource removeAllObjects];
        
        [strongSelf.dataSource addObject:@"我的订单"];
        
        [strongSelf.dataSource addObject:@"营销管理"];

        
        if (SUCCESS) {
            
            [USER_DEFAULT setObject:dic[@"datas"][@"user_id"] forKey:@"User_ID"];
            
            if (dic[@"datas"][@"MEMBER"][@"nickname"] == NULL || dic[@"datas"][@"MEMBER"][@"nickname"] == nil ||dic[@"datas"][@"MEMBER"][@"nickname"] == [NSNull null]) {
                
            }else{
                
                strongSelf.userPhone.text = dic[@"datas"][@"MEMBER"][@"nickname"];
                
                [USER_DEFAULT setObject:dic[@"datas"][@"MEMBER"][@"nickname"] forKey:@"nickname"];
            }
            
            if (dic[@"datas"][@"MEMBER"][@"face"] == NULL || dic[@"datas"][@"MEMBER"][@"face"] == nil ||dic[@"datas"][@"MEMBER"][@"face"] == [NSNull null]) {
                
                strongSelf.UserHeaderIcon.image = [UIImage imageNamed:@"1213per"];
                
            }else{
                
                [strongSelf.UserHeaderIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"MEMBER"][@"face"]]] placeholderImage:[UIImage imageNamed:@"1213per"]];
               
                [USER_DEFAULT setObject:dic[@"datas"][@"MEMBER"][@"face"] forKey:@"face"];

            }
            if (dic[@"datas"][@"xianshang"] == NULL || dic[@"datas"][@"xianshang"] == nil ||dic[@"datas"][@"xianshang"] == [NSNull null]) {
                
                [strongSelf.dataSource addObject:@"线上入驻"];

            }else{
             
                [USER_DEFAULT setObject:@"1" forKey:@"xianshang"];

            }
            if (dic[@"datas"][@"xianxia"] == NULL || dic[@"datas"][@"xianxia"] == nil ||dic[@"datas"][@"xianxia"] == [NSNull null]) {
                
                [strongSelf.dataSource addObject:@"线下入驻"];
                
            }else{
                
            }
            
            if (dic[@"datas"][@"is_shop"] == NULL || dic[@"datas"][@"is_shop"] == nil ||dic[@"datas"][@"is_shop"] == [NSNull null]) {
                
                
            }else{
                
                [strongSelf.dataSource addObject:@"商家管理"];
                
            }
            
            if (dic[@"datas"][@"worker"] == NULL || dic[@"datas"][@"worker"] == nil ||dic[@"datas"][@"worker"] == [NSNull null]) {
                
            }else{
                
                [strongSelf.dataSource addObject:@"店员中心"];

            }
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
            HZDSLoginViewController *login = [[HZDSLoginViewController alloc] init];
            
            [self.navigationController pushViewController:login animated:YES];
        }
        
        [self reloadData];
        
        [USER_DEFAULT synchronize];

    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}

//商城订单
- (IBAction)mallOrderClick:(UIButton *)sender {

    HZDSMallOrderListViewController *myOrder = [[HZDSMallOrderListViewController alloc] init];
    
    if (sender.tag == 200) {
        
        myOrder.orderType = WXMyOrderUnPay;
        
    }else if (sender.tag == 201){
        
        myOrder.orderType = WXMyOrderUnSend;
        
    }else if (sender.tag == 202){
        
        myOrder.orderType = WXMyOrderUnReceive;
        
    }else if (sender.tag == 203){
        
        myOrder.orderType = WXMyOrderUnEvaluate;
        
    }else if (sender.tag == 204){
        
        myOrder.orderType = WXMyOrderUnRefund;
        
    }
    
    [self.navigationController pushViewController:myOrder animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZDSMIneTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MIneTableViewCell" forIndexPath:indexPath];

    cell.nameLabel.text = _dataSource[indexPath.row];

    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource[indexPath.row] isEqualToString:@"线下入驻"]) {
    
        HZDSUnderLineViewController *underLine = [[HZDSUnderLineViewController alloc] init];
        
        [self.navigationController pushViewController:underLine animated:YES];
        
    }else if ([_dataSource[indexPath.row] isEqualToString:@"商家管理"]){

        HZDSMerchantViewController *merchant = [[HZDSMerchantViewController alloc] init];
        
        [self.navigationController pushViewController:merchant animated:YES];
        
    }else if ([_dataSource[indexPath.row] isEqualToString:@"我的订单"]){
        
        HZDSmyOrderViewController *order = [[HZDSmyOrderViewController alloc] init];
        
        [self.navigationController pushViewController:order animated:YES];
        
    }else if ([_dataSource[indexPath.row] isEqualToString:@"店员中心"]){
        
        HZDSemployeeCenterViewController *employee = [[HZDSemployeeCenterViewController alloc] init];
        
        [self.navigationController pushViewController:employee animated:YES];
        
    }else if ([_dataSource[indexPath.row] isEqualToString:@"线上入驻"]){
        
        [JKToast showWithText:@"请前往pc端进行线上入驻操作"];
        
    }else if ([_dataSource[indexPath.row] isEqualToString:@"营销管理"]){

        HZDSMyShareViewController *share = [[HZDSMyShareViewController alloc] init];
        
        [self.navigationController pushViewController:share animated:YES];
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(45);
    
}
-(void)reloadData
{
    [self.mineTableView reloadData];

    if (_mineTableView.height > _dataSource.count * HEIGHT(45)) {
        
        _mineTableView.scrollEnabled = NO;
        
    }else{
        
        _mineTableView.scrollEnabled = YES;

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
