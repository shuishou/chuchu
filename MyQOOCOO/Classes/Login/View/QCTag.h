//
//  QCTag.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/11.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCTag;
@protocol QCTagDelegate <NSObject>

-(void)tagView:(QCTag *)tagView longPressIndex:(NSInteger)index;
-(void)tagView:(QCTag *)tagView deleteTagView:(NSInteger)index;
@end

@interface QCTag : UIButton
- (instancetype)initWithFrame:(CGRect)frame qcTag:(NSString *)qcTag;
@property ( nonatomic , assign) id<QCTagDelegate> delegate;
/**
 *  是否显示删除按钮
 *
 *  @param isShow yes 显示  no不显示
 */
-(void)showDelegateButton:(BOOL)isShow;
@end
