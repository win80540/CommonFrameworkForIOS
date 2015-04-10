//
//  HttpHelp.h
//  wetoolsSAAS
//
//  Created by 田凯 on 14-3-18.
//  Copyright (c) 2014年 田凯. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HttpHelp : NSObject
{
    NSTimeInterval _errorShowTime;
}

+ (HttpHelp *)sharedHTTPHelp;
-(void)postAjax:(NSString *)url Parameters:(NSDictionary *)paramDic Success:(void(^)(id json))callback Error:(void(^)(NSError * error))errorCallback;
-(void)loadImage:(NSString *)url  Success:(void(^)(UIImage *image))callback Error:(void(^)(NSError* error))errorCallback;
@end
