//
//  JDExam.h
//  mini2s
//
//  Created by 田凯 on 14-6-12.
//  Copyright (c) 2014年 田凯. All rights reserved.
//

#import "JDBaseModel.h"
#define Single     1
#define Multi      2
#define MultiOther 3
#define Answer     0
@class JDPM25Info;
@interface JDWeatherInfo : JDBaseModel
@property(nonatomic, strong)NSString *currentCity;
@property(nonatomic, strong)NSString *pm25;
@property(nonatomic, strong)NSString *date;
@property(nonatomic, strong)NSString *dayPictureUrl;
@property(nonatomic, strong)NSString *nightPictureUrl;
@property(nonatomic, strong)NSString *dayPictureName;
@property(nonatomic, strong)NSString *nightPictureName;
@property(nonatomic, strong)NSString *weather;
@property(nonatomic, strong)NSString *wind;
@property(nonatomic, strong)NSString *temperature;
@property(nonatomic, strong)NSString *week;

@end
/*
 
 本页JSON数据由FeHelper进行自动格式化，若有任何问题，点击这里提交 意见反馈
 {
 "error": 0,
 "status": "success",
 "date": "2015-03-06",
 "results": [
 {
 "currentCity": "宁波",
 "pm25": "37",
 "index": [
 {
 "title": "穿衣",
 "zs": "较冷",
 "tipt": "穿衣指数",
 "des": "建议着厚外套加毛衣等服装。年老体弱者宜着大衣、呢外套加羊毛衫。"
 },
 {
 "title": "洗车",
 "zs": "不宜",
 "tipt": "洗车指数",
 "des": "不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。"
 },
 {
 "title": "旅游",
 "zs": "适宜",
 "tipt": "旅游指数",
 "des": "稍凉，但是有较弱降水和微风作伴，会给您的旅行带来意想不到的景象，适宜旅游，可不要错过机会呦！"
 },
 {
 "title": "感冒",
 "zs": "较易发",
 "tipt": "感冒指数",
 "des": "天气较凉，较易发生感冒，请适当增加衣服。体质较弱的朋友尤其应该注意防护。"
 },
 {
 "title": "运动",
 "zs": "较不宜",
 "tipt": "运动指数",
 "des": "有降水，推荐您在室内进行各种健身休闲运动，若坚持户外运动，须注意保暖并携带雨具。"
 },
 {
 "title": "紫外线强度",
 "zs": "最弱",
 "tipt": "紫外线强度指数",
 "des": "属弱紫外线辐射天气，无需特别防护。若长期在户外，建议涂擦SPF在8-12之间的防晒护肤品。"
 }
 ],
 "weather_data": [
 {
 "date": "周五 03月06日 (实时：7℃)",
 "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/xiaoyu.png",
 "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/yin.png",
 "weather": "小雨转阴",
 "wind": "东北风微风",
 "temperature": "8 ~ 6℃"
 },
 {
 "date": "周六",
 "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/yin.png",
 "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/xiaoyu.png",
 "weather": "阴转小雨",
 "wind": "北风微风",
 "temperature": "10 ~ 6℃"
 },
 {
 "date": "周日",
 "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/xiaoyu.png",
 "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/xiaoyu.png",
 "weather": "小雨",
 "wind": "东北风微风",
 "temperature": "12 ~ 7℃"
 },
 {
 "date": "周一",
 "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/yin.png",
 "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/duoyun.png",
 "weather": "阴转多云",
 "wind": "北风3-4级",
 "temperature": "10 ~ 3℃"
 }
 ]
 }
 ]
 }
 */