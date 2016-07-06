//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>

@protocol MJPhotoBrowserDelegate;

@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate>

// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSMutableArray * photos;
// 当前展示的图片索引
@property (nonatomic, assign) int currentPhotoIndex;
// 是否可删除图片
@property (nonatomic, assign) BOOL deltetable;
// 文字描述
@property (nonatomic, strong) NSMutableArray *descriptions;
// 显示
- (void)show;

@end

@protocol MJPhotoBrowserDelegate <NSObject>

-(void)CellPhotoImageReload;

@optional
-(void)NewPostImageReload:(NSInteger)ImageIndex;


// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
// 移除某项图片
- (void)deleteImageAtIndex:(NSInteger)index;
@end