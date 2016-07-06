//
//  UIViewController+NavExtension.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "UIViewController+NavExtension.h"

@implementation UIViewController (NavExtension)

-(void)addBackButtonItemWithTitle:(NSString *)title
{
    if (self.navigationItem)
    {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(leftItemClick:)];
        
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

-(void)addBackButtonItemWithImage:(UIImage *)img
{
    if (self.navigationItem)
    {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, 0, 21, 21);
        [btnBack setBackgroundImage:img forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

-(void)addRightButtonItemWithImage:(UIImage *)img{
    if (self.navigationItem) {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, 0, 21, 21);
        [btnBack setBackgroundImage:img forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.rightBarButtonItem = backItem;
    }
}

-(void)addRightButtonItemWithTitle:(NSString *)title{
    if (self.navigationItem)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(rightItemClick:)];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

-(void)leftItemClick:(id)sende
{
    if ([self.navigationController.viewControllers count] > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightItemClick:(id)sender
{
    
}

@end
