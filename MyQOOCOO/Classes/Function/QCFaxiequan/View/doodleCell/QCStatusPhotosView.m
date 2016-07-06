//
//  QCStatusPhotosView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//
#define QCStatusPhotoWH 70
#define QCStatusPhotoMargin 12
#define QCStatusPhotoMaxCol(count) ((count==4)?2:3)
#import "QCStatusPhotosView.h"
#import "QCPhoto.h"
#import "QCStatusPhotoView.h"


@implementation QCStatusPhotosView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setSinglePhoto:(NSString *)singlePhotoUrl{
    _singlePhotoUrl = singlePhotoUrl;
    NSURL *url = [NSURL URLWithString:singlePhotoUrl];
    _imageView = [[QCStatusPhotoView alloc]init];
    [_imageView sd_setImageWithURL:url];
    [self addSubview:_imageView];
}
-(void)setImageView:(QCStatusPhotoView *)imageView{
    _imageView = imageView;
}
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSUInteger photosCount = photos.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        QCStatusPhotoView *photoView = [[QCStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        QCStatusPhotoView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = QCStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        QCStatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (QCStatusPhotoWH + QCStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (QCStatusPhotoWH + QCStatusPhotoMargin);
        photoView.width = QCStatusPhotoWH;
        photoView.height = QCStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = QCStatusPhotoMaxCol(count);
    
    ///Users/apple/Desktop/课堂共享/05-iPhone项目/1018/代码/黑马微博2期35-相册/黑马微博2期/Classes/Home(首页)/View/HWStatusPhotosView.m 列数
    NSUInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * QCStatusPhotoWH + (cols - 1) * QCStatusPhotoMargin;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * QCStatusPhotoWH + (rows - 1) * QCStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
