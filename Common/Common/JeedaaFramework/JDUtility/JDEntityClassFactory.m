//
//  JDClassFactory.m
//  qinyuan
//
//  Created by 田凯 on 15/3/24.
//  Copyright (c) 2015年 田凯. All rights reserved.
//
#import "JDBaseModel.h"
#import "JDEntityClassFactory.h"
#import <objc/runtime.h>
@implementation JDEntityClassFactory
+(void)createClassWithDic:(NSDictionary *)dic Name:(NSString *)className{
//    Class currentClass= objc_allocateClassPair([JDBaseModel class], [className UTF8String], 0);
//    for (NSString *key in [dic allKeys]) {
//        //为类添加变量
//        class_addIvar(Test, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*));
//    }
//        //为类添加方法
//    //IMP 是函数指针
//    // typedef id (*IMP)(id, SEL, ...);
//    IMP i = imp_implementationWithBlock(^(id this,id some){
//        NSLog(@"%@",some);
//        return @111;
//    });
//    //注册方法名为 test: 的方法
//    SEL s = sel_registerName("test:");
//    class_addMethod(Test, s, i, "i@:");
//    //结束类的定义
//    objc_registerClassPair(Test);
}
@end
