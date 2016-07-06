//
//  UIButton+MyButton.m
//  app
//
//  Created by LINAICAI on 15/7/30.
//  Copyright (c) 2015年 linaicai. All rights reserved.
//

#import "UIButton+MyButton.h"
#import <objc/runtime.h>
static const void *UtilityKey = &UtilityKey;
@implementation UIButton (MyButton)
@dynamic eventHandler;
- (buttonHandler)eventHandler {
    return objc_getAssociatedObject(self, UtilityKey);
}

- (void)setEventHandler:(buttonHandler)eventHandler {
    objc_setAssociatedObject(self, UtilityKey, eventHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)nextButton:(buttonHandler)handler{
    [self setEventHandler:handler];
    [self setTitle:@"下一步" forState:UIControlStateNormal];
    [self.layer setCornerRadius:5];
    [self.layer setMasksToBounds:YES];
    [self setBackgroundColor:[UIColor NavigationBarBackgroundColor]];
    [self setTintColor:[UIColor whiteColor]];
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)completeButton:(buttonHandler)handler{
    [self setEventHandler:handler];
    [self setTitle:@"完成" forState:UIControlStateNormal];
    [self.layer setCornerRadius:5];
    [self.layer setMasksToBounds:YES];
    [self setBackgroundColor:[UIColor NavigationBarBackgroundColor]];
    [self setTintColor:[UIColor whiteColor]];
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)editButton:(buttonHandler)handler{
    [self setEventHandler:handler];
    [self.layer setCornerRadius:7];
    [self.layer setBorderColor:[UIColor NavigationBarBackgroundColor].CGColor];
    [self.layer setBorderWidth:1];
    [self.layer setMasksToBounds:YES];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)expandButton:(buttonHandler)handler{
    [self setEventHandler:handler];
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionButton:(buttonHandler)handler{
    [self setEventHandler:handler];
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClick:(id)sender{
    if (self.eventHandler) {
        self.eventHandler(sender);
    }
}
@end
