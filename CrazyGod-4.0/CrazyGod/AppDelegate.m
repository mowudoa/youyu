//
//  AppDelegate.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/3.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@interface AppDelegate ()<
WXApiDelegate
>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    
    self.window = [[crazyShakeWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    _tabBarControll = [[XTBaseTabBarViewController alloc]init];
    
    self.window.rootViewController = _tabBarControll;
    
    [self checkUserLoginStatus];
    
    
    
    
    [self.window makeKeyAndVisible];
    
    [WXApi registerApp:WXAPPID];

    //初始化
    [CrazyConfiguration sharedManager];
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 跳转到URL scheme中配置的地址
    //NSLog(@"跳转到URL scheme中配置的地址-->%@",url);
    return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)checkUserLoginStatus
{
    
    [CrazyNetWork CrazyRequest_Post:USERLOGINCHECK parameters:nil HUD:NO success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"登录状态检查", dic);
        
        if (SUCCESS) {
            
            
            [USER_DEFAULT setBool:YES forKey:@"isLogin"];
            
            if (dic[@"datas"][@"user"] == NULL || dic[@"datas"][@"user"] == nil ||dic[@"datas"][@"user"] == [NSNull null]) {
              
                [USER_DEFAULT setBool:NO forKey:@"isLogin"];

            }
            
            
            
        }else{
            
            [JKToast showWithText:dic[@"datas"][@"error"]];
            
            [USER_DEFAULT setBool:NO forKey:@"isLogin"];

        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
}

#pragma mark  WXAPIDELEGATE
-(void)onResp:(BaseResp *)resp
{
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            
                case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
               
                if ([[USER_DEFAULT objectForKey:@"payGoodsOrMall"] isEqualToString:@"0"]) {
                  
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggong" object:nil];

                }else if ([[USER_DEFAULT objectForKey:@"payGoodsOrMall"] isEqualToString:@"1"]){
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggongWithMall" object:nil];

                }else if ([[USER_DEFAULT objectForKey:@"payGoodsOrMall"] isEqualToString:@"3"]){
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuchenggongWithRecharge" object:nil];

                }
                

                break;
               default:
                
                if ([[USER_DEFAULT objectForKey:@"payGoodsOrMall"] isEqualToString:@"0"]) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifushibai" object:nil];

                }else if ([[USER_DEFAULT objectForKey:@"payGoodsOrMall"] isEqualToString:@"1"]){
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifushibaiWithall" object:nil];
                    
                }else if ([[USER_DEFAULT objectForKey:@"payGoodsOrMall"] isEqualToString:@"3"]){
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifushibaiWithRecharge" object:nil];

                }
                

                break;
        }
    }
    
    if([resp isKindOfClass:[SendAuthResp class]]){//判断是否为授权登录类
        
        SendAuthResp *req = (SendAuthResp *)resp;
        
        if(req.errCode == 0){
            
            
            [self getWxInfo:req.code];
        }
    }

}

//获取用户微信信息进行账号绑定
-(void)getWxInfo:(NSString *)codeString
{
    NSDictionary *dict = @{@"code":codeString};
    
    [CrazyNetWork CrazyRequest_Post:LINKWCHAT parameters:dict HUD:YES success:^(NSDictionary *dic, NSString *url, NSString *Json) {
        
        LOG(@"微信绑定", dic);
        
        if (SUCCESS) {
            
            
            
        }else{
            
            
        }
        
    } fail:^(NSError *error, NSString *url, NSString *Json) {
        
    }];
    
    
}
-(void)goWX:(NSString *)url
{
    
}
@end
