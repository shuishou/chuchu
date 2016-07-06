//
//  MGPopViewController.h
//  myWeibo
//
//  Created by Fly_Fish_King on 15/5/7.
//  Copyright (c) 2015年 Fly_Fish_King. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QCPopoverBtn;

@protocol QCPopViewControllerDelegate <NSObject>

- (void)dismissPopupControllerAnimated:(BOOL)flag;

@end



typedef enum {
    CZPopViewPositionBottomLeft,
    CZPopViewPositionBottomCenter,
    CZPopViewPositionBottomRight,
    CZPopViewPositionWindowCeter,
    CZPopViewPositionWindowBottom,
}CZPopViewPosition;

/**
 *  自定义回调的button
 *
 *  @param button <#button description#>
 */
typedef void(^QCSelectionHandler) (QCPopoverBtn *button);

@interface QCPopoverBtn : UIButton

@property (nonatomic, strong) QCSelectionHandler QCSelectionHandler;

@end




@interface QCPopViewController : NSObject

@property (nonatomic,weak) id<QCPopViewControllerDelegate> delegate;


/**
 *  返回一个实例
 *
 *  @param contentView Pop里面内容View
 */
-(instancetype)initWithContentView:(UIView *)contentView;


/**
 *  在哪个view显示
 *  默认中心显示popView
 */
-(void)showInView:(UIView *)inView;


/**
 *  在哪个view 底部的某个位置显示
 */
-(void)showInView:(UIView *)inView position:(CZPopViewPosition)position;

/**
 *  给个遮盖透明度
 */
@property (nonatomic,assign) CGFloat alpha;

/**
 *  隐藏当前popview
 */
-(void)dissmiss;

@end
