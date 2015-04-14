//
//  JDAppStoreCheckUpdate.m
//  Common
//
//  Created by 田凯 on 15/4/14.
//  Copyright (c) 2015年 田凯. All rights reserved.
//
#import "JeedaaMacroDefine.h"
#import "HttpHelp.h"
#import "JDAppStoreCheckUpdate.h"

@implementation JDAppStoreCheckUpdate{
    NSString *_updateURL;
}


+ (JDAppStoreCheckUpdate *)shareInstance
{
    static dispatch_once_t t;
    static JDAppStoreCheckUpdate *update = nil;
    dispatch_once(&t, ^{
         update = [[JDAppStoreCheckUpdate alloc] init];
    });
    return update;
}

- (void)checkUpdate:(NSString *)appID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPPURL, appID];
    [[HttpHelp sharedHTTPHelp] postAjax:urlStr Parameters:nil Success:^(id json) {
        [self didUpdateWithJson:json];
    } Error:^(NSError *error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                     message:[NSString stringWithFormat:@"%@",error]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }];

}


-(void)didUpdateWithJson:(id)jsonnData{
    
    NSDictionary *infoDict   = [[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSArray  *infoArray  = [jsonnData objectForKey:@"results"];
    
    if (infoArray.count >= 1)
    {
        NSDictionary *releaseInfo   = [infoArray objectAtIndex:0];
        NSString     *latestVersion = [releaseInfo objectForKey:@"version"];
        NSString     *releaseNotes  = [releaseInfo objectForKey:@"releaseNotes"];
        NSString     *title         = [NSString stringWithFormat:@"%@%@版本", kAPPName, latestVersion];
        _updateURL = [releaseInfo objectForKey:@"trackViewUrl"];
        
        if ([latestVersion compare:currentVersion] == NSOrderedDescending)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:releaseNotes delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去App Store下载", nil];
            [alertView show];
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"当前版本已经是最新版本" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"当前版本已经是最新版本" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
    }
}
@end
