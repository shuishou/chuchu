//
//  User.m
//  Sport
//
//  Created by fenguo  on 15-1-26.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "User.h"

@implementation User

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:@(self.uid) forKey:@"uid"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.hid forKey:@"hid"];
    [encoder encodeObject:self.hpass forKey:@"hpass"];
    [encoder encodeObject:@(self.sex) forKey:@"sex"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [encoder encodeObject:@(self.lastAccessTime) forKey:@"lastAccessTime"];
    [encoder encodeObject:@(self.createTime) forKey:@"createTime"];
    [encoder encodeObject:@(self.distance) forKey:@"distance"];
    [encoder encodeObject:@(self.isFriend) forKey:@"isFriend"];
    [encoder encodeObject:self.marks forKey:@"marks"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.uid = [[decoder decodeObjectForKey:@"uid"] integerValue];
        self.hid = [decoder decodeObjectForKey:@"hid"];
        self.hpass = [decoder decodeObjectForKey:@"hpass"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        self.sex = [[decoder decodeObjectForKey:@"sex"]integerValue];
        self.lastAccessTime = [[decoder decodeObjectForKey:@"lastAccessTime"] longLongValue];
        self.avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        self.createTime = [[decoder decodeObjectForKey:@"createTime"]longLongValue];
        self.isFriend = [[decoder decodeObjectForKey:@"isFiend"] boolValue];
        self.distance = [[decoder decodeObjectForKey:@"distance"] doubleValue];
        self.marks = [decoder decodeObjectForKey:@"marks"];
    }
    return self;
}
@end
