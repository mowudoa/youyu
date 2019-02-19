//
//  easyflyNetWork.h
//  easyflyDemo
//
//  Created by dukai on 15/5/26.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^success)(NSDictionary *dic,NSString *url,NSString *Json);
typedef void (^fail)(NSError *error,NSString *url,NSString *Json);


@interface CrazyNetWork : NSObject


@property(nonatomic,strong)success block_success;
@property(nonatomic,strong)fail block_fail;

//网络请求
+(void)CrazyRequest_Get:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail;

//网络POST请求  大数据量
+(void)CrazyRequest_Post:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail;

//文件流上传
+(void)CrazyHttpFileUpload:(NSString *)headUrl imageDic:(NSDictionary *)imageDic HUD:(BOOL)hud block:(success)success fail:(fail)fail;

//base64上传
+(void)CrazyHttpBase64Upload:(NSString *)headUrl imageDic:(NSDictionary *)imageDic parameters:(NSDictionary *)parameters HUD:(BOOL)hud block:(success)success fail:(fail)fail;

//网络缓存请求
+(void)CrazyRequestCache_Get:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail;

//网络POST缓存请求  大数据量
+(void)CrazyRequestCache_Post:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail;

//缓存清除 指定键值
+(void)CrazyRequestCache_removeKey:(NSString *)key;
//缓存全部清除
+(void)CrazyRequestCache_removeAll;

+(void)CrazyShowHUD;
+(void)CrazyHiddenHUD;

@end