//
//  JDUIViewAnimation.m
//  qinyuan
//
//  Created by 田凯 on 15/3/4.
//  Copyright (c) 2015年 田凯. All rights reserved.
//
#import "JDImageTools.h"
#import "JDUIViewAnimation.h"

@implementation JDUIViewAnimation
// 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}
+(void)goFlipFromRight:(BOOL)right ToViewController:(UIViewController *)vc{
    UIImageView *viewCache=[[UIImageView alloc] initWithImage:[JDImageTools snapshotRect:vc.view.frame]];
    [vc.view addSubview:viewCache];
    [[self activityViewController] presentViewController:vc animated:NO completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.30];
            [UIView setAnimationTransition:right?UIViewAnimationTransitionFlipFromRight:UIViewAnimationTransitionFlipFromLeft forView:vc.view cache:YES];
            [UIView setAnimationDelegate:vc];
            [viewCache removeFromSuperview];
            [UIView commitAnimations];
            
        });
    }];
}
+(void)backFlipFromRight:(BOOL)right fromViewController:(UIViewController *)vc{
    UIViewController *destinationVC=[vc presentingViewController];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationTransition:right?UIViewAnimationTransitionFlipFromRight:UIViewAnimationTransitionFlipFromLeft forView:vc.view cache:YES];
    [UIView setAnimationDelegate:destinationVC];
    [vc.view addSubview:destinationVC.view];
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc dismissViewControllerAnimated:false completion:nil];
    });
}

@end
