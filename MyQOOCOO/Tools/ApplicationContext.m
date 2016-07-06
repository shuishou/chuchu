//
//  ApplicationContext.m
//  Sport
//
//  Created by fenguo  on 15/1/28.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "ApplicationContext.h"
#import "StorageHelper.h"
#import "LoginSession.h"
#import "User.h"
#import "UserLocation.h"

#import "MJExtension.h"

@interface ApplicationContext()

@property (strong, nonatomic) LoginSession *loginSession;
@property (strong, nonatomic) UserLocation *userLocation;

@end

@implementation ApplicationContext

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (BOOL)isFirstLaunch{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isFirstLaunch = [userDefaults objectForKey:@"isFirstLaunch"];
    if (isFirstLaunch == nil) {
        [userDefaults setObject:@"1" forKey:@"isFirstLaunch"];
        [userDefaults synchronize];
        
        self.loginSession = nil;
        [StorageHelper removeObjectForKey:@"login_session"];
        return YES;
    }
    return false;
}

/**
 *获取sessionId
 */
-(NSString *)getLoginSessionId{
    if (self.loginSession) {
        return self.loginSession.sessionId;
    }
    
    self.loginSession = [StorageHelper getObjectForKey:@"login_session"];
    if (self.loginSession) {
        return self.loginSession.sessionId;
    }
    
    return nil;
}

/**
 *获取session
 */
-(LoginSession*)getLoginSession{
    if (self.loginSession) {
        return self.loginSession;
    }
    return [StorageHelper getObjectForKey:@"login_session"];
}

/**
 *  保存session
 */
-(void)saveLoginSession:(LoginSession *)loginSession{
    self.loginSession = loginSession;
    [StorageHelper saveObject:loginSession forKey:@"login_session"];
    
    if (loginSession.user.phone) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:loginSession.user.phone forKey:@"login_user_phone"];
        [userDefaults synchronize];
    }
}

- (void)saveLoginUser:(User *)user {
    if (!user) {
        return;
    }
    if (self.loginSession) {
        self.loginSession.user = user;
        [self saveLoginSession:self.loginSession];
    }
}

/**
 *  保存user
 */
-(LoginSession *)getLoginUser:(User *)user{
    self.loginSession.user = user;
    [StorageHelper saveObject:self.loginSession forKey:@"login_session"];
    
    return self.loginSession;
}

-(NSString *)getUserPhone{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [userDefaults objectForKey:@"login_user_phone"];
    return phoneNumber;
}

-(void)removeLoginSession{
    if (!self.loginSession) {
        return;
    }
    self.loginSession = nil;
    [StorageHelper removeObjectForKey:@"login_session"];
}

- (User *)getLoginUser{
    
    if (self.loginSession) {
        return self.loginSession.user;
    }
    
    self.loginSession = [StorageHelper getObjectForKey:@"login_session"];
    return self.loginSession.user;
}


-(void)saveSelectCity:(NSString *)cityName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (!cityName) {
        [userDefaults removeObjectForKey:@"select_city_name"];
    } else {
        [userDefaults setObject:cityName forKey:@"select_city_name"];
    }
    
    [userDefaults synchronize];
}

-(NSString *)getSelectCity {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [userDefaults objectForKey:@"select_city_name"];
    return cityName;
}

-(NSString *)getSelectCityPrefix {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [userDefaults objectForKey:@"select_city_name"];
    if ([cityName hasSuffix:@"市"]) {
        cityName = [cityName substringToIndex:cityName.length-1];
    } else if ([cityName hasSuffix:@"省"]){
        cityName = [cityName substringToIndex:cityName.length-1];
    } else if([cityName hasSuffix:@"地区"]) {
        cityName = [cityName substringToIndex:cityName.length-2];
    }
    return cityName;
}

-(void)saveUserLocation:(UserLocation *)location{
    self.userLocation = location;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:location.city forKey:@"location_city_name"];
    [userDefaults synchronize];
}

-(UserLocation *)getUserLocation {
    if (_userLocation) {
        return _userLocation;
    }
    UserLocation *location = [[UserLocation alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [userDefaults objectForKey:@"location_city_name"];
    location.city = cityName;
    return location;
}

-(NSString *)getLocationCityPrefix {
    NSString *cityName;
    if (self.userLocation && self.userLocation.city) {
        cityName = self.userLocation.city;
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        cityName = [userDefaults objectForKey:@"location_city_name"];
    }
    
    if ([cityName hasSuffix:@"市"]) {
        cityName = [cityName substringToIndex:cityName.length-1];
    } else if ([cityName hasSuffix:@"省"]){
        cityName = [cityName substringToIndex:cityName.length-1];
    } else if([cityName hasSuffix:@"地区"]) {
        cityName = [cityName substringToIndex:cityName.length-2];
    }
    return cityName;
}

-(NSMutableArray*)getWeatherCityNames {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cities = [defaults arrayForKey:@"user_weather_city"];
    if (cities) {
        return [NSMutableArray arrayWithArray:cities];
    }
    return [NSMutableArray array];
}


@end
