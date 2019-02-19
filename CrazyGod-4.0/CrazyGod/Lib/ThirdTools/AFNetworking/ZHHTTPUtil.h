//
//  ZHHTTPUtil.h
//  AFNetWorkingDemo
//
//  Created by 陈磊 on 14-8-18.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

#define ZHHTTPMETHODPOST @"POST"
#define ZHHTTPMETHODGET @"GET"

typedef void (^AFSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface ZHHTTPUtil : NSObject

/**
 *  异步http请求
 *  @param success          成功回调
 *  @param failure          失败回调
 *  @param path             路径, 格式为@[<base>, <path>]
 *  @param method           方法
 *  @param params           参数
 *  @param resSerializer    返回对象反序列化类
 *  @param block            上传文件的回调
 *  @param timeout          超时, 默认30秒
*/
+ (void)asyncHttpRequest:(AFSuccessBlock)success failure:(AFFailureBlock)failure path:(NSArray *)path method:(NSString *)method params:(NSDictionary *)params resSerializer:(AFHTTPResponseSerializer *)sr constructingBodyWithBlock:(void(^)(id <AFMultipartFormData> formData))block timeout:(NSTimeInterval)timeout;

/**
 *  异步HTTP请求, 返回格式为JSON
 *  @param success          成功回调
 *  @param failure          失败回调
 *  @param path             路径, 格式为@[<base>, <path>]
 *  @param method           方法
 *  @param params           参数
 *  @param block            上传文件的回调
 */
+ (void)asyncJsonRequest: (AFSuccessBlock)success failure: (AFFailureBlock)failure path: (NSArray*)path method: (NSString*)method params: (NSDictionary*)params constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block;

/**
 * 异步GET请求, 返回格式为JSON
 * @param success       成功回调
 * @param failure       失败回调
 * @param path          路径, 格式为@[<base>, <path>]
 * @param params        参数
 */
+ (void)asyncGetRequest: (AFSuccessBlock)success failure: (AFFailureBlock)failure path: (NSArray*)path params: (NSDictionary*)params;

/**
 * 异步POST请求, 返回格式为JSON
 * @param success       成功回调
 * @param failure       失败回调
 * @param path          路径, 格式为@[<base>, <path>]
 * @param params        参数
 */
+ (void)asyncPostRequest: (AFSuccessBlock)success failure: (AFFailureBlock)failure path: (NSArray*)path params: (NSDictionary*)params;

/**
 * 异步POST请求, 支持上传文件, 返回格式为JSON
 * @param success       成功回调
 * @param failure       失败回调
 * @param path          路径, 格式为@[<base>, <path>]
 * @param params        参数
 * @param block         上传文件的回调
 */
+ (void)asyncUploadRequest: (AFSuccessBlock)success failure: (AFFailureBlock)failure path: (NSArray*)path params: (NSDictionary*)params constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block;

@end
