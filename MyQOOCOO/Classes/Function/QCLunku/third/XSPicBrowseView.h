//
//  XSPicBrowseView.h
//  XSTeachEDU
//
//  Created by xsteach on 14/12/29.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -ENUM
typedef NS_ENUM(NSInteger, MRImgLocation) {
    MRImgLocationLeft,
    MRImgLocationCenter,
    MRImgLocationRight,
};

@protocol XSPicBrowseViewDelegate;

#pragma mark -MRImgShowView
@interface XSPicBrowseView : UIScrollView <UIScrollViewDelegate>
{
    NSDictionary* _imgViewDic;   // 展示板组
}

@property(nonatomic ,assign)NSInteger curIndex;     // 当前显示图片在数据源中的下标

@property(nonatomic ,strong)NSMutableArray *imgSource;

@property(nonatomic ,readonly)MRImgLocation imgLocation;    // 图片在空间中的位置

@property(nonatomic, assign)id<XSPicBrowseViewDelegate> picBrowsedelegate;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame withSourceData:(NSMutableArray *)imgSource withIndex:(NSInteger)index;

- (void)requireDoubleGestureRecognizer:(UITapGestureRecognizer *)tep;

//-(void)show;

@end



@protocol XSPicBrowseViewDelegate <NSObject>

-(void)XSPicBrowseView:(XSPicBrowseView *)picBrowseViewClose;

-(void)XSPicBrowseView:(XSPicBrowseView *)picBrowseView currentIndex:(NSInteger)index;

@end

