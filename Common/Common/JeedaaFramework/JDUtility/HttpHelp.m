//
//  HttpHelp.m
//  wetoolsSAAS
//
//  Created by 田凯 on 14-3-18.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import "HttpHelp.h"
#import "AFNetworking.h"
#import "SDWebImageDownloader.h"
@interface HttpHelp ()
{
    AFHTTPRequestOperationManager *httpManager;

}
@end
@implementation HttpHelp
+ (HttpHelp *)sharedHTTPHelp
{
    static dispatch_once_t pred;
    static HttpHelp *_sharedHttpHelp = nil;
    //使用Grand Central Dispatch（GCD）来确保这个共享的单例对象只被初始化分配一次
    dispatch_once(&pred, ^{
        _sharedHttpHelp = [[self alloc] init];
    });
    return _sharedHttpHelp;
}

-(HttpHelp *)init
{
    self= [super init];
    httpManager= [AFHTTPRequestOperationManager manager];
    _errorShowTime=[[NSDate date] timeIntervalSince1970]*1000;
    return self;
}
-(void)postAjax:(NSString *)url Parameters:(NSDictionary *)paramDic Success:(void(^)(id json))callback Error:(void(^)(NSError* error))errorCallback{
    DLog(@"url:%@, post params:%@",url,[paramDic description]);
    [httpManager POST:url parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        if (nil!=callback) {
            callback(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        if (nil!=errorCallback) {
            errorCallback(error);
        }
        [self showError];
    }];
    
}
-(void)showError{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    if (time-_errorShowTime>30000) {
        _errorShowTime=time;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"连接出错"
                                                     message:@"网络不通或服务器错误，请联系管理员"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}
-(void)loadImage:(NSString *)url  Success:(void(^)(UIImage *image))callback Error:(void(^)(NSError* error))errorCallback
{
    DLog(@"url:%@",url);
    NSURL *requestURL=[NSURL URLWithString:url];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:requestURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //DLog(@"%u %u",receivedSize,expectedSize);
    }completed:^(UIImage *aImage, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                if (nil!=error) {
                    DLog(@"Error: %@", error);
                    if (nil!=errorCallback) {
                        errorCallback(error);
                    }
                }else{
                   // DLog(@"成功了:%d",UIImageJPEGRepresentation(aImage, 1).length);
                    if (nil!=callback) {
                        callback(aImage);
                    }
                }
            }
        });
    }];

}

@end
