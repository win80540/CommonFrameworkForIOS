//
//  MyWebView.h
//  UIWebView-Call-ObjC
//
//  Created by NativeBridge on 02/09/15.
//  Copyright 2015 田凯. All rights reserved.
//

#import "TKWebView.h"
#import "TKQRScanViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation TKWebView

- (id)initWithFrame:(CGRect)frame 
{
  if (self = [super initWithFrame:frame]) {
    
    // Set delegate in order to "shouldStartLoadWithRequest" to be called
    self.delegate = self;
      
    // Set non-opaque in order to make "body{background-color:transparent}" working!
    self.opaque = NO;
      self.backgroundColor=[UIColor whiteColor];
    
    // Instanciate JSON parser library
    json = [ SBJSON new ];
    
    
  }
  return self;
}
-(void)loadRequest:(NSURLRequest *)request{
    DLog(@"TKWebView loadRequest on URL : %@",[[request URL] absoluteString]);
    [super loadRequest:request];
}
#pragma mark -UIWebViewDelegate
// This selector is called when something is loaded in our webview
// By something I don't mean anything but just "some" :
//  - main html document
//  - sub iframes document
//
// But all images, xmlhttprequest, css, ... files/requests doesn't generate such events :/
- (BOOL)webView:(UIWebView *)webView
	      shouldStartLoadWithRequest:(NSURLRequest *)request 
	      navigationType:(UIWebViewNavigationType)navigationType {

	NSString *requestString = [[request URL] absoluteString];
    NSString *scheme =[[request URL] scheme];
  NSLog(@"request : %@",requestString);
  if ([scheme isEqualToString:@"jeedaa-objc"] ) {
    NSArray *components = [[[requestString componentsSeparatedByString:@"://"] objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSString *function = (NSString*)[components objectAtIndex:0];
		int callbackId = [((NSString*)[components objectAtIndex:1]) intValue];
    NSString *argsAsString = [(NSString*)[components objectAtIndex:2]
                                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *args = (NSArray*)[json objectWithString:argsAsString error:nil];
    
    [self handleCall:function callbackId:callbackId args:args];
    
    return NO;
  }
  
  return YES;
}

/*
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self returnResultAfterDelay:@"function a(){ alert('123');} a();"];
}
*/
-(void)jumpToUrlString:(NSString *)urlString{
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
    [self loadRequest:request];
}
// Call this function when you have results to send back to javascript callbacks
// callbackId : int comes from handleCall function
// args: list of objects to send to the javascript callback
- (void)returnResult:(int)callbackId args:(id)arg, ...;
{
  if (callbackId==0) return;
  
  va_list argsList;
  NSMutableArray *resultArray = [[NSMutableArray alloc] init];
  
  if(arg != nil){
    [resultArray addObject:arg];
    va_start(argsList, arg);
    while((arg = va_arg(argsList, id)) != nil)
      [resultArray addObject:arg];
    va_end(argsList);
  }

  NSString *resultArrayString = [json stringWithObject:resultArray allowScalar:YES error:nil];
  
  // We need to perform selector with afterDelay 0 in order to avoid weird recursion stop
  // when calling NativeBridge in a recursion more then 200 times :s (fails ont 201th calls!!!)
  [self performSelector:@selector(returnResultAfterDelay:) withObject:[NSString stringWithFormat:@"JeedaaNativeBridge.JeedaaIOSFramework.resultForCallback(%d,%@);",callbackId,resultArrayString] afterDelay:0];
}

-(void)returnResultAfterDelay:(NSString*)str {
  // Now perform this selector with waitUntilDone:NO in order to get a huge speed boost! (about 3x faster on simulator!!!)
  [self performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:str waitUntilDone:NO];
}

// Implements all you native function in this one, by matching 'functionName' and parsing 'args'
// Use 'callbackId' with 'returnResult' selector when you get some results to send back to javascript
- (void)handleCall:(NSString*)functionName callbackId:(int)callbackId args:(NSArray*)args
{
    
    if (args && args.count>0) {
        SEL funcSel=NSSelectorFromString([NSString stringWithFormat:@"%@CallbackID:Args:",functionName]);
        if (funcSel!=nil) {
            if([self respondsToSelector:funcSel]){
                //((void(*)(id, SEL, id))objc_msgSend)(self, funcSel, args);
                void(*action)(id, SEL, int,id) =(void(*)(id, SEL, int,id))objc_msgSend;
                action(self,funcSel,callbackId,args);
            }
        }
       
    }else{
        SEL funcSel=NSSelectorFromString([NSString stringWithFormat:@"%@CallbackID:",functionName]);
        if (funcSel!=nil) {
            if([self respondsToSelector:funcSel]){
                void(*action)(id, SEL,int) =(void(*)(id, SEL,int))objc_msgSend;
                action(self,funcSel,callbackId);
            }
        }
    }
}
#pragma mark -Add Native method below which Javascript need call

-(void)isIOSCallbackID:(int)callBackID{
    [self returnResult:callBackID args:[NSNumber numberWithBool: true]];
}

//sign alias to jpush
-(void)registerJPushCallbackID:(int)callBackID Args:(NSArray *)args{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(registerJpush:)]) {
        void(*action)(id,SEL,id)= (void(*)(id,SEL,id))objc_msgSend;
        action(delegate,@selector(registerJpush:),[args objectAtIndex:0]);
        [self returnResult:callBackID args:nil];
    }
    
}
-(void)callQRCodeCallbackID:(int)callBackID{
   TKQRScanViewController *vc =  [[TKQRScanViewController alloc] init];
    vc.delegate=self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
        //[vc capture];
    }];
}

-(void)tkQRScan:(TKQRScanViewController *)scanVC FinishedWithString:(NSString *)result{
    NSRange range= [result rangeOfString:@"^http://|https://" options:NSRegularExpressionSearch];
    if (range.length>0 && range.location==0) {
        //[self performSelector:@selector(returnResultAfterDelay:) withObject:[NSString stringWithFormat: @"~function(){window.location.href='%@'}()",result] afterDelay:0];
        [self jumpToUrlString:result];
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Scan Result", nil)] message:[NSString stringWithFormat:@"%@",result] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    

    [scanVC dismissViewControllerAnimated:true completion:nil];
}

@end
