//
//  HZDSLinkWebViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/5.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSLinkWebViewController.h"

@interface HZDSLinkWebViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *backGroundView;

@end

@implementation HZDSLinkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];

}
-(void)initData
{
    NSDictionary *dic = @{@"content_id":_adv_id};
    
    
    [CrazyNetWork CrazyRequest_Get:[NSString stringWithFormat:@"%@%@",HEADURL,HOME_ADV_DETAIl] parameters:dic HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"广告详情", dic);
        
        
        if (SUCCESS) {
            
            [self initUI:dic[@"datas"][@"detail"]];
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
        LOG(@"cuow", Json);
        
    }];
}
-(void)initUI:(NSDictionary *)dic
{
    self.navigationItem.title = dic[@"title"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,10,SCREEN_WIDTH - 40,30)];
    
    label.text = [NSString stringWithFormat:@"发布日期:%@",[self ConvertStrToTime:dic[@"create_time"]]];
    
    label.font = [UIFont systemFontOfSize:13];
    
    label.textColor = [UIColor blackColor];
    
    [_backGroundView addSubview:label];
    
    
    UILabel *label1 = [[UILabel alloc] init];
    
    //  label1.text = rushIntroduce;
    
    NSString *infoStr = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",SCREEN_WIDTH - 20,dic[@"contents"]];
    
    NSData *data = [infoStr dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                
                                                               options:options
                                
                                                    documentAttributes:nil
                                
                                                                 error:nil];
    
    
    label1.attributedText = html;
    
    CGSize size = [label1.attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    label1.frame = CGRectMake(10,50, SCREEN_WIDTH - 20,size.height);
    
    label1.numberOfLines = 0;
    
    label1.font  = [UIFont systemFontOfSize:12];
    
    [self.backGroundView addSubview:label1];
    
    _backGroundView.contentSize = CGSizeMake(0,label1.frame.size.height + 50);
    
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
