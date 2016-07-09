//
//  HAScrollNavIndicatorBar.h
//  MyQOOCOO
//
//  Created by Zhou Shaolin on 16/7/8.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARootScrollView.h"
#import "QCCursorButton.h"

@interface HAScrollNavIndicatorBar : UIScrollView

@property (nonatomic, copy) NSString *currentTitle;

@property (nonatomic, weak  ) HARootScrollView *rootScrollView;
@property (nonatomic, strong) UIImage          *backgroundImage;
@property (nonatomic, strong) UIColor          *titleNormalColor;
@property (nonatomic, strong) UIColor          *titleSelectedColor;
@property (nonatomic, weak  ) QCCursorButton   *currectItem;
@property (nonatomic, weak  ) QCCursorButton   *oldItem;
@property (nonatomic, strong) NSMutableArray   *itemKeys;
@property (nonatomic, strong) NSMutableArray   *pageViews;

@property (nonatomic, assign) BOOL             isShowSortButton;
@property (nonatomic, assign) BOOL             isItemHiddenAfterDelet;
@property (nonatomic, assign) CGFloat          itemW;
@property (nonatomic, assign) CGFloat          offsetX;

/**是否自由人**/
@property(nonatomic,assign)BOOL isfree;

- (void)hiddenAllItems;
- (void)showAllItems;

@end
