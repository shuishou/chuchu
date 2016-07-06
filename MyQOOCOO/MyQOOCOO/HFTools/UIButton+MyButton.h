//
//  UIButton+MyButton.h
//  app
//
//  Created by LINAICAI on 15/7/30.
//  Copyright (c) 2015年 linaicai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonHandler)(UIButton *sender);
@interface UIButton (MyButton)
@property (nonatomic, copy) buttonHandler eventHandler;
-(void)nextButton:(buttonHandler)handler;
-(void)completeButton:(buttonHandler)handler;
-(void)editButton:(buttonHandler)handler;
-(void)expandButton:(buttonHandler)handler;
-(void)actionButton:(buttonHandler)handler;
@end
