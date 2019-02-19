//
//  HZDSLinkWebViewController.m
//  CrazyGod
//
//  Created by 英峰 on 2019/1/5.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import "HZDSLinkWebViewController.h"

@interface HZDSLinkWebViewController ()

@end

@implementation HZDSLinkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = self.linkTitle;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - SCREEN_STATUSRECT - SCREEN_NAVRECT)];
    // 创建需要加载的url
    NSURL *url = [NSURL URLWithString:_linkUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加载请求
    [webView loadRequest:request];
    // 将webview加到视图
    [self.view addSubview:webView];
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
