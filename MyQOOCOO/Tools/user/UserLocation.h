//
//  UserLocation.h
//  Sport
//
//  Created by fenguo  on 15/2/4.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocation : NSObject

@property (nonatomic, assign) double locLng;
@property (nonatomic, assign) double locLat;
@property (nonatomic, strong) NSString *city;

@end
