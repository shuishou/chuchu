//
//  HAItemManager.h
//  HAScrollNavBar
//
//  Created by haha on 15/7/16.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAScrollNavBar.h"
#import "HASortItemView.h"
#import "HAScrollNavIndicatorBar.h"
@interface HAItemManager : NSObject

@property (nonatomic, weak) HAScrollNavIndicatorBar *scrollNavIndicatorBar;
@property (nonatomic, weak) HAScrollNavBar *scrollNavBar;
@property (nonatomic, weak) HASortItemView *sortItemView;

+ (id)shareitemManager;

- (void)setItemTitles:(NSMutableArray *)titles;
- (void)removeTitle:(NSString *)title;
- (void)printTitles;
@end
