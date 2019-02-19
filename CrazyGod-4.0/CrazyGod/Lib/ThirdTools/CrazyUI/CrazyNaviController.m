//
//  CrazyNaviController.m
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "CrazyNaviController.h"

@interface CrazyNaviController ()

@end

@implementation CrazyNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.navigationBar.backgroundColor = backgroundColor;
}

-(void)setTextColor:(UIColor *)textColor{
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:textColor};
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}


@end
