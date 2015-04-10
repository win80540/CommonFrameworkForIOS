//
//  DateService.m
//  YouJia
//
//  Created by J on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JDDateService.h"
#define SECOND 60
#define MINUTE 60
#define HOUR 24
#define DAY 60*60*24
#define MaxScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation JDDateService

+(NSTimeZone *)GMTTimeZone{
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+00:00"];
    return gmt;
}


+ (JDDateService *)sharedDateService
{
    static dispatch_once_t pred;
    static JDDateService *_sharedDateService = nil;
    //使用Grand Central Dispatch（GCD）来确保这个共享的单例对象只被初始化分配一次
    dispatch_once(&pred, ^{
        _sharedDateService = [[self alloc] init];
    });
    return _sharedDateService;
}
+ (JDDateService *)newDateService
{
    JDDateService *_sharedDateService = [[self alloc] init];
    
    return _sharedDateService;
}
//custom DataPicker Controller
-(void)DataPicker:(void(^)(NSDate * date))callback{
    self.pickerCallback=callback;
    if (nil==_dataPickerView) {
        
        CGRect rect=CGRectMake(0, 0,MaxScreenWidth-40, 260);
        rect.origin.x=(MaxScreenWidth-rect.size.width)/2.0 ;
        rect.origin.y=([UIScreen mainScreen].bounds.size.height-rect.size.height)/2.0;
        UIView* view =[[UIView alloc] initWithFrame:rect];
        
        UIView* contentView=[[UIView alloc] initWithFrame:view.bounds];
        view.backgroundColor=[UIColor whiteColor];
        UIDatePicker *datePicker=[[UIDatePicker alloc] init];
        datePicker.datePickerMode=UIDatePickerModeDate;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(rect.size.width/4.0*3.0-40, rect.size.height-40, 80, 30)];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doPickerDateBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btn2=[[UIButton alloc] initWithFrame:CGRectMake(rect.size.width/4.0-40, rect.size.height-40, 80, 30)];
        [btn2 setBackgroundColor:[UIColor redColor]];
        [btn2 setTitle:NSLocalizedString(@"Clear", nil) forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(doPickerDateClearBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [contentView addSubview:btn2];
        [contentView addSubview:datePicker];
        datePicker.frame= CGRectMake(-20, 0, datePicker.bounds.size.width, datePicker.bounds.size.height);
        contentView.layer.masksToBounds=YES;
        [view addSubview:contentView];
        
        contentView.layer.cornerRadius=5.0f;
        view.layer.cornerRadius=5.0f;
        UIBezierPath *path=[UIBezierPath bezierPathWithRect:view.bounds];
        view.layer.shadowColor=[UIColor grayColor].CGColor;
        view.layer.shadowPath=path.CGPath;
        view.layer.shadowRadius=5.0f;
        view.layer.shadowOffset=CGSizeMake(2, 2);
        view.layer.shadowOpacity=0.8;
        _dataPicker= datePicker;
        _dataPickerView=view;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_dataPickerView];
}
-(void)doPickerDateBtn:(UIButton *)sender{
    [sender.superview.superview removeFromSuperview];
    self.pickerCallback(_dataPicker.date);
}
-(void)doPickerDateClearBtn:(UIButton *)sender{
    [sender.superview.superview removeFromSuperview];
    self.pickerCallback(nil);
}
+ (NSDate *)string2Date:(NSString *)dateString{
   // NSLog(@"datestring:%@",dateString);
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
        //NSString *dageStr1 = @"Jan 8, 2014 12:00:00 AM";
        NSString *_dateFormatter = @"MM dd, yyyy hh:mm:ss a";
        [dateFormatter setDateFormat:_dateFormatter];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    });
    NSDate *_date =  [dateFormatter dateFromString:dateString];
    //    NSLog(@"_date_date===:%@",_date);
    //    NSTimeZone  *zone  =   [NSTimeZone localTimeZone];
    //    NSInteger   interval =   [zone secondsFromGMTForDate:_date];
    //    NSDate *date_finish =   [_date dateByAddingTimeInterval:interval];
    return _date;
}
+ (NSDate *)string2FormatDate:(NSString *)dateString{
    //NSLog(@"datestring:%@",dateString);
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
        //NSString *dageStr1 = @"Jan 8, 2014 12:00:00 AM";
        NSString *_dateFormatter = @"yyyy-MM-dd HH:mm:ss z";
        [dateFormatter setDateFormat:_dateFormatter];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    });
    NSDate *_date =  [dateFormatter dateFromString:dateString];
    //NSLog(@"_date_date===:%@",_date);
    NSTimeZone  *zone  =   [NSTimeZone localTimeZone];
    NSInteger   interval =   [zone secondsFromGMTForDate:_date];
    NSDate *date_finish =   [_date dateByAddingTimeInterval:interval];
    return date_finish;
}
+ (NSDate *)string2Format:(NSString *)_dateFormatter Date:(NSString *)dateString{
   // NSLog(@"datestring:%@",dateString);
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
    //NSString *dageStr1 = @"Jan 8, 2014 12:00:00 AM";
    [dateFormatter setDateFormat:_dateFormatter];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    });
    NSDate *_date =  [dateFormatter dateFromString:dateString];
    //NSLog(@"_date_date===:%@",_date);
    NSTimeZone  *zone  =   [NSTimeZone localTimeZone];
    NSInteger   interval =   [zone secondsFromGMTForDate:_date];
    NSDate *date_finish =   [_date dateByAddingTimeInterval:interval];
    return date_finish;
}
+ (NSString *)dateFormatString:(NSString *)formatString Time:(NSDate *)date
{
    static NSMutableDictionary *_formatDic;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        _formatDic=[NSMutableDictionary dictionary];
    });
    NSDateFormatter *dateFormatter = _formatDic[formatString];
    if(!dateFormatter){
        @synchronized(self){
            if(!dateFormatter){
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:formatString];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                _formatDic[formatString] = dateFormatter;
            }
        }
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateTimeString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm", nil)];
    });
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", nil)];
    });
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)dateFormatTimeString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:NSLocalizedString(@"MMM dd, yyyy HH:mm:ss a", nil)];
    });
    return [dateFormatter stringFromDate:date];
}

+(NSString *)dateFormatByThreadTimeString:(NSDate *)date
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"mydateformatter"];
    if(!dateFormatter){
        @synchronized(self){
            if(!dateFormatter){
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                threadDictionary[@"mydateformatter"] = dateFormatter;
            }
        }
    }
    return [dateFormatter stringFromDate:date];
}
/*
+(void)stringFormDate:(NSDate *)date  forKey:(NSString *)key{
       //获取当前时间
    NSDate *now = [NSDate date];
    DLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond|NSCalendarUnitNanosecond|NSCalendarUnitQuarter;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
   
    
}
 */
@end
