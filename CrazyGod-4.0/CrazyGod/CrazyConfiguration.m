//
//  CrazyConfiguration.m
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "CrazyConfiguration.h"
#import "TMCache.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"
#import "CrazyGuideView.h"
#import "UIAlertView+BlocksKit.h"

@implementation CrazyConfiguration

+ (instancetype)sharedManager {
    
    static CrazyConfiguration *_sharedManager = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedManager = [[self alloc] init];
        
    });
    
    return _sharedManager;
}
- (instancetype)init
{
    self = [super init];
   
    if (self) {
    
        [self initCrazyConfiguration];
        
    }
    return self;
}

-(void)initCrazyConfiguration{
    //[CrazyDB shareDBName:@"mydatabase.sqlite"];//初始化数据库
    [self ConfigGuide];//初始化导航页
    //[self ConfigBackBtn]; //初始化返回按钮
    //[self ConfigTMCache]; //初始化缓存时间
    [self ConfigIQKeyboard];//初始化键盘
    //[self ConfigSVProgressHUD];//初始化挡板
    [self ConfigToast];//初始化Toast
    //[self ConfigVersion];//初始化版本升级提示
    //[self ConfigAppirater];//初始化app打分提示
}
-(void)ConfigGuide{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Guide"] == nil) {
      
        CrazyGuideView * guide = [[CrazyGuideView alloc]init];
        
        guide.pageCtr.hidden = YES;
        
        [guide createLocationImageArr:@[@"yindao1",@"yindao2",@"yindao3"] block:^{
//            @"good111",@"good222"
           
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Guide"];
            
        }];
    }
}
-(void)ConfigBackBtn{
    
    self.backBtnImage_NAME = @"Tback.png";
    
    self.backBtnImage_FRAME = CGRectMake(0, 0, 20, 30);
}
-(void)ConfigTMCache{
    //几分钟清除缓存
    int time = 600; //秒
    
    TMCache * cache =[TMCache sharedCache];
    
    cache.diskCache.ageLimit = time;
    
    cache.memoryCache.ageLimit =time;
    
}
-(void)ConfigIQKeyboard{
    
    IQKeyboardManager * manager  = [IQKeyboardManager sharedManager];
    
    manager.enable = YES ;
    
    manager.shouldResignOnTouchOutside = YES;
    
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    manager.enableAutoToolbar = YES;
}
-(void)ConfigSVProgressHUD{
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeOpaque];
    
//    UIView *custumView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    custumView.backgroundColor = [UIColor redColor];
//    [SVProgressHUD setViewForExtension:custumView];
}
-(void)ConfigToast{
    //center 中间位置  under下面位置
    self.ToastLocaton = under;
}
-(void)ConfigVersion{
    
//    [ZMYVersionNotes isAppVersionUpdatedWithAppIdentifier:@"1045380671" updatedInformation:^(NSString *releaseNoteText, NSString *releaseVersionText, NSDictionary *resultDic) {
//        
//        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已更新版本:%@", releaseVersionText] message:releaseNoteText delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        createUserResponseAlert.tag = 1101;
//        [createUserResponseAlert show];
//        
//    } latestVersionInformation:^(NSString *releaseNoteText, NSString *releaseVersionText, NSDictionary *resultDic) {
//     
//        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:[NSString stringWithFormat:@"有新版本:%@", releaseVersionText] message:releaseNoteText cancelButtonTitle:@"忽略" otherButtonTitles:@[@"进行下载", @"下次再说"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex ==1) {
//                NSString * url = @"http://www.baidu.com";
//                
//                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
//            }
//            
//        }];
//        [alert show];
//        
//    } completionBlockError:^(NSError *error) {
//        NSLog(@"An error occurred: %@", [error localizedDescription]);
//    }];
}
-(void)ConfigAppirater{
//    [Appirater setAppId:@"1045380671"];
//    [Appirater setDaysUntilPrompt:1];
//    [Appirater setUsesUntilPrompt:50];
//    [Appirater setSignificantEventsUntilPrompt:-1];
//    [Appirater setTimeBeforeReminding:2];
//    [Appirater setDebug:NO];
//    [Appirater appLaunched:YES];
}
@end
