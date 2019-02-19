//
//  CrazyConfiguration.h
//  ocCrazy
//
//  Created by dukai on 16/1/5.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    center,
    under
}ToastEnum;

@interface CrazyConfiguration : NSObject

@property(nonatomic,strong)NSString * backBtnImage_NAME;
@property(nonatomic)CGRect backBtnImage_FRAME;
@property(nonatomic)ToastEnum ToastLocaton;
+ (instancetype)sharedManager;

@end
