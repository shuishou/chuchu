//
//  DynamicPhoneView.h
//  MosquitoAnimation
//
//  Created by 贤荣 on 15/12/4.
//  Copyright © 2015年 duobeibao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DynamicPhoneView;
@protocol DynamicPhoneViewDelegate <NSObject>
@optional
-(void)pushSinglePictureVC:(NSString*)picUrlStr;
@end

@interface DynamicPhoneView : UIView

//   传入图片数，返回photoView的尺寸
+(CGSize)photoViewSizeWithPictureCount:(NSInteger)count;

@property (nonatomic,strong) NSArray * dynamicImgPaths;

@property (nonatomic,weak) id <DynamicPhoneViewDelegate> delegate;

@end
