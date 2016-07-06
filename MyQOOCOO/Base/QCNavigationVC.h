//
//  QCNavigationController.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface QCNavigationVC : UINavigationController

-(void)resetNavigationBarColor:(UIColor *)color;

@property (nonatomic,weak) UIImageView *myNavigationBar;
@end
