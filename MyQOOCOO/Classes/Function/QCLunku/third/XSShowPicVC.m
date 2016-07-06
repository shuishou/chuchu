//
//  XSShowPicVC.m
//  XSTeachEDU
//
//  Created by xsteach on 14/12/29.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import "XSShowPicVC.h"
#import "XSPicBrowseView.h"


@interface XSShowPicVC (){
    UILabel * _currentPage;
    UIButton * _saveButton;
    NSInteger _index;
    NSInteger _count;
    XSPicBrowseView * _picBrowseView;
    NSMutableArray * _imageArray;
}

@end


@implementation XSShowPicVC
- (id)initWithSourceData:(NSMutableArray *)imgSource withIndex:(NSInteger)index{
    if (self = [super init]) {
        if(IOS_VERSION>=7.0){
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        _index = index;
        _count = imgSource.count;
        _imageArray = [NSMutableArray arrayWithArray:imgSource];
    }
    return self;
}
-(void)viewDidLoad{
    
    [self addBackButton];
    
    _picBrowseView = [[XSPicBrowseView alloc]
                      initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)
                      withSourceData:_imageArray
                      withIndex:_index];
    _picBrowseView.picBrowsedelegate = self;
    [self.view addSubview:_picBrowseView];
    self.view.backgroundColor = [UIColor blackColor];
    
    _currentPage = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-60)/2, CGRectGetHeight(self.view.bounds)-50, 60, 30)];
    _currentPage.textColor = [UIColor whiteColor];
    _currentPage.font = [UIFont systemFontOfSize:17];
    _currentPage.backgroundColor = [UIColor clearColor];
    _currentPage.textAlignment = NSTextAlignmentCenter;
    _currentPage.text = [NSString stringWithFormat:@"%ld/%lu",(long)_index+1,(long)_count];
    self.navigationItem.titleView = _currentPage;
    
    
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_saveButton setFrame:CGRectMake(0, 0, 40, 30)];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    _saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5.5, 0, 0);
    [_saveButton setTintColor:[UIColor whiteColor]];
    [_saveButton addTarget:self action:@selector(SavePicture) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveButton];
//    [self.view addSubview:_saveButton];
}

-(void)addBackButton
{
    
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_pic"]
                                                              style:UIBarButtonItemStyleDone
                                                             target:self action:@selector(backAction)];
    back.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    self.navigationItem.leftBarButtonItem = back;

}

-(void)XSPicBrowseView:(XSPicBrowseView *)picBrowseViewClose{
    /*[UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];*/
}
-(void)XSPicBrowseView:(XSPicBrowseView *)picBrowseView currentIndex:(NSInteger)index{
    _currentPage.text = [NSString stringWithFormat:@"%ld/%lu",(long)index+1,(long)_count];
    _index = index;
}
-(void)SavePicture{
    UIImageView * imageView =[[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[_index]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        [self showTopReminder:@"图片已保存到相册" withDuration:1.5 withExigency:NO isSucceed:YES];
    }];
    
    
}
-(void)show{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
//        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    }];
}
@end
