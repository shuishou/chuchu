//
//  OkamiPhotoView.m
//  MosquitoAnimation
//
//  Created by 贤荣 on 15/12/3.
//  Copyright © 2015年 duobeibao. All rights reserved.
//

#import "OkamiPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "OkamiPictureView.h"

//设置图片最多数为9
#define kPictureMaxCount 9
//  最大显示列数，只要有图片，除了count=4的情况，都显示成3列
#define kMaxCol(count) (count == 4 ? 2 : 3 )
#define kPicW ([UIScreen mainScreen].bounds.size.width - 10*2 - 8*4)/3  //图片宽度
#define kPicH kPicW //图片高度
#define kPicMagin 8  // 图片之间的间距


@implementation OkamiPhotoView

// 方案：初始化创建9个pictureView，图片没到9各个的，让他们隐藏起来
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (NSInteger i = 0; i < kPictureMaxCount ; i++) {
            OkamiPictureView *pictureView =[[OkamiPictureView alloc]init];
            
            pictureView.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
            [pictureView addGestureRecognizer:tap];
            pictureView.tag = i;
            
            [self addSubview:pictureView];
        }
    }
    return self;
}

-(void)awakeFromNib{
    for (NSInteger i = 0; i < kPictureMaxCount ; i++) {
        OkamiPictureView *pictureView =[[OkamiPictureView alloc]init];
        
        pictureView.userInteractionEnabled =YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
        [pictureView addGestureRecognizer:tap];
        pictureView.tag = i;
        
        [self addSubview:pictureView];
}
}

#pragma mark - 集成图片浏览器
-(void)imgClick:(UITapGestureRecognizer*)recognizer{
    
    MJPhotoBrowser * brower = [[MJPhotoBrowser alloc]init];
    NSMutableArray *mjPhotos = [NSMutableArray array];
    NSInteger imgCount = self.dynamicImgPaths.count;
    for (NSInteger i = 0; i< imgCount; i++) {
        
        NSString * picUrl = self.dynamicImgPaths[i];
        MJPhoto *mjPhoto =[[MJPhoto alloc]init];
        mjPhoto.url = [NSURL URLWithString:picUrl];
        mjPhoto.srcImageView = self.subviews[i];
        [mjPhotos addObject:mjPhoto];
    }
    brower.photos = mjPhotos;
    brower.currentPhotoIndex = recognizer.view.tag;
    [brower show];
}

#pragma mark - 传入图片数，返回photoView的尺寸
+(CGSize)photoViewSizeWithPictureCount:(NSInteger)count{
    /*  
     0张不显示，最多显示9张
     1、2、3   张图片，显示1行3列
     4        张图片，显示2行2列
     5、6     张图片，显示2行3列
     7、8、9  张图片，显示3行3列
     */
    
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


-(void)setDynamicImgPaths:(NSMutableArray *)dynamicImgPaths{
    _dynamicImgPaths = dynamicImgPaths;
    
    //    最大显示图片列数
    NSInteger maxCol = kMaxCol(dynamicImgPaths.count);
    
    long dycount=MIN(dynamicImgPaths.count, kPictureMaxCount);
    
    for (NSInteger i = 0; i < dycount; i++) {
        OkamiPictureView *pictureView = self.subviews[i];
        
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
            pictureView.pic = dynamicImgPaths[i];
            
        }else{//无图片的要隐藏起来
            pictureView.hidden = YES;
        }
    }
    
}




@end
