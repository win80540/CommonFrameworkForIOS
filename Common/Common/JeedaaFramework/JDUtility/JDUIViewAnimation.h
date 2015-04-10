//
//  JDUIViewAnimation.h
//  qinyuan
//
//  Created by 田凯 on 15/3/4.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JDUIViewAnimation : NSObject{
    
}
+ (UIViewController *)activityViewController;
+(void)goFlipFromRight:(BOOL)right ToViewController:(UIViewController *)vc;
+(void)backFlipFromRight:(BOOL)right fromViewController:(UIViewController *)vc;
@end
