//
//  StorageHelper.h
//  Sport
//
//  Created by fenguo  on 15-1-26.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageHelper : NSObject

+(void)saveObject:(id)object forKey:(NSString*)key;

+(id)getObjectForKey:(NSString*)key;

+(void)removeObjectForKey:(NSString*)key;

@end
