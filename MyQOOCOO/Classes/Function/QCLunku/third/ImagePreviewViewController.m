//
//  ImagePreviewViewController.m
//  XSTeachBBS
//
//  Created by Jacky Chan on 9/16/14.
//  Copyright (c) 2014 XSTeach. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "UIImageView+WebCache.h"

@interface ImagePreviewViewController ()
{
    UIView* _inView;
    UIView* _fromView;
    CGRect _originFrame;
    UIScrollView* _scrollView;
    NSInteger _currentIndex;
    UILabel * _currentPage;
    UIButton * _saveButton;
    UITapGestureRecognizer * singleTapGestureRecognizer;
}
@end

@implementation ImagePreviewViewController

- (id)initWithImages:(NSArray *)images {
    self = [self init];

    if (self) {
        self.images = images;
        self.view.clipsToBounds = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-10, 0, ScreenWidth + 10, ScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate  = self;
    _scrollView.bounces = YES;
    [self.view addSubview: _scrollView];

  /*
    UIButton * cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancle setFrame:CGRectMake(10, 25, 50, 30)];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    cancle.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancle setBackgroundColor:BlueColor];
    [cancle setTintColor:[UIColor whiteColor]];
    cancle.layer.cornerRadius = 4;
    cancle.layer.masksToBounds = YES;
    [cancle addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancle];
    [self.view bringSubviewToFront:cancle];
    */
    
    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView:)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}


- (void)showImageAtIndex:(NSInteger)index inView:(UIView *)view fromView:(UIView *)fromView {
    [self.view removeFromSuperview];
    _currentIndex = index;
    _inView = view;
    _fromView = fromView;
    _originFrame = _fromView.frame;
    _originFrame.origin = [_fromView.superview convertPoint:CGPointMake(_fromView.x, _fromView.y) toView:_inView];
    [_inView addSubview: self.view];
    
    for (int i = 0; i < self.images.count; i++) {
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i*_scrollView.width+10, 0, _scrollView.width - 10, _scrollView.height)];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2;
        scrollView.minimumZoomScale = 1;
        scrollView.autoresizesSubviews = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.tag = 500;
        scrollView.showsVerticalScrollIndicator = NO;
      
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
        imageView.backgroundColor = [UIColor clearColor];
        __block UIImageView *img = imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            img.frame = CGRectMake(0, 0, scrollView.width, scrollView.height);
            img.backgroundColor = [UIColor clearColor];
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = _scrollView.center;
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview: imageView];
        [_scrollView addSubview: scrollView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:tap];
        [singleTapGestureRecognizer requireGestureRecognizerToFail:tap];
    }
    _scrollView.contentSize = CGSizeMake(self.images.count * _scrollView.width - 10, ScreenHeight);
    _scrollView.contentOffset = CGPointMake(_currentIndex * _scrollView.width, 0);
    
    UIView * v = [_scrollView.subviews objectAtIndex: _currentIndex];
    v = [v.subviews firstObject];
    v.frame = _originFrame;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        v.contentMode = UIViewContentModeScaleAspectFit;
        v.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    } completion:^(BOOL finished) {
        [self loadActionView];
    }];
    
    
    
}
-(void)loadActionView{
    _currentPage = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-60)/2, CGRectGetHeight(self.view.bounds)-50, 60, 30)];
    _currentPage.textColor = [UIColor whiteColor];
    _currentPage.font = [UIFont systemFontOfSize:12];
    _currentPage.backgroundColor = [UIColor clearColor];
    _currentPage.textAlignment = NSTextAlignmentCenter;
    _currentPage.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,(unsigned long)self.images.count];
    [self.view addSubview:_currentPage];
    
    
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_saveButton setFrame:CGRectMake(250, SCREEN_H-52, 50, 30)];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"icon_download"] forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5.5, 0, 0);
    [_saveButton setTintColor:[UIColor whiteColor]];
    [_saveButton addTarget:self action:@selector(SavePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    [self.view bringSubviewToFront:_saveButton];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag==500) {
        return [scrollView.subviews objectAtIndex:0];
    }else{
        return nil;
    }
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    
    //    首先得 取到这个 被放大的视图
    NSInteger index = _scrollView.contentOffset.x / ScreenWidth;
    UIScrollView * scroll = [_scrollView.subviews objectAtIndex:index];
    //    如果取得的滚动视图的缩放比例是大于等于2 说明是放大过的  需要还原
    if ([scroll isKindOfClass:[UIScrollView class]]) {
        if (scroll.zoomScale >= 2) {
            //        将滚动视图还原到原图大小
            [scroll setZoomScale:1 animated:YES];
        }
        else
        {
            CGPoint locationPoint = [tap locationInView:scroll];
            CGRect rect = CGRectMake(locationPoint.x - 40, locationPoint.y - 40, 80, 80);
            [scroll zoomToRect:rect animated:YES];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    判断如果传进来的参数视图是外层的滚动视图才去计算页码
    if (scrollView == _scrollView) {
        _currentIndex = scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
        _currentPage.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,(unsigned long)self.images.count];
        
        //        遍历一遍 大滚动视图里的 所有小滚动视图 将小滚动视图的缩放还原为1
        for (UIScrollView * scroll in _scrollView.subviews) {
            if ([scroll isKindOfClass:[UIScrollView class]]) {
                [scroll setZoomScale:1 animated:YES];
            }
        }
    }
}


- (void)hide {
    [_currentPage removeFromSuperview];
    [_saveButton removeFromSuperview];
    for (UIScrollView * scroll in _scrollView.subviews) {
        if ([scroll isKindOfClass:[UIScrollView class]]) {
            [scroll setZoomScale:1 animated:YES];
        }
    }
    [self hideToFrame:_originFrame];
}

- (void)hideToFrame:(CGRect)frame {
    UIView* v = [_scrollView.subviews objectAtIndex:_currentIndex];
    v = [v.subviews firstObject];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        v.frame = frame;
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
        
        if (self.delegate) {
            [self.delegate didHideImagePreviewViewController:self];
        }
    }];
}

- (void)closeView:(id)sender {
    [self hide];
}
-(void)SavePicture{
    NSInteger index = _scrollView.contentOffset.x / ScreenWidth;
    UIScrollView * scroll = [_scrollView.subviews objectAtIndex:index];
    UIImageView * imageView = [scroll.subviews objectAtIndex:0];
    if ([imageView isKindOfClass:[UIImageView class]]) {
        UIImageWriteToSavedPhotosAlbum([imageView image], nil, nil,nil);
        [self showTopReminder:@"图片已保存到相册" withDuration:1.5 withExigency:NO isSucceed:YES];
//        QCBaseVC
    }
    
}
@end
