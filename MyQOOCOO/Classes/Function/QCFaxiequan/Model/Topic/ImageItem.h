//
//  ImageItem.h
//  Sport
//
//  Created by fenguo  on 15/2/6.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageItem : NSObject

/**
 *  图片id
 */
@property(nonatomic, assign)NSInteger id;
/**
 *  图片地址
 */
@property(nonatomic, copy)NSString *url;

/**
 *  原图图片地址
 */
@property(nonatomic, copy)NSString *rawUrl;

/**
 *  图片位置
 */
@property(nonatomic, assign)NSInteger idx;

@property(nonatomic,copy)NSString *storageId;

-(id)initWithDictionary:(NSDictionary*)item;

@end
