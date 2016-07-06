//
//  StorageHelper.m
//  Sport
//
//  Created by fenguo  on 15-1-26.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "StorageHelper.h"
#import "MF_Base64Additions.h"
#import "PDKeychainBindings.h"

@implementation StorageHelper


+(void)saveObject:(id)object forKey:(NSString*)key{
    
    NSData *nsdata = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    PDKeychainBindings *keychain = [PDKeychainBindings sharedKeychainBindings];
    [keychain setObject:[nsdata base64String] forKey:key];
    
}

+(id)getObjectForKey:(NSString*)key{
    
    PDKeychainBindings *keychain = [PDKeychainBindings sharedKeychainBindings];
    NSString *result = [keychain objectForKey:key];
    
    LoginSession * object = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBase64String:result]];
    
    return object;
}

+(void)removeObjectForKey:(NSString*)key{
    PDKeychainBindings *keychain = [PDKeychainBindings sharedKeychainBindings];
    [keychain removeObjectForKey:key];
}

@end
