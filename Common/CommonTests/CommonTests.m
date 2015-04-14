//
//  CommonTests.m
//  CommonTests
//
//  Created by 田凯 on 15/4/10.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JeedaaMacroDefine.h"
#import "JDNetwork.h"
#import <XCTest/XCTest.h>

@interface CommonTests : XCTestCase

@end

@implementation CommonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
- (void)testCheckUpdate{
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait update"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPPURL, @"817330697"];
    [[HttpHelp sharedHTTPHelp] postAjax:urlStr Parameters:nil Success:^(id json) {
        NSDictionary *infoDict   = [[NSBundle mainBundle]infoDictionary];
        NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        XCTAssert([json objectForKey:@"results"]!=nil,@"json is nil");
        NSArray  *infoArray  = [json objectForKey:@"results"];
        if (infoArray.count >= 1)
        {
            NSDictionary *releaseInfo   = [infoArray objectAtIndex:0];
            NSString     *latestVersion = [releaseInfo objectForKey:@"version"];
            NSString     *releaseNotes  = [releaseInfo objectForKey:@"releaseNotes"];
            NSString     *title         = [NSString stringWithFormat:@"%@%@版本", kAPPName, latestVersion];
            NSString * updateURL = [releaseInfo objectForKey:@"trackViewUrl"];
            
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
        [expectation fulfill];
    } Error:^(NSError *error) {
        if (error) {
            XCTFail(@"error");
        }
        [expectation fulfill];

    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"error time out");
        }
    }];
}




@end
