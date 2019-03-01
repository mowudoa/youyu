//
//  XTBaseTabBarViewController.m
//  StarGroupBuying
//
//  Created by 英峰 on 2018/12/17.
//  Copyright © 2018年 英峰. All rights reserved.
//

#import "XTBaseTabBarViewController.h"
#import "XTBaseNavController.h"
#import "XTBaseTabBar.h"

@interface XTBaseTabBarViewController ()<
XTBaseTabBarDelegate
>

@property(nonatomic,strong) XTBaseTabBar *baseTabBar;

@end

@implementation XTBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTabBar];
    
    [self.tabBar addSubview:self.baseTabBar];
}
-(XTBaseTabBar *)baseTabBar
{
    if (!_baseTabBar) {
        
        _baseTabBar = [[XTBaseTabBar alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.tabBar.size.height)];
        
        _baseTabBar.delegate = self;
    }
    return _baseTabBar;
    
}
-(void)createTabBar
{
    //添加子控制器
    NSArray* controllers = @[@"HZDSHome",@"HZDSBusiness",@"HZDSShoppingMall",@"HZDSMine"];
    
    NSMutableArray *ViewControllers = [[NSMutableArray alloc] init];
    for (int i = 0 ; i<controllers.count ;i++) {
        
        NSString* str = controllers[i];
        
        NSString* controllerName = [NSString stringWithFormat:@"%@ViewController",str];
        
        Class className = NSClassFromString(controllerName);
        
        UIViewController* VC = [[className alloc]init];
        
        XTBaseNavController* nav = [[XTBaseNavController alloc]initWithRootViewController:VC];
        
        [nav.navigationBar setBarTintColor:[UIColor redColor]];
        
        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        
        [nav.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName: [UIColor whiteColor],
           NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        
        [ViewControllers addObject:nav];
        
    }
    
    self.viewControllers = ViewControllers;
 
}


-(void)tabBar:(XTBaseTabBar *)tabBar itemIndex:(NSUInteger)index
{
    
    self.selectedIndex = index;
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
