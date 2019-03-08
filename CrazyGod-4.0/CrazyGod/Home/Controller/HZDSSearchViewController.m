//
//  HZDSSearchViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/7.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSSearchViewController.h"
#import "HZDSBusinessViewController.h"

@interface HZDSSearchViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *businessBtn;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UIView *textbackgroundView;

@property (weak, nonatomic) IBOutlet UIView *historySearch;

@property (weak, nonatomic) IBOutlet UIView *hotSearch;

@property(nonatomic,strong) NSMutableArray *historySearchArray;

@property (weak, nonatomic) IBOutlet UITextField *keyWordTextField;

@property(nonatomic,strong) NSMutableArray *hotSearchArray;

@end

@implementation HZDSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _historySearchArray = [[NSMutableArray alloc] init];
    
    _hotSearchArray = [[NSMutableArray alloc] init];
    
    
    self.navigationItem.title = @"商家搜索";
    
}
-(void)initData
{
    
    __weak typeof(self) weakSelf = self;
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,HOMESEARCH] parameters:nil HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"搜索列表", dic);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.historySearchArray removeAllObjects];
       
        [strongSelf.hotSearchArray removeAllObjects];
        
        if (SUCCESS) {
            
            NSDictionary *cityList = dic[@"datas"];
            
            NSArray *arr = cityList[@"word"];
            
            if (arr.count == 0) {
            
                
            }else{
                
                [strongSelf.historySearchArray addObjectsFromArray:arr];
            }
            
            NSArray *array = [cityList[@"keys"] allKeys];
            
            for (NSString *keyString in array) {
                
                NSDictionary *dict = cityList[@"keys"][keyString];
                
                [strongSelf.hotSearchArray addObject:dict[@"keyword"]];
                
            }
            
        }
        
        [self initUI];
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
    
    
}
-(void)initUI
{
    float height;
    
    float height1;
    
    for (UIView *view in _historySearch.subviews) {
        
        [view removeFromSuperview];
    }
    for (UIView *view in _hotSearch.subviews) {
        
        [view removeFromSuperview];
    }
    
    height = [WYFTools heightWithCreateTagLabel:[UIFont systemFontOfSize:12] tagArray:_hotSearchArray itemSpace:2 itemHeight:20 currentX:0 currentY:0 superView:_hotSearch action:@selector(click:) vc:(id)self buttonUserEnable:YES];
    
    height1 = [WYFTools heightWithCreateTagLabel:[UIFont systemFontOfSize:12] tagArray:_historySearchArray itemSpace:2 itemHeight:20 currentX:0 currentY:0 superView:_historySearch action:@selector(click1:) vc:self buttonUserEnable:YES];
    
    [WYFTools viewLayerBorderWidth:1 borderColor:[UIColor colorWithHexString:@"f5f5f5"] withView:_businessBtn];
    
    [WYFTools viewLayerBorderWidth:1 borderColor:[UIColor colorWithHexString:@"f5f5f5"] withView:_textbackgroundView];
    
}
-(void)click:(UIButton *)sender
{
    
    [self searchBusinessByKeyWord:sender.currentTitle];

}
-(void)click1:(UIButton *)sender
{
    
    [self searchBusinessByKeyWord:sender.currentTitle];

}
- (IBAction)searchByKeyword:(UIButton *)sender {

    [_keyWordTextField resignFirstResponder];
    
    if ([_keyWordTextField.text isEqualToString:@""] || [_keyWordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [JKToast showWithText:@"关键字不可为空"];
    
    }else{
        
        [self searchBusinessByKeyWord:_keyWordTextField.text];
    }

}
-(void)searchBusinessByKeyWord:(NSString *)keyWord
{
    
    HZDSBusinessViewController *business = [[HZDSBusinessViewController alloc] init];
    
    business.keyWordString = keyWord;
    
    business.isRootNav = YES;
    
    [self.navigationController pushViewController:business animated:YES];
    
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
