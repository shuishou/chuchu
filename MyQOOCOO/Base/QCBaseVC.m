//
//  BaseViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "UIColor+Hex.h"
#import "UIView+Extension.h"

@interface QCBaseVC ()

@end

@implementation QCBaseVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

// 注意，只能在viewdidload 以后调用
-(NSString *)getPrevTitle
{
    NSString *title = @"";
    if ([self.navigationController.viewControllers count] > 1)
    {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index != NSNotFound && (index -1) < [self.navigationController.viewControllers count])
        {
            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:index-1];
            if (vc.navigationItem.titleView)
            {
                UIView *lable = vc.navigationItem.titleView;
                if ([lable isKindOfClass:[UILabel class]])
                {
                    title = ((UILabel *)lable).text;
                }
            }
            else
            {
                title = vc.title;
            }
        }
    }
    
    return title;
}

-(void)addBackButton
{
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kGlobalBackGroundColor;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}

-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud hide:YES afterDelay:1];
}

-(void)hideHUD
{
    [self.hud hide:YES];
}

 /** 保存照片到相册*/
-(void)showTopReminder:(NSString *)content withDuration:(NSTimeInterval)duration withExigency:(BOOL)exigency isSucceed:(BOOL)succeed{
    UIView * subView = [self.view viewWithTag:8950];
    if (subView) {
        return;
    }else{
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_W-20, 200) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectZero];
        view.tag = 8950;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = content;
        label.numberOfLines = 0;
        [view addSubview:label];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        if (succeed) {
            imageView.image = [UIImage imageNamed:@"icon_success_hite"];
        }else{
            imageView.image = [UIImage imageNamed:@"icon_dialog"];
        }
        
        
        if(exigency){
            view.frame = CGRectMake(0, -size.height-20/2, SCREEN_W, size.height+20);
            view.backgroundColor = [UIColor colorWithHex:0xe73c3c alpha:0.85];
            label.textColor = [UIColor whiteColor];
            label.frame = CGRectMake(10, 10, SCREEN_W-20, size.height);
        }else{
            view.frame = CGRectMake((CGRectGetWidth(self.view.frame)-250/2)/2, (CGRectGetHeight(self.view.frame)-220/2)/2, 250/2, 220/2);
            view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0];
            view.layer.cornerRadius = 4;
            view.layer.masksToBounds = YES;
            imageView.frame = CGRectMake((CGRectGetWidth(view.frame)-69/2)/2, (CGRectGetHeight(view.frame)-69/2)/2-20, 69/2, 69/2);
            [view addSubview:imageView];
            label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, CGRectGetWidth(view.frame), 45);
            label.textColor = [UIColor colorWithHex:0xffffff];
        }
        
        [self.view addSubview:view];
        
        [UIView animateWithDuration:0.25 animations:^{
            if (exigency) {
                if(self.navigationController==nil){
                    view.frame = CGRectMake(0, 20, SCREEN_W, size.height+20);
                }else{
                    view.frame = CGRectMake(0, 64, SCREEN_W, size.height+20);
                }
            }else{
                view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.7];
            }
        } completion:^(BOOL finished) {
            if (self) {
                [self performSelector:@selector(hideTopView:) withObject:view afterDelay:duration];
            }
        }];
    }
}
-(void)hideTopView:(UIView *)aView
{
    [UIView animateWithDuration:0.1 animations:^{
        if (aView.frame.size.width>130) {
            aView.center = CGPointMake(SCREEN_W/2, -200);
        }else{
            aView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.0];
            aView.alpha = 0;
        }
        
        
    } completion:^(BOOL finished) {
        [aView removeFromSuperview];
    }];
}



@end
