//
//  BaseViewController.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+NavExtension.h"
#import "MBProgressHUD.h"


@interface QCBaseVC : UIViewController
{
    
}

@property (nonatomic, retain)MBProgressHUD  *hud;


@property (retain, nonatomic)UILabel * titleLabel;


-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;

 /** 保存照片到本地相册*/
-(void)showTopReminder:(NSString *)content withDuration:(NSTimeInterval)duration withExigency:(BOOL)exigency isSucceed:(BOOL)succeed;


@end
