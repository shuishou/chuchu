//
//  UIBarButtonItem+Extension.h
//  myWeibo
//
//  Created by Fly_Fish_King on 15/5/6.
//  Copyright (c) 2015年 Fly_Fish_King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(instancetype)addBarBtnImg:(NSString *)img highlightedImg:(NSString *)highlightedImg target:(id)target action:(SEL)action;

+(instancetype)addBarBtnImg:(NSString *)img highlightedImg:(NSString *)highlightedImg title:(NSString *)title target:(id)target action:(SEL)action;
+(instancetype)addBarBtnTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
