//
//  LoginSession.m
//  Sport
//
//  Created by fenguo  on 15-1-26.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "LoginSession.h"
#import "User.h"

@implementation LoginSession

- (id)initWithDictionary:(NSDictionary *)item {
    
    if([self init]){
        _expire = [[item objectForKey:@"expire"] longLongValue];
        _sessionId = [item objectForKey:@"sessionId"];
        
        NSDictionary *user = [item objectForKey:@"user"];
        _user = [User objectWithKeyValues:user];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.sessionId forKey:@"sessionId"];
    [encoder encodeObject:@(self.expire) forKey:@"expireTime"];
    [encoder encodeObject:self.user forKey:@"user"];    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.sessionId = [decoder decodeObjectForKey:@"sessionId"];
        self.expire = [[decoder decodeObjectForKey:@"expireTime"] doubleValue];
        self.user = [decoder decodeObjectForKey:@"user"];
    }
    return self;
}

-(BOOL)isValidate{
    double timeInterval = [[NSDate date] timeIntervalSince1970]*1000;
    return timeInterval < self.expire && self.user;
}

@end
