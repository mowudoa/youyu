//
//  CrazyViewController.h
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CrazyBackBlock)(void) ;

@interface CrazyViewController : UIViewController

@property(nonatomic,strong)CrazyBackBlock backBlock;

-(void)backBlock:(CrazyBackBlock)block;
-(void)pushNaviHiddenController:(UIViewController *)vc animated:(bool)animated;
-(void)pushNaviShowController:(UIViewController *)vc animated:(bool)animated;
-(void)popNaviHiddenController:(bool)animated;
-(void)popNaviShowController:(bool)animated;
@end
