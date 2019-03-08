//
//  XTBaseTabBar.h
//  StarGroupBuying
//
//  Created by 英峰 on 2018/12/17.
//  Copyright © 2018年 英峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTBaseTabBar;

@protocol XTBaseTabBarDelegate <NSObject>

-(void)tabBar:(XTBaseTabBar *)tabBar itemIndex:(NSUInteger)index;

@end

@interface XTBaseTabBar : UIView

@property (nonatomic, weak) id<XTBaseTabBarDelegate> delegate;

@end
