//
//  JDNetworkHelp.m
//  qinyuan
//
//  Created by 田凯 on 15/3/11.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import "JDNetworkHelp.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif
#define CTL_NET         4               /* network, see socket.h */
static JDNetworkHelp *_self;
@implementation JDNetworkHelp

+(id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

- (NSString *)getWIFIInfo {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge   id)CNCopySupportedInterfaces();
    NSLog(@"ifs:%@",ifs);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"dici：%@",[info  allKeys]);
        if (info[@"SSID"]) {
            self->sSID = info[@"SSID"];
        }
        if(info[@"SSIDDATA"]){
            self->sSIDDATA=info[@"SSIDDATA"];
        }
        if(info[@"BSSID"]){
            self->bSSID=info[@"BSSID"];
        }
        if (info && [info count]) {
            break;
        }
        CFRelease((__bridge CFTypeRef)(info));
    }
    
    return ssid;
}
+(NSString *)sSID{
    return _self->sSID;
}
+(NSData *)sSIDDATA{
    return _self->sSIDDATA;
}
+(NSString *)bSSID{
    return _self->bSSID;
}
+(NSString *)ipAddress{
    return _self->ipAddress;
}
+(NSString *)netMask{
    return _self->netMask;
}
+(NSString *)gateWay{
    return _self->gateWay;
}
+(NSString *)dns{
    return _self->dns;
}
+(NSString *)broadcast{
    return _self->broadcast;
}
+(JDNetworkHelp *)getWIFIConfig{
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        if (_self==nil) {
            _self = [[JDNetworkHelp alloc] init];
        }
    });
    [_self updateWIFIConfig];
    return _self;
}
-(void)updateWIFIConfig{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        
        [_self getWIFIInfo];
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                //Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    DLog(@"ifa_name:%s",temp_addr->ifa_name);
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    self->ipAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    //--192.168.1.106 本机地址
                    DLog(@"local device ip--%@",_self->ipAddress);
                    //routerIP----192.168.1.255 广播地址
                    self->broadcast=[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    DLog(@"broadcast address--%@",_self->broadcast);
                    //--255.255.255.0 子网掩码地址
                    self->netMask=[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    DLog(@"netmask--%@",_self->netMask);
                    //--en0 端口地址
                    DLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                    in_addr_t i =inet_addr([self->ipAddress cStringUsingEncoding:NSUTF8StringEncoding]);
                    in_addr_t* x =&i;
                    self->gateWay=[self getdefaultgateway:x];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return;
}
#if defined(BSD) || defined(__APPLE__)

#define ROUNDUP(a) \
((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

-(NSString *) getdefaultgateway:(in_addr_t * )addr
{
#if 0
    /* net.route.0.inet.dump.0.0 ? */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_DUMP, 0, 0/*tableid*/};
#endif
    /* net.route.0.inet.flags.gateway */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    int r = -1;
    NSString *gateway=@"";
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
        return gateway;
    }
    if(l>0) {
        buf = malloc(l);
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
            return gateway;
        }
        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i=0; i<RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sa_family == AF_INET
               && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                
                unsigned char octet[4]  = {0,0,0,0};
                for (int i=0; i<4; i++){
                    octet[i] = ( ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr >> (i*8) ) & 0xFF;
                }
                
                if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    if(octet[0] == 192 && octet[1] == 168){
                        *addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                        r = 0;
                        gateway = [NSString stringWithFormat:@"%d.%d.%d.%d\n",octet[0],octet[1],octet[2],octet[3]];
                        printf("%s",[gateWay UTF8String]);

                    }
                }
            }
        }
        free(buf);
    }
    return gateway;
}

#endif

@end
