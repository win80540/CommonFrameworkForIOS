//
//  JeedaaMacroDefine.h
//  weather
//
//  Created by 田凯 on 15/3/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#ifndef weather_JeedaaMacroDefine_h
#define weather_JeedaaMacroDefine_h

#define ColorRGB(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


//应用名字，若需要更改，可自行设置。
#define kAPPName    [infoDict objectForKey:@"CFBundleDisplayName"]
//此链接为苹果官方查询App的接口。
#define kAPPURL     @"http://itunes.apple.com/lookup?id="
#define kAPPVersion  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif


#endif
