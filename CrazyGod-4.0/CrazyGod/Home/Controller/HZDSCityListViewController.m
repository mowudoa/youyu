//
//  HZDSCityListViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/7.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSCityListViewController.h"
#import "HZDSCityListTableViewCell.h"
#import "HZDSCityListModel.h"

@interface HZDSCityListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *cityListTableView;
@property (weak, nonatomic) IBOutlet UITextField *keyWordTexfField;

@property(nonatomic,strong) NSMutableArray *cityListDataSource;

@end

@implementation HZDSCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _cityListDataSource = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"城市选择";
    
    [self registercell];
    
    [self initData];
}
-(void)registercell
{
    UINib* order = [UINib nibWithNibName:@"HZDSCityListTableViewCell" bundle:nil];
    [_cityListTableView registerNib:order forCellReuseIdentifier:@"CityListTableViewCell"];
    
}
-(void)initData
{
    NSMutableDictionary *keyDic = [[NSMutableDictionary alloc] init];

    
    if ([_keyWordTexfField.text isEqualToString:@""] || [_keyWordTexfField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {

    }else{
        
        [keyDic addEntriesFromDictionary:@{@"keyword2":_keyWordTexfField.text}];

    }
    
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,CITYLIST] parameters:keyDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"城市列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.cityListDataSource removeAllObjects];
        if (SUCCESS) {
           
            if ( [dic[@"datas"][@"citylists"] isKindOfClass:[NSArray class]]) {
                
                
            }else{
            
                NSDictionary *cityList = dic[@"datas"][@"citylists"];
                
                NSArray *array = [cityList allKeys];
                
                for (NSString *keyString in array) {
                    
                    HZDSCityListModel *model = [[HZDSCityListModel alloc] init];
                    
                    model.citysFirstKey = keyString;
                    
                    [model.cityListArray addObjectsFromArray:cityList[keyString]];
                    
                    [strongSelf.cityListDataSource addObject:model];
                    
                }
            }
        
        }
        
        [strongSelf.cityListTableView reloadData];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityListDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HZDSCityListModel *model = [[HZDSCityListModel alloc] init];
    
    model = _cityListDataSource[section];
    
    return model.cityListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSCityListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CityListTableViewCell" forIndexPath:indexPath];
    
    HZDSCityListModel *model = [[HZDSCityListModel alloc] init];
    model = _cityListDataSource[indexPath.section];
    
    
    cell.cityName.text = [model.cityListArray[indexPath.row] objectForKey:@"name"];
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HZDSCityListModel *model = [[HZDSCityListModel alloc] init];
    model = _cityListDataSource[indexPath.section];
    
    [self changeCity:[model.cityListArray[indexPath.row] objectForKey:@"city_id"]];

    
    //城市切换暂时不考虑
//    [USER_DEFAULT setObject:[model.cityListArray[indexPath.row] objectForKey:@"lng"] forKey:@"lngString"];
//    
//    [USER_DEFAULT setObject:[model.cityListArray[indexPath.row] objectForKey:@"lat"] forKey:@"latString"];
//
//    [self.navigationController popViewControllerAnimated:YES];

//
//    if ([self.delegate respondsToSelector:@selector(citySleected:withcouponlat:)]) {
//
//        [self.delegate citySleected:[model.cityListArray[indexPath.row] objectForKey:@"lng"]
//                      withcouponlat:[model.cityListArray[indexPath.row] objectForKey:@"lat"]];
//
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSCityListModel *model = [[HZDSCityListModel alloc] init];
    model = _cityListDataSource[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel* keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, 25)];
    keyLabel.text = model.citysFirstKey;
    
    keyLabel.textAlignment = NSTextAlignmentLeft;
    keyLabel.font=[UIFont systemFontOfSize:13];
    keyLabel.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:keyLabel];
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,34,SCREEN_WIDTH,1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [backView addSubview:lineLabel];
    
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
    
}
- (IBAction)searchBtn:(UIButton *)sender {

    [_keyWordTexfField resignFirstResponder];
    
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)changeCity:(NSString *)cityID
{
    
    NSDictionary *dic = @{@"city_id":cityID};
    
    [CrazyNetWork CrazyRequest_Post:CITY_CHANGE parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"切换城市", dic);
        
        if (SUCCESS) {
            
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];

            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
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
