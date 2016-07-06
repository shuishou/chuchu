//
//  QCTextView.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCTextView : UITextView
/**
 * 占位符
 */
@property (nonatomic,copy) NSString * placeHolder;

/**
 * 占位符字体颜色
 */
@property (nonatomic,strong) UIColor * placeHolderColor;

@end
