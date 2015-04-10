//
//  JDClassFactory.h
//  qinyuan
//
//  Created by 田凯 on 15/3/24.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDEntityClassFactory : NSObject
+(void)createClassWithDic:(NSDictionary *)dic Name:(NSString *)className;
@end
