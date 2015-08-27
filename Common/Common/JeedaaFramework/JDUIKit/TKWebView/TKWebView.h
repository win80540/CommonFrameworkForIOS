//
//  MyWebView.h
//  UIWebView-Call-ObjC
//
//  Created by NativeBridge on 02/09/15.
//  Copyright 2015 田凯. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TKQRScanViewController.h"

@interface TKWebView : UIWebView <UIWebViewDelegate,TKQRScanDelegate> {
  int alertCallbackId;
}

#pragma mark - TKWebView custom method
- (void)handleCall:(NSString*)functionName callbackId:(int)callbackId args:(NSArray*)args;
- (void)returnResult:(int)callbackId args:(id)firstObj, ...;
- (void)jumpToUrlString:(NSString *)url;
@end
