//
//  ShareInstance.m
//  Sport
//
//  Created by fenguo on 15-3-11.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "ShareInstance.h"

@implementation ShareInstance

+ (ShareInstance *)creatInstance
{
    static ShareInstance *share=nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once,^{
        
        share=[[ShareInstance alloc]init];
    });
    
    return share;
}

@end
