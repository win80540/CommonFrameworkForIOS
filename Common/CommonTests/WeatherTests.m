//
//  WeatherTests.m
//  Common
//
//  Created by 田凯 on 15/4/14.
//  Copyright (c) 2015年 田凯. All rights reserved.
//
#import "JDNetwork.h"
#import "JDUIKit.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface WeatherTests : XCTestCase

@end

@implementation WeatherTests

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

-(void)testPerformanceWeather{
    // This is an example of a performance test case.
  [self measureBlock:^{
    JDWeatherInfo *weatherInfo = [[JDWeatherInfoHelper shareInstance] getLocalWeatherInfoRelocation:true];
    XCTAssertNotNil(weatherInfo,@"get weather faild");
    XCTestExpectation *expectation =  [self expectationWithDescription:@"getweather"];
    NSURL *url = [[JDWeatherInfoHelper shareInstance] getSinaWeatherIconURL:weatherInfo onDay:false];
    [[HttpHelp sharedHTTPHelp] loadImage:[url absoluteString] Success:^(UIImage *image) {
        XCTAssertNotNil(image,@"image nil");
        [expectation fulfill];
    } Error:^(NSError *error) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"request failed");

        }
    }];

   }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[HttpHelp sharedHTTPHelp] postAjax:@"http://aa.aa.com/member/login" Parameters:@{
            @"bindmobile":@"15600000000",
            @"password":@"000000"
        } Success:^(id json) {
            
        } Error:^(NSError *error) {
            
        } ];
    }];
}

@end
