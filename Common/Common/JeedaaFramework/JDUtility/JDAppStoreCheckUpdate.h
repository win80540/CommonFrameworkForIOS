//
//  JDAppStoreCheckUpdate.h
//  Common
//
//  Created by 田凯 on 15/4/14.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDAppStoreCheckUpdate : NSObject<UIAlertViewDelegate>
+ (JDAppStoreCheckUpdate *)shareInstance;
- (void)checkUpdate:(NSString *)appID;
@end
