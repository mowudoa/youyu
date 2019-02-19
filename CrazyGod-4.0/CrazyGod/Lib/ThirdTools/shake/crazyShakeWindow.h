
//  Created by Yang Meyer on 03.02.12.
//  Copyright (c) 2012 compeople. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^crazyShakeBlock)(void);
@interface crazyShakeWindow : UIWindow

@property(nonatomic,strong)crazyShakeBlock Shakeblock;

+(void)shakeBlock:(crazyShakeBlock)block;
+(void)removeBlock;
@end
