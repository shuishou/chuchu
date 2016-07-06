//
//  ApplicationContext.h
//  Sport
//
//  Created by fenguo  on 15/1/28.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class LoginSession;
@class UserLocation;
@class Weather;
@class SportType;

@interface ApplicationContext : NSObject


+ (instancetype)sharedInstance;


/**
 *  是否第一次使用app
 *
 *  @return
 */
- (BOOL)isFirstLaunch;

/**
 *获取sessionId
 */
-(NSString *)getLoginSessionId;

/**
 *获取session
 */
-(LoginSession *)getLoginSession;

/**
 *  保存session
 */
-(void)saveLoginSession:(LoginSession *)loginSession;

/**
 *  保存user信息
 */
-(void)saveLoginUser:(User *)user;

/**
 *  获取登录用户信息
 *
 *  @return LoginUser对象
 */
- (User *)getLoginUser;

/**
 *  获取登录环信信息
 *
 *  @return LoginUser对象
 */

-(LoginSession *)getLoginUser:(User *)user;

/**
 *  获得电话号码
 *
 *  @param timestamp utc
 */
- (NSString *)getUserPhone;

/**
 *  移除session缓存,相当于注销
 */
-(void)removeLoginSession;

/**
 *  保存定位的位置
 *
 *  @param timestamp utc
 */
-(void)saveUserLocation:(UserLocation *)location;

/**
 *  保存天气信息
 *
 *  @param timestamp utc
 */
-(void)saveWeather:(Weather *)weather;

/**
 *  获取定位的位置
 *
 *  @return utc时间
 */
-(Weather *)getWeather;

/**
 *  获取定位的位置
 *
 *  @return utc时间
 */
-(UserLocation *)getUserLocation;

/**
 *  获取定位的城市 (如：广州)
 *
 *  @return utc时间
 */
-(NSString *)getLocationCityPrefix;

/**
 *  记录用户选择的城市 (如：广州市)
 *
 *  @param timestamp utc
 */
-(void)saveSelectCity:(NSString *)cityName;

/**
 *  获取用户选择的城市 (如：广州市)
 *
 *  @return utc时间
 */
-(NSString *)getSelectCity;

/**
 *  获取用户选择的城市,去掉市，区(如：广州)
 *
 *  @return utc时间
 */
-(NSString *)getSelectCityPrefix;

/**
 *  获取运动类型
 *
 *  @return LoginUser对象
 */
- (SportType *)getSportType:(BOOL)isHome;

/**
 *  保存运动类型
 *
 *  @param timestamp utc
 */
-(void)saveSportType:(SportType *)sportType isHome:(BOOL)isHome;

-(NSMutableArray *)getWeatherCityNames;
- (void)setWeatherCityName:(NSArray*)names;

@end
