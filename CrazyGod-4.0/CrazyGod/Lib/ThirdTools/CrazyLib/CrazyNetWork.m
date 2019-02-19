//
//  easyflyNetWork.m
//  easyflyDemo
//
//  Created by dukai on 15/5/26.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import "CrazyNetWork.h"
#import "AFNetworking.h"
#import "JKToast.h"
#import "SVProgressHUD.h"
#import "TMMemoryCache.h"
#import "TMCache.h"

static CrazyNetWork * NetWork = nil;
NSString *encrpty = @"";
@implementation CrazyNetWork

+(CrazyNetWork *)share{
    
    NetWork =[[CrazyNetWork alloc]init];
    
    return NetWork;
}

-(AFHTTPRequestOperationManager *)create{
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.0f;//设置请求超时时间
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
  //  manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/json"];
    
    manager.securityPolicy = securityPolicy;
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    return manager;
}

//网络请求
+(void)CrazyRequest_Get:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail{
    
    if (hud){
       [CrazyNetWork CrazyShowHUD];
    }
    
    
    CrazyNetWork * request = [CrazyNetWork share];
    
    AFHTTPRequestOperationManager * manager = [request create];
    request.block_fail = fail;
    request.block_success = success;
    
//    NSString *Url = [NSString stringWithFormat:@"%@",UrlStr];
//    NSString *tempUrl = [Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
 //   [SVProgressHUD show];
    
    [manager GET:header parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSString * json = operation.responseString;
        NSString *url = [operation.request.URL absoluteString];
        
        if(dic.keyValues.count == 0){
          
           // dic = [CrazyNetWork RSAFromData:operation.responseString];
            
        }
        
        request.block_success(dic,url,json);
        
        [CrazyNetWork CrazyHiddenHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (request.block_fail) {
            request.block_fail(error,[operation.request.URL absoluteString],operation.responseString);
            
            [CrazyNetWork CrazyHiddenHUD];
             [JKToast showWithText:@"您的网络不稳定,请重试!"];
        }

    }];
    
}

//post 请求大数据量信息
+(void)CrazyRequest_Post:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail{
    
    if (hud) {
        [CrazyNetWork CrazyShowHUD];
    }
    
    CrazyNetWork * easyfly = [CrazyNetWork share];
    
    AFHTTPRequestOperationManager * manager = [easyfly create];
    easyfly.block_fail = fail;
    easyfly.block_success = success;
    [manager POST:header parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        if(dic.keyValues.count == 0){
            
         //   dic = [CrazyNetWork RSAFromData:operation.responseString];
        }
        
        easyfly.block_success(dic,[operation.request.URL absoluteString],operation.responseString);
        
        [CrazyNetWork CrazyHiddenHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      //  [JKToast showWithText:@"您的网络不稳定,请重试!"];

        easyfly.block_fail(error,[operation.request.URL absoluteString],operation.responseString);
        
        [CrazyNetWork CrazyHiddenHUD];
    }];
    
}
//+(NSDictionary *)RSAFromData:(NSString *)encryptedString{
//   
////    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
////    NSString *privateKeyPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
////    [rsa loadPrivateKeyFromFile:privateKeyPath password:@""];
////    
////    NSString *decryptedString = [rsa rsaDecryptString:encryptedString];
//    
//    NSDictionary *dic = [CrazyFunction crazy_JsonStringToObject:decryptedString];
//    if (dic == nil) {
//        dic = @{};
//    }
//    return dic;
//}


