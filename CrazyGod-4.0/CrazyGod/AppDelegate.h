//
//  AppDelegate.h
//  CrazyGod
//
//  Created by 英峰 on 2019/1/3.
//  Copyright © 2019年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "crazyShakeWindow.h"

#import "XTBaseTabBarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) crazyShakeWindow *window;

@property (strong,nonatomic)XTBaseTabBarViewController *tabBarControll;


@end

