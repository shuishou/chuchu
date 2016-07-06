//
//  ShareHelper.h
//  Sport
//
//  Created by fenguo  on 15/2/6.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface ShareHelper : NSObject

+(void)shareWithImagePath:(NSString *)imagePath ShareContent:(NSString*)content ShareTitle:(NSString*)shareTitle ShareUrl:(NSString*)url ShreType:(SSPublishContentMediaType)type;

+(void)showSystemShareList;


@end
