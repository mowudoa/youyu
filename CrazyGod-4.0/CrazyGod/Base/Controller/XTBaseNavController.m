//
//  XTBaseNavController.m
//  StarGroupBuying
//
//  Created by 英峰 on 2018/12/17.
//  Copyright © 2018年 英峰. All rights reserved.
//

#import "XTBaseNavController.h"

@interface XTBaseNavController ()

@end

@implementation XTBaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;

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
