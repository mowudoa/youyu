//
//  HZDSMallEvaluateListViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/28.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSMallEvaluateListViewController.h"
#import "HZDSEvaluateTableViewCell.h"
#import "HZDSevaluateModel.h"

@interface HZDSMallEvaluateListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *evaluateListTableView;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property(nonatomic,strong) NSMutableArray *evaluateListDataSource;
@end

@implementation HZDSMallEvaluateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _evaluateListDataSource = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self registercell];
    
    [self initData];
}
-(void)initUI
{
    self.navigationItem.title = @"商品点评";
    
}
-(void)registercell
{
    
    UINib* nib = [UINib nibWithNibName:@"HZDSEvaluateTableViewCell" bundle:nil];
    
    [_evaluateListTableView registerNib:nib forCellReuseIdentifier:@"EvaluateTableViewCell"];
}
-(void)initData
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary* dic;

    if ([_evaluate_url isEqualToString:RUSHOBUYEVALUATE]) {
        
        dic = @{@"tuan_id":_goods_id};
        
    }else{
        
        dic = @{@"goods_id":_goods_id};
    }
    

    [CrazyNetWork CrazyRequest_Post:[NSString stringWithFormat:@"%@%@",HEADURL,_evaluate_url] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"点评列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.evaluateListDataSource removeAllObjects];
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"list"];
            
            if (arr.count > 0) {
                
            strongSelf.backGroundView.hidden = YES;
                
            strongSelf.evaluateListTableView.hidden = NO;
                
            }else{
            strongSelf.backGroundView.hidden = NO;
                
            strongSelf.evaluateListTableView.hidden = YES;
            }
            
            for (NSDictionary *dic1 in arr) {
                
                HZDSevaluateModel *model = [[HZDSevaluateModel alloc] init];
                
                model.goodsId = dic1[@"goods_id"];
                
                model.userName = dic1[@"nickname"];
                
                if (dic1[@"face"] == NULL || dic1[@"face"] == nil ||dic1[@"face"] == [NSNull null]) {
                    
                    
                }else{
                    
                    model.userImageUrl = dic1[@"face"];
                }
                
                model.goodsEvaluate = dic1[@"contents"];
                
               
                if (dic1[@"reply"] == NULL || dic1[@"reply"] == nil ||dic1[@"reply"] == [NSNull null]) {
                    
                    model.businessReply = @"";
                }else{
                    
                    model.businessReply = dic1[@"reply"];
                }
                
                
                model.evaluateTime = dic1[@"create_time"];
                
                model.evaluateScore = dic1[@"score"];
                
                [strongSelf.evaluateListDataSource addObject:model];
            }
            
            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
        [strongSelf.evaluateListTableView reloadData];
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _evaluateListDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HZDSEvaluateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateTableViewCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];

  
    
    return cell;
}
- (void)configureCell:(HZDSEvaluateTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
   
    HZDSevaluateModel *model = _evaluateListDataSource[indexPath.row];
    
    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultImageUrl,model.userImageUrl]] placeholderImage:[UIImage imageNamed:@"1213per"]];
    
    cell.userName.text = model.userName;
    
    cell.userEvaluate.text = model.goodsEvaluate;
    
    cell.starView.numofStar = [model.evaluateScore intValue];;
    cell.starView.selectingenabled = NO;
    
    cell.timeLabel.text = [self ConvertStrToTime:model.evaluateTime];
    
    cell.businessReply.text = [NSString stringWithFormat:@"商家回复:%@",model.businessReply];
}

#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"EvaluateTableViewCell" cacheByIndexPath:indexPath configuration:^(HZDSEvaluateTableViewCell *cell) {
        
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