//文件流上传
+(void)CrazyHttpFileUpload:(NSString *)headUrl imageDic:(NSDictionary *)imageDic HUD:(BOOL)hud block:(success)success fail:(fail)fail{
    
//    if (hud) {
//         [CrazyNetWork CrazyShowHUD];
//    }
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:headUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        for (int i = 0; i<imageDic.allKeys.count; i++) {
//            NSString *key = imageDic.allKeys[i];
//            UIImage *image = imageDic[key];
//            NSData *imageData= UIImageJPEGRepresentation(image, 100);
//            [formData appendPartWithFileData:imageData name:key fileName:[NSString stringWithFormat:@"%d",i] mimeType:@"image/jpeg"];
//        }
//        
//    } error:nil];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSProgress *progress = nil;
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            
//            fail(error,[response.URL absoluteString],@"");
//            [CrazyNetWork CrazyHiddenHUD];
//        } else {
//            
//            success(responseObject,[response.URL absoluteString],@"");
//            [CrazyNetWork CrazyHiddenHUD];
//        }
//    }];
//    
//    [uploadTask resume];

}
//base64上传
+(void)CrazyHttpBase64Upload:(NSString *)headUrl imageDic:(NSDictionary *)imageDic parameters:(NSDictionary *)parameters HUD:(BOOL)hud block:(success)success fail:(fail)fail{
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<imageDic.allKeys.count; i++) {
        
        NSString *key = imageDic.allKeys[i];
        UIImage *image = imageDic[key];
        
        NSData* imageData = UIImageJPEGRepresentation(image, 100);
        NSString *strBase64 = [imageData base64EncodedStringWithOptions:0];
        [postDic setObject:strBase64 forKey:key];
    }
    
    for (int i = 0; i<parameters.allKeys.count; i++) {
        
        NSString *key = parameters.allKeys[i];
        UIImage *value = parameters[key];

        [postDic setObject:value forKey:key];
    }
    
    [CrazyNetWork CrazyRequest_Post:headUrl parameters:postDic HUD:hud success:^(NSDictionary *dic, NSString *url,NSString *Json) {
       
       success(dic,url,Json);
       
   } fail:^(NSError *error, NSString *url,NSString *Json) {
       fail(error,url,@"");
   }];

}

//网络缓存请求
+(void)CrazyRequestCache_Get:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail{
    NSString *requestUrl = [CrazyNetWork requestURl:header parameters:parameters];
    [[TMCache sharedCache]objectForKey:requestUrl block:^(TMCache *cache, NSString *key, id object) {
        NSDictionary * dic = (NSDictionary *)object;
        if (dic.allKeys >0) {
            success(dic,requestUrl,@"");
        }else{
            [CrazyNetWork CrazyShowHUD];
            
            [CrazyNetWork CrazyRequest_Get:header parameters:parameters HUD:hud success:^(NSDictionary *dic, NSString *url,NSString *Json) {
                [[TMCache sharedCache]setObject:dic forKey:requestUrl];
                success(dic,url,Json);
                [CrazyNetWork CrazyHiddenHUD];
                
            } fail:^(NSError *error, NSString *url,NSString *Json) {
                
                [CrazyNetWork CrazyHiddenHUD];
                [JKToast showWithText:@"您的网络不稳定,请重试!"];
                fail(error,url,Json);
            }];
        }
    }];
    
}

//网络POST缓存请求  大数据量
+(void)CrazyRequestCache_Post:(NSString *)header parameters:(NSDictionary *)parameters HUD:(BOOL)hud success:(success)success fail:(fail)fail{
    
    NSString *requestUrl = [CrazyNetWork requestURl:header parameters:parameters];
    
    [[TMCache sharedCache]objectForKey:requestUrl block:^(TMCache *cache, NSString *key, id object) {
        NSDictionary * dic = (NSDictionary *)object;
        if (dic.allKeys >0) {
            success(dic,requestUrl,@"");
        }else{
            
            [CrazyNetWork CrazyRequest_Post:header parameters:parameters HUD:hud success:^(NSDictionary *dic, NSString *url,NSString *Json) {
                [[TMCache sharedCache]setObject:dic forKey:requestUrl];
                
                success(dic,url,Json);
                [CrazyNetWork CrazyHiddenHUD];
                
            } fail:^(NSError *error, NSString *url,NSString *json) {
                fail(error,url,json);
            }];
        }
    }];
    
}
+(void)CrazyRequestCache_removeKey:(NSString *)key{
    [[TMCache sharedCache]removeObjectForKey:key];
}
+(void)CrazyRequestCache_removeAll{
    [[TMCache sharedCache]removeAllObjects];
}


+(NSString *)requestURl:(NSString*)header parameters:(NSDictionary *)parameters{
    if (parameters.allKeys == 0 && parameters == nil) {
        return header;
    }else {
        NSMutableString *requstStr = [[NSMutableString alloc]initWithString:header];
        [requstStr appendString:@"?"];
        NSArray * keys = parameters.allKeys;
        for (int i = 0 ; i < keys.count; i++) {
            NSString *key  = keys[i];
            [requstStr appendFormat:@"%@=%@&",key,parameters[key]];
        }
        [requstStr deleteCharactersInRange:NSMakeRange(requstStr.length -1, 1)];
        
        return requstStr;
    }
}

+(void)CrazyShowHUD{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
    
}
+(void)CrazyHiddenHUD{
    
   [SVProgressHUD dismissWithDelay:0.5];
}

@end
