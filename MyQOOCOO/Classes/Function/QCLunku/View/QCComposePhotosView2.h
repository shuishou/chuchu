//
//  QCComposePhotosView2.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/27.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCComposePhotosView2 : UIView

/**
 *  动态添加图片
 *
 *  @param img <#img description#>
 */
-(void)addImg:(UIImage *)img;


/**
 *  内部是否有图片
 *
 *
 */
@property (nonatomic,assign) BOOL hasImgs;


/**
 *  所有图片
 */
@property (nonatomic,strong) NSArray * images;
@end
