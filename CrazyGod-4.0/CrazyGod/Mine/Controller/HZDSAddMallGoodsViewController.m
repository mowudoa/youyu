//
//  HZDSAddMallGoodsViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/29.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSAddMallGoodsViewController.h"
#import "HZDSSubClassTableViewCell.h"
#import "AFHTTPSessionManager.h"
#import "HZDSClassifyModel.h"
#import "HZDSSubClassModel.h"
@interface HZDSAddMallGoodsViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
{
    HZDSClassifyModel* _classModel;
    HZDSSubClassModel* _subClassModel;
    HZDSSubClassModel* _freightModel;
}

@property (weak, nonatomic) IBOutlet UIScrollView *backGroundScrollview;

@property (weak, nonatomic) IBOutlet UITableView *freightTypeTableView;

@property (weak, nonatomic) IBOutlet UITableView *classOneTableiew;

@property (weak, nonatomic) IBOutlet UITableView *classTwoTableView;

@property (weak, nonatomic) IBOutlet UIButton *thumbButton;

@property (weak, nonatomic) IBOutlet UIButton *bannerButton;

@property (weak, nonatomic) IBOutlet UIButton *bannerButton1;

@property (weak, nonatomic) IBOutlet UIButton *bannerButton2;

@property (weak, nonatomic) IBOutlet UITextField *businessTitle;

@property (weak, nonatomic) IBOutlet UITextField *businesssubTitle;

@property (weak, nonatomic) IBOutlet UITextField *goodsSpec;

@property (weak, nonatomic) IBOutlet UITextField *goodsStockNum;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;

@property (weak, nonatomic) IBOutlet UIButton *noButton;

@property (weak, nonatomic) IBOutlet UITextField *goodsWeight;

@property (weak, nonatomic) IBOutlet UIButton *freightButton;

@property (weak, nonatomic) IBOutlet UIButton *classOneButton;

@property (weak, nonatomic) IBOutlet UIButton *classTwoButton;

@property (weak, nonatomic) IBOutlet UITextField *goodsPrice;

@property (weak, nonatomic) IBOutlet UITextField *goodsMallPrice;

@property (weak, nonatomic) IBOutlet UIButton *endDateButton;

@property (weak, nonatomic) IBOutlet UITextView *buyInfoTextView;

@property (weak, nonatomic) IBOutlet UITextView *goodsInfoTextView;

@property (weak, nonatomic) IBOutlet UIButton *addGoodsButton;

@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property(nonatomic,strong) NSMutableArray *classTypeDataSource;

@property(nonatomic,strong) NSMutableArray *subClassTypeDataSource;

@property(nonatomic,copy) NSMutableArray *freightTypeDataSource;

@property(nonatomic,copy) NSString *choiceString;

@property(nonatomic,copy) NSString *choiceImageString;

@property(nonatomic,copy) NSString *thumbUrlString;

@property(nonatomic,copy) NSString *bannerUrlString;

@property(nonatomic,copy) NSString *bannerUrlString2;

@property(nonatomic,copy) NSString *bannerUrlString3;

@end

