//
//  JDWeatherInfoHelper.h
//  weather
//
//  Created by 田凯 on 15/3/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import "JDWeatherInfo.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface JDWeatherInfoHelper : NSObject
@property (strong,nonatomic) JDWeatherInfo *weatherInfo;
@property (strong,nonatomic) CLLocation *location;
+(id)shareInstance;
-(void)updateLocation;
-(JDWeatherInfo *)getLocalWeatherInfoRelocation:(BOOL)needLocation;
-(JDWeatherInfo *)getWeatherInfoWithLocation:(CLLocationCoordinate2D)coordinate;
/*
-(JDPM25Info *)getLocalPM25InfoRelocation:(BOOL)needLocation;
 */
-(NSURL *)getSinaWeatherIconURL:(JDWeatherInfo *)weatherInfo onDay:(BOOL)isDay;
@end
