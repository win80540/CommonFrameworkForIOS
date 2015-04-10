//
//  JDPostGPS.h
//  mini2s
//
//  Created by 田凯 on 14-6-25.
//  Copyright (c) 2014年 田凯. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface JDPostGPS : NSObject<CLLocationManagerDelegate>{
    NSDate *_date;
}
@property(strong,nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic) CLLocation *location;
@property(strong,nonatomic) NSString* address;
@property(strong,nonatomic) NSDictionary *addressDic;
@property(assign,nonatomic) BOOL updating;
+(id)shareInstance;
-(CLLocation*)getLocationInfo;
-(BOOL)getAddressByLocation:(CLLocation*)location;
@end
