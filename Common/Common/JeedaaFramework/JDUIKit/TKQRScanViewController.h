//
//  TKQRScanf.h
//  seabuy
//
//  Created by 田凯 on 15/2/12.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKQRScanViewController;
@protocol TKQRScanDelegate <NSObject>
-(void)tkQRScan:(TKQRScanViewController *)scanVC FinishedWithString:(NSString *) result;
@end

@interface TKQRScanViewController : UIViewController
@property (assign,atomic) BOOL qrcodeFlag;
@property (strong,atomic) id<TKQRScanDelegate> delegate;
-(void)stopReading;
- (void)capture;
@end

