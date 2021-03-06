//
//  HZDSBusinessViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/4.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSBusinessViewController.h"
#import "HZDSBusinessDetailViewController.h"
#import "HZDSBusinessTableViewCell.h"
#import "HZDSSubClassTableViewCell.h"
#import "HZDSBusinessModel.h"
#import "HZDSClassifyModel.h"
#import "HZDSSubClassModel.h"

@interface HZDSBusinessViewController ()<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>
{
    NSString *classString;
    
    NSString *areaIdString;
    
    NSString *choiceString;
    
}

@property (weak, nonatomic) IBOutlet UIView *headerClassView;

@property (weak, nonatomic) IBOutlet UITableView *businessListTableView;

@property (weak, nonatomic) IBOutlet UITableView *subClassTableView;

@property (weak, nonatomic) IBOutlet UITableView *subAreaTableView;

@property (weak, nonatomic) IBOutlet UITableView *selectedTableView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property(strong,nonatomic)UIView* headerView;

@property(strong,nonatomic)UIImageView* searchImage;

@property(strong,nonatomic)UITextField* searchTextField;

@property(nonatomic,strong) NSMutableArray *businessArray;

@property(nonatomic,strong) NSMutableArray *classArray;

@property(nonatomic,strong) NSMutableArray *areaArray;

@property(nonatomic,strong) NSMutableArray *subClassArray;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *choiceArray;

@end

@implementation HZDSBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self initUI];
    
    [self registercell];
    
    _businessArray = [[NSMutableArray alloc] init];
    
    _classArray = [[NSMutableArray alloc] init];
    
    _areaArray = [[NSMutableArray alloc] init];
    
    _choiceArray = [[NSMutableArray alloc] init];
    
    _subClassArray = [[NSMutableArray alloc] init];
    
    [self initData];
    
    [self initCLassData];
    
}
-(void)initUI
{
    self.navigationItem.titleView = self.searchImage;
    
    [self.headerClassView addSubview:self.headerView];

    UIButton *btn = [self.headerView viewWithTag:10];
    
    if (_classNameString != nil) {
      
        [btn setTitle:_classNameString forState:UIControlStateNormal];

    }

    //判断是为root界面,以此隐藏标签栏
    if (_isRootNav) {
        
        [self initBackButton];

    }else{
        
    }
    
    self.businessListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self initData];
    }];
}

