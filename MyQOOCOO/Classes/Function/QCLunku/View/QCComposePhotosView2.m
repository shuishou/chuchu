//
//  QCComposePhotosView2.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/27.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#define kImageH 80
#define kImageW 80
#define kMaxColumn 4
#define kMaxImageCount 9
#define kDeleteImageWH 24
#define kDeleteImage @"but_deletelatel" //删除按钮图片
#define kAddImage @"but_addimg" //添加按钮图片

#define kImgCountPerRow 4 //每行显示多个图片

#import "QCComposePhotosView2.h"

@interface QCComposePhotosView2 ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *_addBtn;
    
}

@end

@implementation QCComposePhotosView2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        //添加按钮
        [self setupSubView];
        
    }
    return self;
}
-(void)setupSubView{
    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, kImageW, kImageH)];
    [_addBtn setImage:[UIImage imageNamed:kAddImage] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(showImgPickerController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
}

-(void)addImg:(UIImage *)img{
    
    // 显示图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = img;
    [self addSubview:imgView];
    
    
    // 遍历所有UIImageVIew 然后设置frm
    NSInteger count = self.subviews.count;
    
    //CGFloat imgW = （宽度 - 5个间距） / 4
    CGFloat margin = 5;
    CGFloat imgW = (self.width - (kImgCountPerRow + 1) * margin) / kImgCountPerRow;
    CGFloat imgH = imgW;
    
    for (NSInteger i = 0;i < count ; i++ ) {
        CGFloat cols = i % kImgCountPerRow;
        CGFloat row = i / kImgCountPerRow;
        
        CGFloat imgX =  margin + (imgW + margin) * cols;
        CGFloat imgY =  margin + (imgH + margin) * row;
        UIView *subView = self.subviews[i];
        subView.frame = CGRectMake(imgX, imgY, imgW, imgH);
    }
    
    CZLog(@"添加图片 %ld",self.subviews.count);
}

-(BOOL)hasImgs{
    return self.subviews.count > 0;
}


-(NSArray *)images{
    NSMutableArray *imgsM = [NSMutableArray array];
    for (UIImageView *imgView in self.subviews) {
        [imgsM addObject:imgView.image];
    }
    return [imgsM copy];
}

#pragma mark 弹出图片选择器
-(void)showImgPickerController{
    
    UIImagePickerController *imgPickerContr = [[UIImagePickerController alloc] init];
    
    imgPickerContr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imgPickerContr.delegate = self;
    
    [self.window.rootViewController presentViewController:imgPickerContr animated:YES completion:nil];
}
#pragma mark 图片选中
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    CZLog(@"%@",info);
    // 1.获取图片
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    // 2.往photosView添加图片
    [self addImg:img];
    
     // 3.把图片图片选择器dismiss
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

    // 4.让键盘弹出来
    [self becomeFirstResponder];

    
}



@end
