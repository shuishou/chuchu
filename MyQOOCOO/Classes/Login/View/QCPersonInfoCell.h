//
//  QCInfoCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/7.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QCPersonInfoCell : UITableViewCell<UITextFieldDelegate>


-(instancetype)initWithname:(NSString *)name placeHolder:(NSString *)placeHolder;

//输入框
@property (nonatomic , strong)UITextField *inputTextField;

@end
