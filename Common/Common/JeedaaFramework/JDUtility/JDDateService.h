//
//  DateService.h
//  YouJia
//
//  Created by J on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JDDateService : NSObject {
    UIDatePicker *_dataPicker;
    UIView *_dataPickerView;
}
@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) void(^pickerCallback)(NSDate * date);

+ (JDDateService *)sharedDateService;
+ (JDDateService *)newDateService;
+ (NSTimeZone *)GMTTimeZone;
+ (NSDate *)string2Date:(NSString *)dateString;
+ (NSDate *)string2FormatDate:(NSString *)dateString;
+ (NSString *)dateTimeString:(NSDate *)date;
+ (NSString *)dateString:(NSDate *)date;
+ (NSString *)dateFormatTimeString:(NSDate *)date;
+ (NSDate *)string2Format:(NSString *)_dateFormatter Date:(NSString *)dateString;
+ (NSString *)dateFormatString:(NSString *)formatString Time:(NSDate *)date;
-(void)DataPicker:(void(^)(NSDate * date))callback;
@end


