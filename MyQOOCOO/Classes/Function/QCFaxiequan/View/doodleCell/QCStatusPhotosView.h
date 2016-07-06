//
//  QCStatusPhotosView.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCStatusPhotoView.h"

@interface QCStatusPhotosView : UIView


@property (nonatomic, strong) NSArray *photos;
@property (nonatomic , copy) NSString *singlePhotoUrl;
@property (nonatomic , strong)QCStatusPhotoView *imageView;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;
@end