@implementation HZDSAddMallGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    _classTypeDataSource = [[NSMutableArray alloc] init];
    
    _subClassTypeDataSource = [[NSMutableArray alloc] init];
    
    _freightTypeDataSource = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    if (_addgoodsType == addMallGoodsType) {
     
        [self initData];

        _buyInfoTextView.hidden = NO;
        
        _goodsInfoTextView.hidden = NO;
        
        [_addGoodsButton setTitle:@"添加商品" forState:UIControlStateNormal];
        
        self.navigationItem.title = @"添加商品";

    }else if (_addgoodsType == editMallGoodsType){
        
        [self initEditData];

        _buyInfoTextView.hidden = YES;
        
        _goodsInfoTextView.hidden = YES;
        
        [_addGoodsButton setTitle:@"编辑商品" forState:UIControlStateNormal];

        self.navigationItem.title = @"编辑商品";

    }
    
}
-(void)initUI
{
    
    [WYFTools CreateTextPlaceHolder:@"购买须知,建议不超过100字" WithFont:[UIFont systemFontOfSize:14] WithSuperView:_buyInfoTextView];
    
    [WYFTools CreateTextPlaceHolder:@"添加商品详情,建议不超过200字,如需上传文章详情图,建议使用电脑端" WithFont:[UIFont systemFontOfSize:14] WithSuperView:_goodsInfoTextView];
    
    [WYFTools viewLayer:5 withView:_addGoodsButton];
    
    [WYFTools viewLayer:5 withView:_buyInfoTextView];
    
    [WYFTools viewLayerBorderWidth:1 borderColor:[UIColor colorWithHexString:@"f5f5f5"] withView:_buyInfoTextView];
    
    
    [WYFTools viewLayer:5 withView:_goodsInfoTextView];
    
    [WYFTools viewLayerBorderWidth:1 borderColor:[UIColor colorWithHexString:@"f5f5f5"] withView:_goodsInfoTextView];
}
-(void)registercell
{
    
    UINib* nib1 = [UINib nibWithNibName:@"HZDSSubClassTableViewCell" bundle:nil];
   
    [_classOneTableiew registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];
    
    [_classTwoTableView registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];
    
    [_freightTypeTableView registerNib:nib1 forCellReuseIdentifier:@"SubClassTableViewCell"];
    
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:MALL_MANAGE_ADDGOODS parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"分类列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.classTypeDataSource removeAllObjects];
       
        [strongSelf.freightTypeDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *classArr = dic[@"datas"][@"cates"];
            
            
            for (NSDictionary *classDic in classArr) {
                
                HZDSClassifyModel *model = [[HZDSClassifyModel alloc] init];
                
                model.classId = classDic[@"cate_id"];
                
                model.className = classDic[@"cate_name"];
                
                NSArray *subClassArr = classDic[@"son"];
                
                for (NSDictionary *subDic in subClassArr) {
                    
                    HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                    
                    model1.classId = subDic[@"cate_id"];
                    
                    model1.className = subDic[@"cate_name"];
                    
                    [model.subClassArray addObject:model1];
                    
                }
                [strongSelf.classTypeDataSource addObject:model];
            }
           
            NSArray *freightArr = dic[@"datas"][@"kuaidi"];
            
            for (NSDictionary *freightDic in freightArr) {
                
                HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                
                model1.classId = freightDic[@"id"];
                
                model1.className = freightDic[@"name"];
                
                [strongSelf.freightTypeDataSource addObject:model1];

            }
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
}
-(void)initEditData
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"goods_id":_goods_id};
    
    [CrazyNetWork CrazyRequest_Get:MALL_MANAGE_EDITGOODS parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"编辑页面", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.classTypeDataSource removeAllObjects];
       
        [strongSelf.freightTypeDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *classArr = dic[@"datas"][@"cates"];
            
            
            for (NSDictionary *classDic in classArr) {
                
                HZDSClassifyModel *model = [[HZDSClassifyModel alloc] init];
                
                model.classId = classDic[@"cate_id"];
                
                model.className = classDic[@"cate_name"];
                
                
                NSArray *subClassArr = classDic[@"son"];
                
                for (NSDictionary *subDic in subClassArr) {
                    
                    HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                    
                    model1.classId = subDic[@"cate_id"];
                    
                    model1.className = subDic[@"cate_name"];
                    
                    [model.subClassArray addObject:model1];
                    
                }
                [strongSelf.classTypeDataSource addObject:model];
            }
            
            NSArray *freightArr = dic[@"datas"][@"kuaidi"];
            
            for (NSDictionary *freightDic in freightArr) {
                
                HZDSSubClassModel *model1 = [[HZDSSubClassModel alloc] init];
                
                model1.classId = freightDic[@"id"];
                
                model1.className = freightDic[@"name"];
                
                [strongSelf.freightTypeDataSource addObject:model1];
                
            }
            
            NSArray *photoArr = dic[@"datas"][@"photos"];
            
            [self initBannerImage:photoArr];
            
            [strongSelf.thumbButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,dic[@"datas"][@"detail"][@"photo"]]] forState:UIControlStateNormal];

            strongSelf.thumbUrlString = dic[@"datas"][@"detail"][@"photo"];
            
            strongSelf.businessTitle.text = dic[@"datas"][@"detail"][@"title"];
            
            strongSelf.businesssubTitle.text = dic[@"datas"][@"detail"][@"intro"];
            
            strongSelf.goodsSpec.text = dic[@"datas"][@"detail"][@"guige"];
            
            strongSelf.goodsStockNum.text = dic[@"datas"][@"detail"][@"num"];

            strongSelf.businessTitle.text = dic[@"datas"][@"detail"][@"title"];

            if ([dic[@"datas"][@"detail"][@"is_reight"] isEqualToString:@"0"]) {
               
                strongSelf.yesButton.selected = YES;
                
                strongSelf.noButton.selected = NO;
                
                strongSelf.choiceString = @"0";
                
            }else{
                
                strongSelf.yesButton.selected = NO;
               
                strongSelf.noButton.selected = YES;
                
                strongSelf.choiceString = @"1";
                
            }
            
            strongSelf.goodsWeight.text = dic[@"datas"][@"detail"][@"weight"];

            strongSelf.goodsMallPrice.text = [dic[@"datas"][@"detail"][@"mall_price"] stringValue];

            strongSelf.goodsPrice.text = [dic[@"datas"][@"detail"][@"price"] stringValue];

            [strongSelf.endDateButton setTitle:dic[@"datas"][@"detail"][@"end_date"] forState:UIControlStateNormal];
        }
        
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}
-(void)initBannerImage:(NSArray *)bannerArr
{
   
    for (int i = 0; i < bannerArr.count; i ++) {
        
        if (i == 0) {
            
            [_bannerButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,bannerArr[i][@"photo"]]] forState:UIControlStateNormal];
           
            _bannerUrlString = bannerArr[i][@"photo"];
        }
        if (i == 1) {
            
            [_bannerButton1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,bannerArr[i][@"photo"]]] forState:UIControlStateNormal];
           
            _bannerUrlString2 = bannerArr[i][@"photo"];

        }
        if (i == 2) {
            
            [_bannerButton2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,bannerArr[i][@"photo"]]] forState:UIControlStateNormal];
            
            _bannerUrlString3 = bannerArr[i][@"photo"];

        }
    }
    
}
- (IBAction)freightYesOrNo:(UIButton *)sender {

    //100-101
    if (sender.tag == 100) {
        
        _yesButton.selected = YES;
        
        _noButton.selected = NO;
        
        _choiceString = @"0";
    }else{
        
        _yesButton.selected = NO;
       
        _noButton.selected = YES;
        
        _choiceString = @"1";
    }
}
//运费模板
- (IBAction)freightClick:(UIButton *)sender {

    sender.selected = !sender.selected;

    _classTwoTableView.hidden = YES;
    
    _classOneTableiew.hidden = YES;
    
    _freightTypeTableView.hidden = !sender.selected;
    
    [_freightTypeTableView reloadData];
    
}
//商品分类
- (IBAction)classClick:(UIButton *)sender {

    //200-201
    sender.selected = !sender.selected;
    
    
    if (sender.tag == 200) {
       
        _classOneTableiew.hidden = !sender.selected;
        
        _classTwoTableView.hidden = YES;
        
        _freightTypeTableView.hidden = YES;
        
        [_classOneTableiew reloadData];
        
    }else if (sender.tag == 201){
        
        
        if (_classModel == nil) {
            
            [JKToast showWithText:@"请选择一级分类"];
            
            return;
        }
        
        _classTwoTableView.hidden = !sender.selected;
        
        _classOneTableiew.hidden = YES;
        
        _freightTypeTableView.hidden = YES;

        [_classTwoTableView reloadData];
        
    }
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _classOneTableiew) {
        
        return _classTypeDataSource.count;
        
    }else if (tableView == _classTwoTableView)
    {
        
        return _subClassTypeDataSource.count;
        
    }else
    {
        
        return _freightTypeDataSource.count;
        
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZDSSubClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubClassTableViewCell" forIndexPath:indexPath];

    
    if (tableView == _classOneTableiew) {
      
        HZDSClassifyModel *model = _classTypeDataSource[indexPath.row];
        
        cell.nameLabel.text = model.className;

        
    }else if (tableView == _classTwoTableView)
    {
        
        HZDSSubClassModel *model = _subClassTypeDataSource[indexPath.row];

        
        cell.nameLabel.text = model.className;
    }else
    {
        
        HZDSSubClassModel *model = _freightTypeDataSource[indexPath.row];
        
        cell.nameLabel.text = model.className;

    }
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _classOneTableiew) {
        
        HZDSClassifyModel *model = _classTypeDataSource[indexPath.row];
        
        [_subClassTypeDataSource removeAllObjects];
        
        [_subClassTypeDataSource addObjectsFromArray:model.subClassArray];
        
        _classModel = model;
        
        _subClassModel = nil;
        
        [_classOneButton setTitle:model.className forState:UIControlStateNormal];
        
        [_classTwoButton setTitle:@"请选择" forState:UIControlStateNormal];
        
        _classOneTableiew.hidden = YES;
        
    }else if (tableView == _classTwoTableView)
    {
        HZDSSubClassModel *model = _subClassTypeDataSource[indexPath.row];

        _subClassModel = model;
       
        [_classTwoButton setTitle:model.className forState:UIControlStateNormal];
        
        _classTwoTableView.hidden = YES;
    }else
    {
        HZDSSubClassModel *model = _freightTypeDataSource[indexPath.row];
        
        _freightModel = model;
        
        [_freightButton setTitle:model.className forState:UIControlStateNormal];
        
        _freightTypeTableView.hidden = YES;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 35;
}

