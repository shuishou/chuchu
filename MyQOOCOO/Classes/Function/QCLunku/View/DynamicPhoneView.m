//
//  DynamicPhoneView.m
//  MosquitoAnimation
//
//  Created by 贤荣 on 15/12/4.
//  Copyright © 2015年 duobeibao. All rights reserved.
//

#import "DynamicPhoneView.h"

//设置图片最多数为9
#define kPictureMaxCount 9
//  最大显示列数，只要有图片，除了count=4的情况，都显示成3列
#define kMaxCol(count) (count == 4 ? 2 : 3 )
#define kPicW ([UIScreen mainScreen].bounds.size.width - 2*1)/3  //图片宽度
#define kPicH kPicW //图片高度
#define kPicMagin 1  // 图片之间的间距

@implementation DynamicPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (NSInteger i = 0; i < kPictureMaxCount ; i++) {
            UIImageView *pictureView =[[UIImageView alloc]init];
        
            pictureView.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
            [pictureView addGestureRecognizer:tap];
            pictureView.tag = i;
            
            [self addSubview:pictureView];
        }
    }
    return self;
}

#pragma mark - 跳转到单个图片的表情详情
-(void)imgClick:(UITapGestureRecognizer*)recognizer{

//    MyLog(@"我要跳转");
    
    NSString * picUrl = self.dynamicImgPaths[recognizer.view.tag];
    
    if ([self.delegate respondsToSelector:@selector(pushSinglePictureVC:)]) {
        [self.delegate pushSinglePictureVC:picUrl];
    }
}

#pragma mark - 传入图片数，返回photoView的尺寸
+(CGSize)photoViewSizeWithPictureCount:(NSInteger)count{

    if (count==0) { //没图片
        return CGSizeMake(0, 0);
    }
    
    //    最大显示图片列数
    NSInteger maxCol = kMaxCol(count);
    //    最大显示图片行数
    NSInteger row = count / maxCol;
    if (count % maxCol !=0) {
        row++;
    }
    CGFloat photoW = (kPicW + kPicMagin) * maxCol - kPicMagin;
    CGFloat photoH = (kPicH + kPicMagin) * row - kPicMagin;
    
    CGSize photoSize = CGSizeMake(photoW, photoH);
    
    return photoSize;
}


-(void)setDynamicImgPaths:(NSArray *)dynamicImgPaths{
    _dynamicImgPaths = dynamicImgPaths;
    
    //    最大显示图片列数
    NSInteger maxCol = kMaxCol(dynamicImgPaths.count);
    
    for (NSInteger i = 0; i < kPictureMaxCount; i++) {
        UIImageView *pictureView = self.subviews[i];
        //        1、设置pictureView的内容显示模式
        pictureView.contentMode = UIViewContentModeScaleAspectFill;
        pictureView.clipsToBounds = YES;
        
        if (i < dynamicImgPaths.count) {//有图片的显示
            pictureView.hidden = NO;
            //            计算真实存在的图片占用列数和行数
            CGFloat col = i % maxCol;
            CGFloat row = i / maxCol;
            //            计算子控件frame
            CGFloat pictureX = (kPicW + kPicMagin) * col;
            CGFloat pictureY = (kPicH + kPicMagin) * row;
            pictureView.frame = CGRectMake(pictureX, pictureY, kPicW, kPicH);
            
            //            给子控件的属性赋值（传数据）
            NSString * picUrlStr = dynamicImgPaths[i];
             [pictureView  sd_setImageWithURL:[NSURL URLWithString:picUrlStr]];
            
        }else{//无图片的要隐藏起来
            pictureView.hidden = YES;
        }
    }
    
}

@end
