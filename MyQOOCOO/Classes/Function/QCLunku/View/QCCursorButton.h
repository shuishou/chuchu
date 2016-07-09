//
//  QCCursorButton.h
//  MyQOOCOO
//
//  Created by Zhou Shaolin on 16/7/9.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCCursorButton : UIView

@property(nonatomic, strong) UIButton* mainButton;
@property(nonatomic, strong) UIImageView* mainImageView;
@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UIImageView* separatorImageView;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, strong) UIColor* normalColor;
@property(nonatomic, strong) UIColor* selectedColor;

-(instancetype)initWithTitle:(NSString*)title;
-(void)adjustFrame:(CGRect)frame mode:(int)mode;

@end
