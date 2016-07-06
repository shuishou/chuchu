//
//  QCTabBarController.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCTabBarItem : UIButton;
-(void)setTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage selectedBack:(UIImage *)backImage;
@end

@interface QCTabBarController : UITabBarController<UITabBarDelegate,UITabBarControllerDelegate>



@end
