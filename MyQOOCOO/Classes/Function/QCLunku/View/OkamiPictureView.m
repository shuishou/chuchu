//
//  OkamiPictureView.m
//  MosquitoAnimation
//
//  Created by 贤荣 on 15/12/3.
//  Copyright © 2015年 duobeibao. All rights reserved.
//

#import "OkamiPictureView.h"

@interface OkamiPictureView()

@end

@implementation OkamiPictureView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //        1、设置pictureView的内容显示模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setPic:(NSString *)pic{
    _pic = pic;
//    NSLog(@"pic===%@",pic);
    [self sd_setImageWithURL:[NSURL URLWithString:pic]];
}


@end
