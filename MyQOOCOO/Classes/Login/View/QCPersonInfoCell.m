//
//  QCInfoCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/7.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCPersonInfoCell.h"
#import "CityListViewController.h"



@implementation QCPersonInfoCell

-(instancetype)initWithname:(NSString *)name placeHolder:(NSString *)placeHolder{
    if (self = [super init]) {
        self.backgroundColor = kGlobalBackGroundColor;
        
        //名称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 95, self.height)];
        nameLabel.text = name;
        nameLabel.font = kPersonNickNameLabelFont;
        nameLabel.textColor = kPersonNormalColor;
        [self addSubview:nameLabel];
        
        
        
        //占位符
        _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(95, 0,self.width -95,self.height )];
        _inputTextField.placeholder = placeHolder;
        _inputTextField.font = kPersonNickNameLabelFont;
        _inputTextField.delegate=self;
        _inputTextField.textColor = kPersonNormalColor;
//        _inputTextField.delegate = self;
        [self addSubview:_inputTextField];
        
        //输入符号
//        UITextField *inputTextField = [UITextField alloc]initWithFrame:<#(CGRect)#>
        
        
        
        
    }
    return self;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}





@end
