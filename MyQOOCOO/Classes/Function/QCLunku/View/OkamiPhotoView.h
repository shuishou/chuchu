//
//  OkamiPhotoView.h
//  MosquitoAnimation
//
//  Created by 贤荣 on 15/12/3.
//  Copyright © 2015年 duobeibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OkamiPhotoView : UIView

//   传入图片数，返回photoView的尺寸
+(CGSize)photoViewSizeWithPictureCount:(NSInteger)count;

@property (nonatomic,strong) NSMutableArray * dynamicImgPaths;


@end
