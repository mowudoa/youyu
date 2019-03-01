//
//  HZDSmerchantInameSetViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/10.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSmerchantInameSetViewController.h"
#import "HZDSmerchantUploadImageViewController.h"
#import "HZDSmerchantImageTableViewCell.h"
#import "HZDSmerchantIMageListModel.h"

@interface HZDSmerchantInameSetViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *imageListTableView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property(nonatomic,strong) NSMutableArray *imageListDataSource;

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@end

@implementation HZDSmerchantInameSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registercell];
    
    _imageListDataSource = [[NSMutableArray alloc] init];

    self.navigationItem.rightBarButtonItem = self.rightItem;
    
}
-(void)initData
{
  
    __weak typeof(self) weakSelf = self;

    [CrazyNetWork CrazyRequest_Post:MERCHANT_IMAGE parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"商户图片列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf.imageListDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
               
                strongSelf.imageListTableView.hidden = NO;
                strongSelf.backgroundView.hidden = YES;
            
            }else{
                
                strongSelf.imageListTableView.hidden = YES;
                
                strongSelf.backgroundView.hidden = NO;
                
            }
            
            
            for (NSDictionary *dict1 in arr) {
                
                HZDSmerchantIMageListModel *model = [[HZDSmerchantIMageListModel alloc] init];
                
                model.imageID = dict1[@"pic_id"];
                
                model.imageTite = dict1[@"title"];
                
                model.imageOrderby = dict1[@"orderby"];
                
                model.iamgecreateTime = dict1[@"create_time"];
                
                model.imageUrl  =dict1[@"photo"];
                
                model.iamgeStatus = dict1[@"audit"];
 
                [strongSelf.imageListDataSource addObject:model];
                
            }
            
        [strongSelf.imageListTableView reloadData];
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
}
-(void)registercell
{
    self.navigationItem.title = @"图片设置";
    
    UINib* nib = [UINib nibWithNibName:@"HZDSmerchantImageTableViewCell" bundle:nil];
    
    [_imageListTableView registerNib:nib forCellReuseIdentifier:@"ImageTableViewCell"];
}
-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setFrame:CGRectMake(0, 0, 30, 30)];
        
        [btn setTitle:@"传图片" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}
#pragma  mark ===TbaleViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _imageListDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSmerchantImageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell" forIndexPath:indexPath];
    
    HZDSmerchantIMageListModel *model = _imageListDataSource[indexPath.section];
    
    
    if (model.imageUrl.length>4 && [[model.imageUrl substringToIndex:4] isEqualToString:@"http"]) {
        
        [cell.Titleiamge sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"baseImage.png"]];

    }else{
        
        [cell.Titleiamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.imageUrl]] placeholderImage:[UIImage imageNamed:@"baseImage.png"]];

    }
    
    
    cell.titleLabel.text = [NSString stringWithFormat:@"标题:%@",model.imageTite];
    
    cell.sortklabel.text = [NSString stringWithFormat:@"排序:%@",model.imageOrderby];

    return cell;
}
-(NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 178;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HZDSmerchantIMageListModel *model = [[HZDSmerchantIMageListModel alloc] init];
    
    model = _imageListDataSource[section];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 31)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [backView addSubview:lineLabel];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5, 30)];
    
    [backView addSubview:view];
    
    UILabel* shanghu = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-5-5, 20)];
    
    shanghu.text = [NSString stringWithFormat:@"ID:%@",model.imageID];
    
    shanghu.textAlignment = NSTextAlignmentLeft;
    
    shanghu.font=[UIFont systemFontOfSize:12];
    
    shanghu.adjustsFontSizeToFitWidth = YES;
    
    [view addSubview:shanghu];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30)];
    
    [backView addSubview:view1];
    
    UILabel* dingdantime = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2-10, 20)];
    
    dingdantime.text =[NSString stringWithFormat:@"上传时间:%@",[self ConvertStrToTime:model.iamgecreateTime]];
    
    dingdantime.textAlignment = NSTextAlignmentRight;
    
    dingdantime.font = [UIFont systemFontOfSize:12];
    
    [view1 addSubview:dingdantime];
    
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HZDSmerchantIMageListModel *model = _imageListDataSource[section];

    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,SCREEN_WIDTH - 20,1)];
    
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f0eff4"];
    
    [view addSubview:lineLabel];
    
    UILabel* zongjia = [[UILabel alloc]initWithFrame:CGRectMake(15, 13,100, 20)];
    
    zongjia.font=[UIFont systemFontOfSize:14];
    
    zongjia.textAlignment = NSTextAlignmentLeft;
    
    zongjia.textColor = [UIColor colorWithHexString:@"BEC2C9"];
    
    [view addSubview:zongjia];
    
    UILabel* price = [[UILabel alloc]initWithFrame:CGRectMake(120, 13,SCREEN_WIDTH - 120 -75 -5, 20)];
    
    [view addSubview:price];
    
    price.tag = section;

    price.textColor = [UIColor colorWithHexString:@"#BEC2C9"];

    price.font=[UIFont systemFontOfSize:14];

    price.textAlignment = NSTextAlignmentLeft;
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [leftBtn setFrame:CGRectMake(SCREEN_WIDTH-75-75, 8, 70, 25)];
    
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    
    leftBtn.layer.cornerRadius = 3;
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    leftBtn.layer.masksToBounds = YES;
    
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"#b5b5b5"];
    
    leftBtn.tag = section;

    [view addSubview:leftBtn];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-75, 8, 70, 25)];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];

    rightBtn.backgroundColor = [UIColor colorWithHexString:@"#ff9980"];

    rightBtn.layer.cornerRadius = 3;

    rightBtn.layer.masksToBounds = YES;

    rightBtn.tag = section;

    [rightBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:rightBtn];
    
    if ([model.iamgeStatus isEqualToString:@"0"]) {
       
        [leftBtn setTitle:@"待审" forState:UIControlStateNormal];
   
    }else if ([model.iamgeStatus isEqualToString:@"1"]){
        
        [leftBtn setTitle:@"正常" forState:UIControlStateNormal];

    }

    view.backgroundColor=[UIColor whiteColor];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
    
}
-(void)tapBtn:(UIButton *)sender
{
    HZDSmerchantIMageListModel *model = [[HZDSmerchantIMageListModel alloc] init];
    
    model = _imageListDataSource[sender.tag];
  
    NSDictionary *dic = @{@"pic_id":model.imageID
                          };
    
    [CrazyNetWork CrazyRequest_Post:MERCHANT_IMAGE_DELETE parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"删除图片", dic);
        
        if (SUCCESS) {
            
            [JKToast showWithText:dic[@"datas"][@"msg"]];

            [self initData];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
}
-(void)rightAction:(UIButton *)sender
{
    HZDSmerchantUploadImageViewController *upload = [[HZDSmerchantUploadImageViewController alloc] init];
    
    [self.navigationController pushViewController:upload animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];

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
