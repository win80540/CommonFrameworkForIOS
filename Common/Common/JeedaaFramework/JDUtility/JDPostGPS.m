//
//  JDPostGPS.m
//  mini2s
//
//  Created by 田凯 on 14-6-25.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import "JDPostGPS.h"
@implementation JDPostGPS
@synthesize locationManager,address,addressDic;
+(id)shareInstance{
    static dispatch_once_t pred;
    static JDPostGPS *_instance = nil;
    //使用Grand Central Dispatch（GCD）来确保这个共享的单例对象只被初始化分配一次
    dispatch_once(&pred, ^{
        _instance = [[self alloc] init];
        _instance.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        _instance.locationManager.delegate=_instance;
        _instance.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _instance.locationManager.distanceFilter=100.0f;
        _instance.updating=NO;
    });
    return _instance;
}
-(CLLocation*)getLocationInfo{
#if   defined(DEBUG) || TARGET_IPHONE_SIMULATOR
    self.location=[[CLLocation alloc] initWithLatitude:29.884939 longitude:121.635146];
    return self.location;
#else
    if([UIDevice currentDevice].systemVersion.floatValue>8.0){
        //定位服务是否可用
        BOOL enable=[CLLocationManager locationServicesEnabled];
        //是否具有定位权限
        int status=[CLLocationManager authorizationStatus];
        if(!enable || status<3){
            //请求权限
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    if (self.updating) {
        return nil;
    }
    self.updating=YES;
    self.location=nil;
    [self.locationManager startUpdatingLocation];
    BOOL exitNow=NO;
    NSDate *timeout=[NSDate dateWithTimeIntervalSinceNow:10];
    while(!exitNow && self.location == nil){
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0.5];
        exitNow=[[NSDate date] compare:timeout]==NSOrderedDescending;
        //[[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop] runUntilDate:date];
        
    }
    if (exitNow) {
        [self.locationManager stopUpdatingLocation];
        self.updating=FALSE;
        return self.locationManager.location;
    }
    return self.location;
    /*
     while (self.updating) {
     __weak NSDate * date=[NSDate  dateWithTimeIntervalSinceNow:1];
     [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:date];
     }
     self.updating=YES;
     self.location=nil;
     //启动位置更新
     [self.locationManager startUpdatingLocation];
     BOOL exitNow=NO;
     NSDate *timeout=[NSDate dateWithTimeIntervalSinceNow:20];
     while(!exitNow && self.location == nil){
     __weak NSDate *date =[NSDate dateWithTimeIntervalSinceNow:1];
     [[NSRunLoop currentRunLoop] runUntilDate:date];
     exitNow=[[NSDate date] compare:timeout]==NSOrderedDescending;
     }
     self.updating=NO;
     if (exitNow) {
     [self.locationManager stopUpdatingLocation];
     return self.locationManager.location;
     }
     */

#endif    
}
-(BOOL)getAddressByLocation:(CLLocation*)location{
#if defined(DEBUG) || TARGET_IPHONE_SIMULATOR
    
    self.address=NSLocalizedString(@"中国浙江省宁波市鄞州区梅墟街道聚贤路", nil);
    return true;
    
#endif
    if (nil==location) {
        return NO;
    }
    __block BOOL flage=FALSE;
    self.addressDic=nil;
    self.address=nil;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            flage=YES;
            CLPlacemark *placemark = [array objectAtIndex:0];
            self.addressDic=placemark.addressDictionary;
            self.address = [self.addressDic objectForKey:@"Name"];
            DLog(@"%@",self.address);
            // DLog(@"---%@..........%@..cout:%d",country,city,[array count]);
        }else{
            self.address=@"";
        }
    }];
   
    while(self.address == nil){
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0.5];
        [[NSRunLoop currentRunLoop] runUntilDate:date];
    }

    return flage;
}
#pragma mark -CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    DLog(@"error code:jeedaa 1");
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation  fromLocation:(CLLocation *)oldLocation{
    CLLocationCoordinate2D userLoc= newLocation.coordinate;
    NSString* coordinateStr=[NSString stringWithFormat:@"%f,%f", userLoc.latitude,userLoc.longitude];
    self.location=newLocation;
    self.updating=NO;
    DLog(@"%@",coordinateStr);
    [self.locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status>=3) {
        [self getLocationInfo];
    }
}

@end
