//
//  JDExam.m
//  mini2s
//
//  Created by 田凯 on 14-6-12.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import "JDWeatherInfo.h"
//http://m.weather.com.cn/data/101210401.html
@implementation JDWeatherInfo
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    DLog(@"JDExam has no such key:%@,value:%@",key,[value description]);
    return;
}

@end
