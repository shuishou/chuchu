//
//  HACursor.h
//  HAScrollNavBar
//
//  Created by haha on 15/7/6.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAScrollNavBar.h"
#import "HAScrollNavIndicatorBar.h"
@interface HACursor : UIView

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray        *titles;
@property (nonatomic, strong) HAScrollNavBar   *scrollNavBar;
@property (nonatomic, strong) HAScrollNavIndicatorBar   *scrollNavIndicatorBar;
@property (nonatomic, strong) UIColor        *titleNormalColor;
@property (nonatomic, strong) UIColor        *titleSelectedColor;
@property (nonatomic, strong) UIColor        *navLineColor;
@property (nonatomic, strong) UIImage        *backgroundImage;

@property (nonatomic, assign) BOOL           showSortbutton;
@property (nonatomic, assign) BOOL           isGraduallyChangColor;
@property (nonatomic, assign) BOOL           isGraduallyChangFont;
@property (nonatomic, assign) NSInteger      minFontSize;
@property (nonatomic, assign) NSInteger      maxFontSize;
@property (nonatomic, assign) NSInteger      defFontSize;
@property (nonatomic, assign) CGFloat        rootScrollViewHeight;

@property (nonatomic, assign) BOOL           cursorMode;

- (id)initWithTitles:(NSArray *)titles AndPageViews:(NSArray *)pageViews;
- (instancetype)initWithCursorMode;
@end
