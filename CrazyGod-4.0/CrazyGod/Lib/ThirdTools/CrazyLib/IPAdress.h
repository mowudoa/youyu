//
//  IPAdress.h
//  ZiHaiKeJiP2P
//
//  Created by dukai on 15/6/18.
//  Copyright (c) 2015年 dukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAdress : NSObject


#define MAXADDRS    32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();

+ (NSString *)deviceIPAdress; //获取IP
@end
