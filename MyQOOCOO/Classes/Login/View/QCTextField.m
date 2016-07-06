//
//  QCTextField.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/6.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCTextField.h"

@interface QCTextField()


@end

@implementation QCTextField


#pragma mark - 自定义左边视图的textField
/** 自定义左边视图 */
-(instancetype)initWithFrame:(CGRect)frame iconName:(NSString *)iconName placeHolderText:(NSString *)placeHolderText{
    if (self = [super initWithFrame:frame]) {
        UIImage *icon = [UIImage imageNamed:iconName];
        UIImageView *iconView = [[UIImageView alloc]initWithImage:icon];
        self.leftView = iconView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.placeholder = placeHolderText;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    
    iconRect.origin.x += 10;
    
    return iconRect;
}
-(CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 40, 0);
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 40, 0);
}






@end
