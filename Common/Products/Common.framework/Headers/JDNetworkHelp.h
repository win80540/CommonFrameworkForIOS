//
//  JDNetworkHelp.h
//  qinyuan
//
//  Created by 田凯 on 15/3/11.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDNetworkHelp : NSObject{
    NSString * sSID;
    NSData * sSIDDATA;
    NSString * bSSID;
    NSString * ipAddress;
    NSString * netMask;
    NSString * gateWay;
    NSString * dns;
    NSString * broadcast;
    
}
+(id)fetchSSIDInfo;
+(NSString *)sSID;
+(NSData *)sSIDDATA;
+(NSString *)bSSID;
+(NSString *)ipAddress;
+(NSString *)netMask;
+(NSString *)gateWay;
+(NSString *)dns;
+(NSString *)broadcast;
+(JDNetworkHelp *)getWIFIConfig;
@end
