//
//  HZDSshopAddressViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/23.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSshopAddressViewController.h"
#import "HZDSshopAddressTableViewCell.h"
#import "HZDSAddAddressViewController.h"
#import "HZDSAddAddressViewController.h"
#import "HZDSAddressModel.h"

@interface HZDSshopAddressViewController ()<
UITableViewDelegate,
UITableViewDataSource,
deleteBtnDelagate
>

@property (weak, nonatomic) IBOutlet UITableView *addressListTableView;

@property (weak, nonatomic) IBOutlet UIButton *addAddressbutton;

@property(nonatomic,strong) NSMutableArray *addressListArray;

@end

@implementation HZDSshopAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _addressListArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
}
-(void)initUI
{
    
    self.navigationItem.title = @"商城收货地址";
}
-(void)registercell
{
    
    _addressListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib* nib   =[UINib nibWithNibName:@"HZDSshopAddressTableViewCell" bundle:nil];
  
    [_addressListTableView registerNib:nib forCellReuseIdentifier:@"AddressTableViewCell"];
    
    [WYFTools viewLayer:_addAddressbutton.frame.size.height/16*3 withView:_addAddressbutton];
}
-(void)requestData
{
    __weak typeof(self) weakSelf = self;

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"goods" forKey:@"type"];
    
    if (_orderID != nil) {
      
    [dic setObject:_orderID forKey:@"order_id"];
        
    }
    
    if (_LogID != nil) {
        
    [dic setObject:_LogID forKey:@"log_id"];
        
    }
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,ADDRESS_LIST] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"地址列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        
        [strongSelf.addressListArray removeAllObjects];
        if (SUCCESS) {
            
            if (dic[@"datas"][@"defaultadd"] == NULL || dic[@"datas"][@"defaultadd"] == nil ||dic[@"datas"][@"defaultadd"] == [NSNull null]) {
                
                
            }else{
                
                NSDictionary *dic1 = dic[@"datas"][@"defaultadd"];
                
                HZDSAddressModel *model = [[HZDSAddressModel alloc] init];
                
                model.addressId = dic1[@"id"];
              
                model.addressDetail = dic1[@"info"];
                
                model.address = dic1[@"area_str"];
                
                model.userName = dic1[@"xm"];
                
                model.userPhone = dic1[@"tel"];
                
                model.is_default = dic1[@"default"];
               
                [strongSelf.addressListArray addObject:model];
            }
           
            if (dic[@"datas"][@"addlist"] == NULL || dic[@"datas"][@"addlist"] == nil ||dic[@"datas"][@"addlist"] == [NSNull null]) {
                
                
            }else{
                
                NSArray *addlist = dic[@"datas"][@"addlist"];
                
                for (NSDictionary *dic2 in addlist) {
                    
                    HZDSAddressModel *model = [[HZDSAddressModel alloc] init];
                    
                    model.addressId = dic2[@"id"];
                   
                    model.addressDetail = dic2[@"info"];
                    
                    model.address = dic2[@"area_str"];
                    
                    model.userName = dic2[@"xm"];
                    
                    model.userPhone = dic2[@"tel"];
                    
                    model.is_default = dic2[@"default"];
                    
                    [strongSelf.addressListArray addObject:model];
                    
                }
                
            }
            
            [strongSelf.addressListTableView reloadData];
            
            
        }else{

            
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
        
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _addressListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZDSshopAddressTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    
    HZDSAddressModel* model = _addressListArray[indexPath.section];
    
    [cell setAddressmodel:model];
    
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_orderID != nil || _LogID != nil) {
       
        HZDSAddressModel* model = _addressListArray[indexPath.section];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dict = @{@"type":@"goods",
                               @"id":model.addressId
                               };
        
        [dic addEntriesFromDictionary:dict];
        
        if (_orderID != nil) {
            
            [dic addEntriesFromDictionary:@{@"order_id":_orderID}];
        }
        if (_LogID != nil) {
            
            [dic addEntriesFromDictionary:@{@"log_id":_LogID}];
        }
        
        
        [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,ADDRESS_CHOICE] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"选择地址", dic);
            
            
            if (SUCCESS) {
                
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
            LOG(@"cuow", Json);
            
        }];
    }
    
  
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [self createHeaderView];
    
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(141);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)createHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,10)];
    
    view.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    return view;
}
- (IBAction)addAddress:(UIButton *)sender {

    HZDSAddAddressViewController *addAddress = [[HZDSAddAddressViewController alloc] init];
    
    addAddress.addressType = addType;
    
    if (_orderID != nil) {
        
        addAddress.orderID = _orderID;
    }
    if (_LogID != nil) {
        
        addAddress.LogID = _LogID;
    }
    
    [self.navigationController pushViewController:addAddress animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}
-(void)buttonDelete:(NSString *)addressId
{
    NSDictionary *dic = @{@"address_id":addressId};
 
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,ADDRESS_DELETE] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"删除地址", dic);
        
        if (SUCCESS) {
            
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];

            [self requestData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
    
}
-(void)buttonEdit:(NSString *)addressId withMode:(HZDSAddressModel *)model{
    
    HZDSAddAddressViewController *add = [[HZDSAddAddressViewController alloc] init];
    
    add.addressType = editType;
    
    add.addressModel = model;
    
    if (_orderID != nil) {
    
        add.orderID = _orderID;
    }
    if (_LogID != nil) {
      
        add.LogID = _LogID;
    }
    
    [self.navigationController pushViewController:add animated:YES];
 
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
