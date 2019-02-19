//
//  ZHHTTPUtil.m
//  AFNetWorkingDemo
//
//  Created by 陈磊 on 14-8-18.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ZHHTTPUtil.h"
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"

static NSOperationQueue *opq;
static NSTimeInterval   defaultTimeout = 3600;
static NSMutableDictionary *taskDict;   // 请求队列

@implementation ZHHTTPUtil

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        taskDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

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



+ (void)asyncHttpRequest: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure path: (NSArray*)path method: (NSString*)method params: (NSDictionary*)params resSerializer: (AFHTTPResponseSerializer*)sr constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block timeout: (NSTimeInterval)timeout
{
    NSCAssert([method compare: ZHHTTPMETHODGET] == NSOrderedSame || [method compare: ZHHTTPMETHODPOST] == NSOrderedSame, @"Method must be GET or POST.");
    NSCAssert([path count] == 2, @"Path must be a (baseurl, path) array.");

    NSString *url = [[path objectAtIndex: 0] stringByAppendingPathComponent: [path objectAtIndex: 1]];
    NSMutableURLRequest *req;
    if (!block) {
        req = [[AFHTTPRequestSerializer serializer] requestWithMethod: method URLString: url parameters: params error: nil];
    } else {
        req = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod: method URLString: url parameters: params constructingBodyWithBlock: block error: nil];
    }
    
    // 数据缓存
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    if(!isExistenceNetwork)
    {
        req.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
    }else
    {
        req.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    
    [req setTimeoutInterval: timeout <= 0 ? defaultTimeout : timeout];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest: req];
    if (sr) {
        op.responseSerializer = sr;
    }

    op.securityPolicy.allowInvalidCertificates = YES;
    [op setCompletionBlockWithSuccess: success failure: failure];

    //NSLog(@"HTTP Request: %@ andParams:%@", op.request.URL, params);


    if (!opq) {
        opq = [[NSOperationQueue alloc] init];
    }

#ifdef SIMULATE_NETWORK_DELAY_SEC
    double delayInSeconds = SIMULATE_NETWORK_DELAY_SEC;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [opq addOperation: op];
    });
#else
    [opq addOperation: op];
#endif
}


/**
 *  异步HTTP请求, 返回格式为JSON
 *  @param success          成功回调
 *  @param failure          失败回调
 *  @param path             路径, 格式为@[<base>, <path>]
 *  @param method           方法
 *  @param params           参数
 *  @param block            上传文件的回调
 */
+ (void)asyncJsonRequest: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure path: (NSArray*)path method: (NSString*)method params: (NSDictionary*)params constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
{
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reminder" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", status] forKey:@"reminder"]];
//    }];
    
    AFJSONResponseSerializer *sr = [taskDict objectForKey:path];
    if(!sr)
    {
        NSMutableSet *acceptableContentTypes = [sr.acceptableContentTypes mutableCopy];
        [acceptableContentTypes addObject: @"text/plain"];
        [acceptableContentTypes addObject: @"text/html"];
        sr.acceptableContentTypes = acceptableContentTypes;
        [[self class] asyncHttpRequest: success failure: failure path: path method: method params: params resSerializer: sr constructingBodyWithBlock: block timeout: 0];
    }
    else
    {
        NSLog(@"下载任务已经存在, 无需重复下载");
    }
}

/**
 * 异步GET请求, 返回格式为JSON
 * @param success       成功回调
 * @param failure       失败回调
 * @param path          路径, 格式为@[<base>, <path>]
 * @param params        参数
 */

+ (void)asyncGetRequest: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure path: (NSArray*)path params: (NSDictionary*)params
{
    [[self class] asyncJsonRequest: success failure: failure path: path method: ZHHTTPMETHODGET params: params constructingBodyWithBlock: nil];
}

/**
 * 异步POST请求, 返回格式为JSON
 * @param success       成功回调
 * @param failure       失败回调
 * @param path          路径, 格式为@[<base>, <path>]
 * @param params        参数
 */
+ (void)asyncPostRequest: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure path: (NSArray*)path params: (NSDictionary*)params
{
    NSMutableDictionary *mparams = [NSMutableDictionary dictionaryWithDictionary:params];
    //[mparams setObject:YY_SESSIONID forKey:@"sessionid"];
    [[self class] asyncJsonRequest: success failure: failure path: path method: ZHHTTPMETHODPOST params: mparams constructingBodyWithBlock: nil];
}


/**
 * 异步POST请求, 支持上传文件, 返回格式为JSON
 * @param success       成功回调
 * @param failure       失败回调
 * @param path          路径, 格式为@[<base>, <path>]
 * @param params        参数
 * @param block         上传文件的回调
 */
+ (void)asyncUploadRequest: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure path: (NSArray*)path params: (NSDictionary*)params constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
{
    [[self class] asyncJsonRequest: success failure: failure path: path method: ZHHTTPMETHODPOST params: params constructingBodyWithBlock: block];
}


@end
