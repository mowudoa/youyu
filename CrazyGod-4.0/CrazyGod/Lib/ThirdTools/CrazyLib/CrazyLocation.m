//
//  UserLocation.m
//  TiaoWei
//
//  Created by dukai on 15/3/27.
//  Copyright (c) 2015年 longcai. All rights reserved.
//

#import "CrazyLocation.h"

static CLLocationManager *lcManager = nil;
static CrazyLocation *userLcn = nil;
@implementation CrazyLocation

+(CrazyLocation *)share{
    if (userLcn == nil) {
        userLcn = [[CrazyLocation alloc]init];
    }
    return userLcn;
}

+(void)startUpdataUserLocation:(LocationFinishBolck)block cityBlock:(cityFinishBolck)cityBlock{
    
    userLcn = [[CrazyLocation alloc]init];
    userLcn.finishBlock = block;
    userLcn.cityBlock = cityBlock;
    
    lcManager = [[CLLocationManager alloc]init];
    BOOL enable=[CLLocationManager locationServicesEnabled];
    int status=[CLLocationManager authorizationStatus];
    
    if (!enable || status<3) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [lcManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
    
    [lcManager setDistanceFilter:kCLDistanceFilterNone]; //设置返回的信息 默认可以不写
    //设置精度
    [lcManager setDesiredAccuracy:kCLLocationAccuracyBest];
    lcManager.delegate = userLcn;
    //开始定位
    [lcManager startUpdatingLocation];
    
   
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //停止更新位置
    [lcManager stopUpdatingLocation];
    CLLocation *newLocation = [locations lastObject];
    double longitude = newLocation.coordinate.longitude; //经度
    double latitude = newLocation.coordinate.latitude;  //纬度
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            
            //  Country(国家)  State(城市)  SubLocality(区)
            
            if (userLcn.cityBlock) {
                userLcn.cityBlock(test);
            }
            
        }
        
    }];
    
    
    if (self.finishBlock) {
        self.finishBlock(longitude,latitude);
    }else{
        self.finishBlock(0 ,0);
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //停止更新位置
    [lcManager stopUpdatingLocation];
    
    //定位失败
    if (self.finishBlock) {
        self.finishBlock(0,0);
    }
    
}

@end