-(void)initBackButton
{
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [backBtn setFrame:CGRectMake(0, 0, 20, 20)];
    
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setImage:[UIImage imageNamed:@"小于号"] forState:UIControlStateNormal];
    
    UIBarButtonItem* im = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = im;
    
}
-(void)registercell
{

    UINib* nib = [UINib nibWithNibName:@"HZDSBusinessTableViewCell" bundle:nil];
   
    [_businessListTableView registerNib:nib forCellReuseIdentifier:@"BusinessTableViewCell"];

    UINib* nib1 = [UINib nibWithNibName:@"HZDSSubClassTableViewCell" bundle:nil];
  
    [_subClassTableView registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];
    
    [_subAreaTableView registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];

    [_selectedTableView registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done111:) name:@"doneAction111" object:nil];

}
-(void)initData
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
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,BUSINESSLIST] parameters:keyDic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商家列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.businessArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
             strongSelf.backGroundView.hidden = YES;
             
             strongSelf.businessListTableView.hidden = NO;
                
            }else{
                
             strongSelf.backGroundView.hidden = NO;
                
             strongSelf.businessListTableView.hidden = YES;
            }
            
            for (NSDictionary *business in arr) {
                
                HZDSBusinessModel *model = [[HZDSBusinessModel alloc] init];
                
                model.businessIcon = business[@"photo"];
                
                model.businessId = business[@"shop_id"];
                
                model.businessName = business[@"shop_name"];
                
                model.businessType = business[@"cate_name"];
                
                model.businessLocation = business[@"d"];
                
                model.businessSaleNum = business[@"yueshou"];
                
                model.businessPrice = [business[@"countcostpingjun"] stringValue];
                
                model.businessStarNum = [business[@"countxingpingjun"] stringValue];
                
                [model.goodsArray addObjectsFromArray:business[@"tags"]];
                
                [strongSelf.businessArray addObject:model];
            }
            
        }
        
        [strongSelf.businessListTableView reloadData];
        
        [self.businessListTableView.mj_header endRefreshing];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
    _keyWordString = nil;
    
    _backgroundView.hidden = YES;
    
}
-(void)initCLassData
{
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,BUSINESSCLASS] parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"类别列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.classArray removeAllObjects];
        
        [strongSelf.areaArray removeAllObjects];
        
        [strongSelf.choiceArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSDictionary *classDic = dic[@"datas"][@"shopcates"];
            
            NSArray *classArr = [classDic allKeys];
            
            [strongSelf.classArray addObject:@"全部分类"];
            
            for (NSString *str in classArr) {
               
                HZDSClassifyModel *model = [[HZDSClassifyModel alloc] init];
                
                model.classId = classDic[str][@"cate_id"];
                
                model.className = classDic[str][@"cate_name"];
             
                model.classcont = classDic[str][@"count"];
                
                NSDictionary *subClassDic = classDic[str][@"son"];
                
                NSArray *subClassArr = [subClassDic allKeys];
                
                for (NSString *classString in subClassArr) {
                    
                    HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                    
                    model1.classId = subClassDic[classString][@"cate_id"];
                    
                    model1.className = subClassDic[classString][@"cate_name"];
                    
                    model1.classcont = subClassDic[classString][@"count"];
                    
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
                
                model.classcont = areaDic[@"orderby"];
                
                NSArray *subArea = areaDic[@"business"];
                
                for (NSDictionary *subAreaDic in subArea) {
                    
                    HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                    
                    model1.classId = subAreaDic[@"business_id"];
                    
                    model1.className = subAreaDic[@"business_name"];
                    
                    [model.subClassArray addObject:model1];
                    
                }
                
                [strongSelf.areaArray addObject:model];
            }
            
            NSDictionary *choiceDic = dic[@"datas"][@"order"];

            NSArray *choiceArr = [choiceDic allKeys];
            
            for (NSString *str1 in choiceArr) {
                
                HZDSClassifyModel *model2 = [[HZDSClassifyModel alloc] init];
                
                model2.classId = str1;
               
                model2.className = choiceDic[str1];
                
                [strongSelf.choiceArray addObject:model2];
                
            }
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _businessListTableView) {
     
        return _businessArray.count;

    }else if (tableView == _subClassTableView)
    {
        if ([classString isEqualToString:@"1"]) {
            
            return _classArray.count;

        }else{
            
           return  _areaArray.count;
        }
        
    }else if (tableView == _subAreaTableView){
        
        return _subClassArray.count;
        
    }else{
        
        return _choiceArray.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _businessListTableView) {
        
        HZDSBusinessTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessTableViewCell" forIndexPath:indexPath];
        
        HZDSBusinessModel *model = _businessArray[indexPath.row];
        
        [cell setBussinessModel:model];
        
        return cell;
        
    }else if (tableView == _subClassTableView)
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
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",model.className,model.classcont];
            }else{
                
                HZDSClassifyModel *model = _areaArray[indexPath.row];
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.className];
            }
            
        }
        
        return cell;
        
    }else if (tableView == _subAreaTableView){
       
        HZDSSubClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubClassTableViewCell" forIndexPath:indexPath];
        
            HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];

            model1 = _subClassArray[indexPath.row];
        
        
        if ([classString isEqualToString:@"1"]) {
          
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",model1.className,model1.classcont];
            
        }else{
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model1.className];

        }
        
        return cell;
        
    }else{
       
        HZDSSubClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubClassTableViewCell" forIndexPath:indexPath];

        HZDSClassifyModel *model = _choiceArray[indexPath.row];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.className];
        
        return cell;
    }

}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _subClassTableView) {
    
        if (indexPath.row == 0) {
         
            _subClassTableView.hidden = YES;
          
            _subAreaTableView.hidden = YES;
            
            _backgroundView.hidden = YES;
            
            if ([classString isEqualToString:@"1"]) {
                
                UIButton *btn = [self.headerView viewWithTag:10];

                [btn setTitle:@"选择分类" forState:UIControlStateNormal];

                btn.selected = NO;
                
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                _classIDString = nil;
                
                [self initData];
                
            }else{
               
                UIButton *btn = [self.headerView viewWithTag:11];

                [btn setTitle:@"选择地区" forState:UIControlStateNormal];

                btn.selected = NO;

                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

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
            
            _subAreaTableView.hidden = NO;
            
            [_subAreaTableView reloadData];
            
        }
        
    }else if (tableView == _subAreaTableView){
        
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
        
        _subClassTableView.hidden = YES;
        
        _subAreaTableView.hidden = YES;
        
        [self changeCellBackgroundColor:_subClassTableView withIndexPath:nil];
        
    }else if (tableView == _selectedTableView){
        
        UIButton *btn = [self.headerView viewWithTag:12];
        
        HZDSClassifyModel *model = _choiceArray[indexPath.row];
        
        [btn setTitle:model.className forState:UIControlStateNormal];
        
        _selectedTableView.hidden = YES;

        choiceString = model.classId;
        
        [self initData];

        btn.selected = NO;
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#FC6621"] forState:UIControlStateNormal];

    }else{
        
        HZDSBusinessDetailViewController *detail = [[HZDSBusinessDetailViewController alloc] init];
        
        HZDSBusinessModel *model = _businessArray[indexPath.row];
        
        detail.shopID = model.businessId;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _businessListTableView) {
       
        HZDSBusinessModel *model = _businessArray[indexPath.row];
        
        return model.cellHeight;

    }else{
        
        return 35;
    }
    
}


