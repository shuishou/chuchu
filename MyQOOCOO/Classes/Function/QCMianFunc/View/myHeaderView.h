//
//  myView.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol settingDelegate <NSObject>
-(void)settingVC;
@optional

-(void)changeIcon;
-(void)changeSex;

@end

@interface myHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *heardImage;
@property (nonatomic , strong)UIButton *iconBtn;
@property (nonatomic , strong)UIView *infoView;
@property (nonatomic , strong)UILabel *signMessage;
@property (nonatomic , strong)UIButton *authenticationBtn;
@property (nonatomic , strong)UIButton *settingBtn;
@property ( nonatomic , assign) float headHeight;
@property ( nonatomic , assign,getter=isMan) BOOL sex;
@property (nonatomic,strong)UIImageView*sexImage;


@property (nonatomic,weak) id<settingDelegate> setdelegate;

+(instancetype)initMyHeaderView;




@end
