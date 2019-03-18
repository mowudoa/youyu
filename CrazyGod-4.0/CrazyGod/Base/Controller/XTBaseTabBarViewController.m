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
//tabbar平行页面跳转
-(void)joinBaseController:(NSInteger)index
{
    
    for (int i = 0 ; i < self.viewControllers.count ; i ++) {
        
        if (i == index) {
            
            ((UIButton *)[((UIButton *)[self.baseTabBar.subviews objectAtIndex:i]).subviews objectAtIndex:0]).selected = YES;
           
            ((UILabel *)[((UIButton *)[self.baseTabBar.subviews objectAtIndex:i]).subviews objectAtIndex:1]).textColor =[UIColor colorWithRed:249/255.0 green:58/255.0 blue:101/255.0 alpha:1];
            
        }else{
            
            ((UIButton *)[((UIButton *)[self.baseTabBar.subviews objectAtIndex:i]).subviews objectAtIndex:0]).selected = NO;
            
            ((UILabel *)[((UIButton *)[self.baseTabBar.subviews objectAtIndex:i]).subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
            
        }
        
    }

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