#pragma mark PRIVATE

-(UIImageView*)searchImage
{
    if (_searchImage == nil) {
        
        _searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 30)];
      
        _searchImage.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
        
        UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.8 - 30,8,14,14)];
       
        ima.image = [UIImage imageNamed:@"searchIma"];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(25,0,100, 30)];
        
        label.text = @"搜索商品";
       
        label.textColor = [UIColor lightGrayColor];
        
        label.font = [UIFont systemFontOfSize:13];
        
        label.textAlignment = NSTextAlignmentLeft;
        
        _searchImage.layer.cornerRadius = _searchImage.frame.size.height/2;
       
        _searchImage.userInteractionEnabled = YES;
        
        [_searchImage addSubview:self.searchTextField];
       
        [_searchImage addSubview:ima];
        
    }
    return  _searchImage;
}


-(UITextField*)searchTextField
{
    if (_searchTextField == nil) {
        
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH * 0.75 - 20, 30)];
        
        _searchTextField.placeholder = @"输入商家关键字";
        
        [_searchTextField setValue:[UIColor colorWithHexString:@"#B5B5B5"] forKeyPath:@"_placeholderLabel.textColor"];
       
        _searchTextField.borderStyle = UITextBorderStyleNone;
        
        _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        _searchTextField.font = [UIFont systemFontOfSize:12];
        
        _searchTextField.delegate = self;
        
        _searchTextField.tag = 60001;
        
        _searchTextField.textColor = [UIColor lightGrayColor];
    }
    
    return _searchTextField;
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
-(void)touchheaderView:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 10:
            
            classString = @"1";
            
            _subClassTableView.hidden = !sender.selected;
            
            _selectedTableView.hidden = YES;
            
            _subAreaTableView.hidden = YES;
            
            [_subClassTableView reloadData];
            
            break;
        case 11:
            
            classString = @"2";
            
            _subClassTableView.hidden = !sender.selected;
           
            _selectedTableView.hidden = YES;
            
            _subAreaTableView.hidden = YES;

            [_subClassTableView reloadData];
            
            break;
            
        case 12:
            
            classString = @"3";
            
            _subClassTableView.hidden = YES;
            
            _subAreaTableView.hidden = YES;

            _selectedTableView.hidden = !sender.selected;
            
            [_selectedTableView reloadData];

            break;
        default:
            break;
    }
    
    _backgroundView.hidden = !sender.selected;
    
}
-(void)backBtn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)done111:(NSNotification *)notification{
    //done按钮的操作
    
    if ([self.searchTextField.text isEqualToString:@""] ||[self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 ) {
        
        
    }else{
        
        _keyWordString = _searchTextField.text;
        
        [self initData];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _classIDString = nil;
   
    areaIdString = nil;
    
    choiceString = nil;
    
    _classNameString = nil;
    
    if (_isRootNav) {
        
        [YY_APPDELEGATE.tabBarControll.tabBar setHidden:YES];
    }
    
    [self initView];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_isRootNav) {
        
        [YY_APPDELEGATE.tabBarControll.tabBar setHidden:NO];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    _keyWordString = textField.text;
    
    [self initData];
    
    return YES;
}
-(void)initView
{
 
    _subClassTableView.hidden = YES;
   
    _subAreaTableView.hidden = YES;
    
    _selectedTableView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
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
