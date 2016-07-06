//
//  ImageItem.m
//  Sport
//
//  Created by fenguo  on 15/2/6.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "ImageItem.h"

@implementation ImageItem

-(id)initWithDictionary:(NSDictionary*)item{
    if(self = [super init]){
        self.id = [[item objectForKey:@"id"] integerValue];
        self.storageId = [item objectForKey:@"storageId"];
        self.url = [item objectForKey:@"url"];
        self.idx = [[item objectForKey:@"idx"] integerValue];
    }
    
    return self;
}

@end
