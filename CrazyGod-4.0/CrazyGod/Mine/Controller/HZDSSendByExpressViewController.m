//
//  HZDSSendByExpressViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/28.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSSendByExpressViewController.h"

@interface HZDSSendByExpressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *expressNum;

@property (weak, nonatomic) IBOutlet UIButton *sendGoodsButton;

@property (weak, nonatomic) IBOutlet UILabel *expressName;

@property(nonatomic,strong) NSMutableArray *logisticsArray;

@property(nonatomic,copy) NSString *expressString;

@end

@implementation HZDSSendByExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _logisticsArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"确认发货";
    
    [WYFTools viewLayer:5 withView:_sendGoodsButton];
    
}
- (IBAction)choiceExpress:(UIButton *)sender {

    NSDictionary *dic = @{@"order_id":_orderId};
    
    [CrazyNetWork CrazyRequest_Get:MALL_ORDER_BYEXPRESS parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"快递列表", dic);
        
        if (SUCCESS) {
            
            NSArray *arr = dic[@"datas"][@"logistics"];
            
            [self createActionSheet:arr];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
}
-(void)createActionSheet:(NSArray *)arr
{
 
    [_logisticsArray addObjectsFromArray:arr];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"快递列表" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    for (NSDictionary *dic in arr) {
        
        [alert addAction:[UIAlertAction actionWithTitle:dic[@"express_name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
            [self actionsheetSelected:dic[@"express_id"]];
            
        }]];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)sendGoods:(UIButton *)sender {

    if ([_expressName.text isEqualToString:@""] || [_expressName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
       
        [JKToast showWithText:@"请选择快递"];
  
    }else if ([_expressNum.text isEqualToString:@""] || [_expressNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
      
        [JKToast showWithText:@"请填写快递单号"];
   
    }else{
        
        NSDictionary *dic = @{@"order_id":_orderId,
                              @"express_id":_expressString,
                              @"express_number":_expressNum.text
                              };
        
        [CrazyNetWork CrazyRequest_Post:MALL_ORDER_BYEXPRESS parameters:dic HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
            
            LOG(@"快递发货", dic);
            
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
-(void)actionsheetSelected:(NSString *)expressId
{
    for (NSDictionary *dic in _logisticsArray) {
        
        if ([expressId isEqualToString:dic[@"express_id"]]) {
            
            _expressString = dic[@"express_id"];
            
            _expressName.text = dic[@"express_name"];
        }
        
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
