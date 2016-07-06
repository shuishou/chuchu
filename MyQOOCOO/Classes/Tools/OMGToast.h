//
//  OMGToast.h
//  Smart
//
//  Created by fenguo on 14-10-30.
//  Copyright (c) 2014年 Fenguo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEFAULT_DISPLAY_DURATION 2.0f
@interface OMGToast : NSObject{
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

//default style
+ (void)showText:(NSString *)text_;


@end
