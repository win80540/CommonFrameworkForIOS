//
//  Http+NSObject.m
//  AnimationApp
//
//  Created by aa on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Http+NSObject.h"
//#import "Reachability.h"

#define requestTimeOutInterval       30

@implementation Http_NSObject

//post发送非流数据
//@param   url   网址
//@param   dict   存放参数和对应值的词典
+ (NSString *)postSendDataToSercerWithURL:(NSString *)url 
                            andDictionary:(NSDictionary *)dict
{
    NSMutableString *postString=[[NSMutableString alloc] init];
    NSArray *formKeys = [dict allKeys];
 	for (int i=0; i < [formKeys count]; i++) {
        if (i==0) {
            [postString appendFormat:@"%@=%@",[formKeys objectAtIndex:i],[dict valueForKey:[formKeys objectAtIndex:i]]];
        }
        else {
            [postString appendFormat:@"&%@=%@",[formKeys objectAtIndex:i],[dict valueForKey:[formKeys objectAtIndex:i]]];
        }
 	}
    //将post数据转换为 NSASCIIStringEncoding 编码格式  
    //NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];    
    [request setTimeoutInterval:requestTimeOutInterval];
    [request setURL:[NSURL URLWithString:url]];  
    [request setHTTPMethod:@"POST"];     
    [request setHTTPBody:postData];
    
    NSURLResponse *response = nil;
 	NSError *error = nil;
 	NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *resultString=[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    return resultString;
}

//post方法发送数据到服务器 （更新用户个人资料用）
//@param   url   网址
//@param   dict   存放参数和对应值的词典
//@param   files    需要发送的图片词典，如果没有，社为nil
+ (NSData *)postDataToServerWithURL:(NSString *)url
                        andDictionary:(NSDictionary *)dict
                            withImage:(NSDictionary *)files
                          isUserImage:(BOOL)isuserimage
{
 	
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=nil;
    NSData* data = nil;
    if (isuserimage) {
        image = [files objectForKey:@"fileUserHeadImg"];
    } else {
        image = [files objectForKey:@"fileLogo"];
    }
        
    //得到图片的data
    data = UIImageJPEGRepresentation(image,0.6);
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [dict allKeys];
    
    //遍历keys
    for(int i=0; i<[keys count]; i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
    }

    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    if (files != nil) {
        if (isuserimage) {
            [body appendFormat:@"Content-Disposition: form-data; name=\"fileUserHeadImg\"; filename=\"fileUserHeadImg.png\"\r\n"];
        } else {
            [body appendFormat:@"Content-Disposition: form-data; name=\"fileLogo\"; filename=\"fileUserBackgroundImg.png\"\r\n"];
        }
    }
    
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    if (data != nil) {
        [myRequestData appendData:data];
    }
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"]; 
    
 	NSURLResponse *response = nil;
 	NSError *error = nil;
 	NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *resultString=[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    return myData;
}

// 用于发送发布包含图片的事件的发布(注册和发布运动事件时用了这个方法)
+ (NSString *)postDataToServerWithURL:(NSString *)url
                        andDictionary:(NSDictionary *)dict
                            withImage:(NSDictionary *)files
                           isRegister:(BOOL)isregister
{
 	
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    
    UIImage *image=[files objectForKey:isregister?@"fileUserHeadImg":@"photoFile"];
    //得到图片的data  0.8 是图片K数压缩比例
    NSData* data = UIImageJPEGRepresentation(image,0.8);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [dict allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
        
    }
    
    // 添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n",isregister?@"fileUserHeadImg":@"photoFile",isregister?@"fileUserHeadImg":@"photoFile"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
   // NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [myRequestData appendData:[body dataUsingEncoding: NSUTF8StringEncoding]];
    //[postData release];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
 	NSURLResponse *response = nil;
 	NSError *error = nil;
 	NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *resultString=[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    return resultString;
}

//get方法发送数据到服务器
//@param   url   网址
//@param   dict   存放参数和对应值的词典
+ (NSString *)getContactServerWithURL:(NSString *)url 
                        andDictionary:(NSDictionary *)dict 
{
 	
 	NSArray *formKeys = [dict allKeys];
    NSMutableString *urlString=[[NSMutableString alloc] init];
    [urlString setString:url];
 	for (int i=0; i < [formKeys count]; i++) {
        if (i==0) {
            [urlString appendFormat:@"?%@=%@",[formKeys objectAtIndex:i],[dict valueForKey:[formKeys objectAtIndex:i]]];
        }
        else {
            [urlString appendFormat:@"&%@=%@",[formKeys objectAtIndex:i],[dict valueForKey:[formKeys objectAtIndex:i]]];
        }
 	}
    //考虑到中文不能直接在url中传到服务器，所以需要转码
    NSURL *myURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:nil];
 	NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:requestTimeOutInterval];
    
 	NSURLResponse *response = nil;
 	NSError *error = nil;
 	NSData *myData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&error];
    NSString *resultString=[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    return resultString;
 	
}

//get方法后去图片
//@param   url   网址
//@param   dict   存放参数和对应值的词典
+ (NSData *)imageFormServerWithURL:(NSString *)url 
                        andDictionary:(NSDictionary *)dict 
{
 	
 	NSArray *formKeys = [dict allKeys];
    NSMutableString *urlString=[[NSMutableString alloc] init];
    [urlString setString:url];
 	for (int i=0; i < [formKeys count]; i++) {
        if (i==0) {
            [urlString appendFormat:@"?%@=%@",[formKeys objectAtIndex:i],[dict valueForKey:[formKeys objectAtIndex:i]]];
        }
        else {
            [urlString appendFormat:@"&%@=%@",[formKeys objectAtIndex:i],[dict valueForKey:[formKeys objectAtIndex:i]]];
        }
 	}
    //考虑到中文不能直接在url中传到服务器，所以需要转码
    NSURL *myURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:nil];
 	NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:requestTimeOutInterval];
    
 	NSURLResponse *response = nil;
 	NSError *error = nil;
 	NSData *myData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&error];
    return myData;
 	
}

@end