//过期时间选择
- (IBAction)endDateClick:(UIButton *)sender {

    self.dateView.hidden = NO;
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.dateView.frame = CGRectMake(0,SCREEN_HEIGHT-300,SCREEN_WIDTH,300);
        
    } completion:^(BOOL finished) {
    }];
}
//添加商品
- (IBAction)addGoods:(UIButton *)sender {

    if (_addgoodsType == addMallGoodsType) {
        
        [self addMallGoods];
        
    }else if (_addgoodsType == editMallGoodsType){
        
        [self editMallGoods];
        
    }
 
    
}
-(void)addMallGoods
{
    
    if ([_businessTitle.text isEqualToString:@""] || [_businessTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"商品名字不可为空"];
        
    }else if ([_businesssubTitle.text isEqualToString:@""] || [_businesssubTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
       
        [JKToast showWithText:@"商品简介不可为空"];
        
    }else if ([_goodsSpec.text isEqualToString:@""] || [_goodsSpec.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
       
        [JKToast showWithText:@"商品规格不可为空"];
        
    }else if ([_goodsStockNum.text isEqualToString:@""] || [_goodsStockNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
       
        [JKToast showWithText:@"商品库存不可为空"];
        
    }else if ([_goodsWeight.text isEqualToString:@""] || [_goodsWeight.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
       
        [JKToast showWithText:@"商品重量不可为空"];
        
    }else if ([_buyInfoTextView.text isEqualToString:@""] || [_buyInfoTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
      
        [JKToast showWithText:@"购买须知不可为空"];
        
    }else if ([_goodsInfoTextView.text isEqualToString:@""] || [_goodsInfoTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
      
        [JKToast showWithText:@"商品信息不可为空"];
        
    }else if ([_endDateButton.currentTitle isEqualToString:@"请选择"]){
      
        [JKToast showWithText:@"过期时间不可为空"];
        
    }else if (_thumbUrlString == nil){
        
        [JKToast showWithText:@"请上传缩略图"];
        
    }else if (_bannerUrlString == nil){
        
        [JKToast showWithText:@"请上传商品图"];
        
    }else if ([_classOneButton.currentTitle isEqualToString:@"请选择"]){
        
        [JKToast showWithText:@"请选择分类"];
        
    }else if ([_classTwoButton.currentTitle isEqualToString:@"请选择"]){
      
        [JKToast showWithText:@"请选择子分类"];
        
    }else if ([_freightButton.currentTitle isEqualToString:@"请选择"]){
       
        [JKToast showWithText:@"请选择快递模板"];
        
    }else{
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSDictionary * dict = @{@"photo":_thumbUrlString,
                                @"photos[]":_bannerUrlString,
                                @"title":_businessTitle.text,
                                @"intro":_businesssubTitle.text,
                                @"guige":_goodsSpec.text,
                                @"num":_goodsStockNum.text,
                                @"is_reight":_choiceString,
                                @"weight":_goodsWeight.text,
                                @"kuaidi_id":_freightModel.classId,
                                @"cate_id":_subClassModel.classId,
                                @"price":_goodsPrice.text,
                                @"mall_price":_goodsMallPrice.text,
                                @"end_date":_endDateButton.currentTitle,
                                @"instructions":_buyInfoTextView.text,
                                @"details":_goodsInfoTextView.text
                                };
        
        [dic addEntriesFromDictionary:dict];
        
        if (_bannerUrlString3 != nil) {
            
            [dic addEntriesFromDictionary:@{@"photos[]":_bannerUrlString3}];
        }
        if (_bannerUrlString2 != nil) {
            
            [dic addEntriesFromDictionary:@{@"photos[]":_bannerUrlString2}];
            
        }
        
        [CrazyNetWork CrazyRequest_Post:MALL_MANAGE_ADDGOODS parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"添加商品", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
        
    }
}
-(void)editMallGoods
{
    if ([_businessTitle.text isEqualToString:@""] || [_businessTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"商品名字不可为空"];
        
    }else if ([_businesssubTitle.text isEqualToString:@""] || [_businesssubTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商品简介不可为空"];
        
    }else if ([_goodsSpec.text isEqualToString:@""] || [_goodsSpec.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商品规格不可为空"];
        
    }else if ([_goodsStockNum.text isEqualToString:@""] || [_goodsStockNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商品库存不可为空"];
        
    }else if ([_goodsWeight.text isEqualToString:@""] || [_goodsWeight.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        
        [JKToast showWithText:@"商品重量不可为空"];
        
    }else if ([_endDateButton.currentTitle isEqualToString:@"请选择"]){
        
        [JKToast showWithText:@"过期时间不可为空"];
        
    }else if (_thumbUrlString == nil){
        
        [JKToast showWithText:@"请上传缩略图"];
        
    }else if (_bannerUrlString == nil){
        
        [JKToast showWithText:@"请上传商品图"];
        
    }else if ([_classOneButton.currentTitle isEqualToString:@"请选择"]){
        
        [JKToast showWithText:@"请选择分类"];
        
    }else if ([_classTwoButton.currentTitle isEqualToString:@"请选择"]){
        [JKToast showWithText:@"请选择子分类"];
        
    }else if ([_freightButton.currentTitle isEqualToString:@"请选择"]){
        [JKToast showWithText:@"请选择快递模板"];
        
    }else{
        
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
        
        NSDictionary * dict = @{@"goods_id":_goods_id,
                                @"photo":_thumbUrlString,
                                @"photos[]":_bannerUrlString,
                                @"title":_businessTitle.text,
                                @"intro":_businesssubTitle.text,
                                @"guige":_goodsSpec.text,
                                @"num":_goodsStockNum.text,
                                @"is_reight":_choiceString,
                                @"weight":_goodsWeight.text,
                                @"kuaidi_id":_freightModel.classId,
                                @"cate_id":_subClassModel.classId,
                                @"price":_goodsPrice.text,
                                @"mall_price":_goodsMallPrice.text,
                                @"end_date":_endDateButton.currentTitle
                                };
        
        [dic1 addEntriesFromDictionary:dict];
        
        if (_bannerUrlString3 != nil) {
            
            [dic1 addEntriesFromDictionary:@{@"photos[]":_bannerUrlString3}];
        }
        if (_bannerUrlString2 != nil) {
            
            [dic1 addEntriesFromDictionary:@{@"photos[]":_bannerUrlString2}];
            
        }
        
        [CrazyNetWork CrazyRequest_Post:MALL_MANAGE_EDITGOODS parameters:dic1 HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"编辑商品", dic);
            
            if (SUCCESS) {
                
                [JKToast showWithText:dic[@"datas"][@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [JKToast showWithText:dic[@"datas"][@"error"]];
                
            }
            
        } fail:^(NSError *error, NSString *url, NSString *Json) {
            
        }];
    }
    
}
-(void)viewDidLayoutSubviews
{
    UIView* conView = (UIView*)[_backGroundScrollview viewWithTag:2048];
    
    UIView* conView1 = (UIView*)[_backGroundScrollview viewWithTag:1024];
    
    if (_addgoodsType == editMallGoodsType){
        
        conView.frame = CGRectMake(conView.frame.origin.x,conView1.mj_y + conView1.height + 40, conView.width, conView.height);
        
    }
    
    _backGroundScrollview.contentSize = CGSizeMake(0, conView.frame.origin.y+conView.frame.size.height + 10);

    [UIView animateWithDuration:0.5f animations:^{
        
        self.dateView.frame = CGRectMake(0,SCREEN_HEIGHT,0.01, 0.01);
        
    } completion:^(BOOL finished) {
        self.dateView.hidden = YES;
    }];
    
}
- (IBAction)cancleButton:(UIBarButtonItem *)sender {

    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.dateView.frame = CGRectMake(0,SCREEN_HEIGHT,0.01, 0.01);
    } completion:^(BOOL finished) {
        self.dateView.hidden = YES;
    }];
}
- (IBAction)choiceButton:(id)sender {

    NSDate *selected = [self.datePickerView date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    [_endDateButton setTitle:destDateString forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5f animations:^{
       
        self.dateView.frame = CGRectMake(0,SCREEN_HEIGHT,0.01, 0.01);
        
    } completion:^(BOOL finished) {
        
        self.dateView.hidden = YES;
        
    }];
}
-(UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        
        _imagePicker = [[UIImagePickerController alloc] init];
       
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        _imagePicker.allowsEditing = YES;
        
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (IBAction)choiceImage:(UIButton *)sender {

    if (sender.tag == 200) {
      
        _choiceImageString = @"1";
        
    }else if (sender.tag == 201){
        
        _choiceImageString = @"2";
    }else if (sender.tag == 202){
        
        _choiceImageString = @"3";

    }else if (sender.tag == 203){
        
        _choiceImageString = @"4";
    }
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
            
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}
#pragma mark ==== UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(changePhoto:) withObject:orgImage afterDelay:0.1];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changePhoto:(UIImage*)image
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:UPLOADIMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageDatas = UIImageJPEGRepresentation(image,0.4);
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"====成功====");
        
        [self saveUrl:responseObject withImage:image];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        NSLog(@"======失败======");
        
    }];
    
    
}
-(void)saveUrl:(NSDictionary *)dic withImage:(UIImage *)image
{
    
    if ([_choiceImageString isEqualToString:@"1"]) {
        
        [_thumbButton setImage:image forState:UIControlStateNormal];

        _thumbUrlString = dic[@"url"];

    }else if([_choiceImageString isEqualToString:@"2"]){
        
        [_bannerButton setImage:image forState:UIControlStateNormal];
        
        _bannerUrlString = dic[@"url"];

    }else if([_choiceImageString isEqualToString:@"3"]){
        
        [_bannerButton1 setImage:image forState:UIControlStateNormal];
        
        _bannerUrlString2 = dic[@"url"];
        
    }else if([_choiceImageString isEqualToString:@"4"]){
        
        [_bannerButton2 setImage:image forState:UIControlStateNormal];
        
        _bannerUrlString3 = dic[@"url"];
        
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
