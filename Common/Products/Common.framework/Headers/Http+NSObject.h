//
//  Http+NSObject.h
//  AnimationApp
//
//  Created by aa on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Http_NSObject : NSObject


//判断网络是否连接
//@return  yes 表示网络连接  no 表示网络没连接
//+ (BOOL)showAlertWhileNoConnection;

//post发送非流数据
//@param   url   网址
//@param   dict   存放参数和对应值的词典
+ (NSString *)postSendDataToSercerWithURL:(NSString *)url 
                            andDictionary:(NSDictionary *)dict;

//post方法发送数据到服务器
//@param   url   网址
//@param   dict   存放参数和对应值的词典
//@param   files    需要发送的图片词典，如果没有，社为nil
+ (NSData *)postDataToServerWithURL:(NSString *)url
                        andDictionary:(NSDictionary *)dict 
                            withImage:(NSDictionary *)files
                          isUserImage:(BOOL)isuserimage;

//get方法发送数据到服务器
//@param   url   网址
//@param   dict   存放参数和对应值的词典
+ (NSString *)getContactServerWithURL:(NSString *)url 
                        andDictionary:(NSDictionary *)dict;

//get方法后去图片
//@param   url   网址
//@param   dict   存放参数和对应值的词典
+ (NSData *)imageFormServerWithURL:(NSString *)url 
                     andDictionary:(NSDictionary *)dict;

//HenryBegin10/16 用于发送发布包含图片的事件的发布
+ (NSString *)postDataToServerWithURL:(NSString *)url
                        andDictionary:(NSDictionary *)dict
                            withImage:(NSDictionary *)files
                           isRegister:(BOOL)isregister;
//HenryEnd

@end
