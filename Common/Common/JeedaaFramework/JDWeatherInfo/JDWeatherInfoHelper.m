//
//  JDWeatherInfoHelper.m
//  weather
//
//  Created by 田凯 on 15/3/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import "JDPostGPS.h"
#import "JDWeatherInfoHelper.h"
#import "GDataXMLNode.h"


@implementation JDWeatherInfoHelper

+(id)shareInstance{
    static dispatch_once_t  onceQueue;
    static id _instance;
    dispatch_once(&onceQueue, ^{
        _instance=[[JDWeatherInfoHelper alloc] init];
    });
    return _instance;
}

-(void)updateLocation{
    self.location=[[JDPostGPS shareInstance] getLocationInfo];
}

-(JDWeatherInfo *)getLocalWeatherInfoRelocation:(BOOL)needLocation{
    CLLocation *location;
    if (!needLocation && self.location) {
        location=self.location;
    }else{
        location = [[JDPostGPS shareInstance] getLocationInfo];
    }
    return [self getWeatherInfoWithLocation:location.coordinate];
}

-(JDWeatherInfo *)getWeatherInfoWithLocation:(CLLocationCoordinate2D)coordinate{
    NSString * geoCoderAPI = @"";
    NSString * weatherAPI =@"http://api.map.baidu.com/telematics/v3/weather?location=%E5%AE%81%E6%B3%A2&output=json&ak=6FmYvGkywoHNyF7QdUG55AO9&mcode=3F:BF:62:65:AB:0D:74:65:90:90:F8:D7:00:7A:10:F7:1E:0C:B6:90;mini2s";
//    NSString * cityListAPI=@"";
//    NSString * cityCode=@"";
    NSString * currentCityName=@"";
    NSString * finalCityName=@"";
    NSString* currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%g",
                                 coordinate.latitude];
    NSString* currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%g",
                                  coordinate.longitude];
    //get geoCode
    //http://api.map.baidu.com/geocoder?location=29.8849,121.635&output=xml&src=JeedaaTK
    geoCoderAPI = [geoCoderAPI stringByAppendingFormat:@"http://api.map.baidu.com/geocoder?location=%@,%@&output=xml&src=JeedaaTK",currentLatitude,currentLongitude];
    NSURL *url = [NSURL URLWithString:geoCoderAPI];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSLog(@"%@",geoCoderAPI);
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *citystring = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:citystring options:0 error:nil];
    GDataXMLElement *root = [document rootElement];
    NSArray *children = [root children];
    if ([children count]<1) {
        NSLog(@"没有城市信息");
    }else{
        NSError *error;
        GDataXMLElement *city = [[document nodesForXPath:@"//city" error:&error] objectAtIndex:0];
        currentCityName = [city stringValue];
        if (currentCityName.length>1){
            finalCityName = [currentCityName substringToIndex:(unsigned long)[currentCityName length]-1];
            //http://api.map.baidu.com/telematics/v3/weather?location=%E5%AE%81%E6%B3%A2&output=json&ak=6FmYvGkywoHNyF7QdUG55AO9&mcode=3F:BF:62:65:AB:0D:74:65:90:90:F8:D7:00:7A:10:F7:1E:0C:B6:90;mini2s
            NSString * stringFormat = @"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&ak=6FmYvGkywoHNyF7QdUG55AO9&mcode=3F:BF:62:65:AB:0D:74:65:90:90:F8:D7:00:7A:10:F7:1E:0C:B6:90;mini2s";
            weatherAPI = [NSString stringWithFormat:stringFormat,[finalCityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    //get weatherinfo
    printf("%s",[weatherAPI UTF8String]);
    url = [NSURL URLWithString:weatherAPI];
    request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSError *error;
    received=nil;
    received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary * weatherInfoJson = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:&error];
    //解析Json 生成实体
    if (weatherInfoJson && [[weatherInfoJson objectForKey:@"status"] isEqualToString:@"success"]) {
        NSDictionary *result = [(NSArray *)[weatherInfoJson objectForKey:@"results"] firstObject];
        self.weatherInfo=[[JDWeatherInfo alloc] init];
        self.weatherInfo.currentCity=currentCityName;
        self.weatherInfo.pm25=[result objectForKey:@"pm25"];
        NSDictionary *weatherDate=[[result objectForKey:@"weather_data"] firstObject];
        self.weatherInfo.date=[weatherDate objectForKey:@"date"];
        self.weatherInfo.dayPictureUrl=[weatherDate objectForKey:@"dayPictureUrl"];
        self.weatherInfo.nightPictureUrl=[weatherDate objectForKey:@"nightPictureUrl"];
        self.weatherInfo.weather=[weatherDate objectForKey:@"weather"];
        self.weatherInfo.wind=[weatherDate objectForKey:@"wind"];
        self.weatherInfo.temperature=[weatherDate objectForKey:@"temperature"];
        self.weatherInfo.week=[(NSString *)[weatherDate objectForKey:@"date"] substringToIndex:2];
        self.weatherInfo.dayPictureName = [self getImageName:self.weatherInfo.dayPictureUrl];
        self.weatherInfo.nightPictureName =[self getImageName:self.weatherInfo.nightPictureUrl];
        
    }
    return self.weatherInfo;
    
}

-(NSString *)getImageName:(NSString*)string{
    NSError *error;
    NSString *regulaStr = @"(?<=/)\\w+(?=\\.png)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:0
                                                                             error:&error];
    
    

    
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        return substringForMatch;
    }
    return @"";
}

-(NSURL *)getSinaWeatherIconURL:(JDWeatherInfo *)weatherInfo onDay:(BOOL)isDay{
    NSString *urlFormat = @"http://php.weather.sina.com.cn/images/yb3/180_180/%@_%d.png";
    NSString *url = [NSString stringWithFormat:urlFormat,isDay?weatherInfo.dayPictureName:weatherInfo.nightPictureName,isDay?0:1];
    return [NSURL URLWithString:url];
}


/*
-(JDPM25Info *)getLocalPM25InfoRelocation:(BOOL)needLocation{
    JDPM25Info *pm2_5Info;
    NSString * pm2_5API=@"";
    //NSString * stringFormat=@"http://www.pm25.in/api/querys/pm2_5.json?city=%@&stations=no&token=5j1znBVAsnSf5xQyNQyq";
    NSString * stringFormat=@"http://www.mini2s.com/pm25.json?city=%@&stations=no&token=5j1znBVAsnSf5xQyNQyq";
    [self getLocalWeatherInfoRelocation:needLocation];
    pm2_5API =[NSString stringWithFormat:stringFormat,self.weatherInfo.city_en];
    NSURL *url=[NSURL URLWithString:pm2_5API];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSError *error;
    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error ];
    if (error) {
        DLog([error localizedDescription]);
    }else{
        error=nil;
        NSArray *pmInfoArray=[NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
        if (error) {
            DLog([error localizedDescription]);
        }else{
           pm2_5Info = [[JDPM25Info alloc] initWithDictionary: [pmInfoArray lastObject]];
        }
    }
    if (pm2_5Info) {
        self.weatherInfo.pm2_5Info=pm2_5Info;
    }
    return self.weatherInfo.pm2_5Info;
}
 */
@end
