//
//  QCPhotosView.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MessagePhotoMenuItem.h"
#import "ZYQAssetPickerController.h"

#define kZBMessageShareMenuPageControlHeight 30


@protocol QCPhotosViewDelegate <NSObject>


@optional
- (void)didSelectePhotoMenuItem:(MessagePhotoMenuItem *)shareMenuItem atIndex:(NSInteger)index;

-(void)addPicker:(ZYQAssetPickerController *)picker;          //UIImagePickerController
-(void)addTakePhoto:(UIImagePickerController *)picker;
-(void)addUIImagePicker:(UIImagePickerController *)picker;

-(void)getChooseImageArray:(NSArray *)imgsArray;

@end

@interface QCPhotosView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,MessagePhotoItemDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
}
@property(nonatomic,strong) UIScrollView *scrollview;

/**
 *  第三方功能Models
 */
@property (nonatomic, strong) NSMutableArray *photoMenuItems;

@property(nonatomic,strong) NSMutableArray *itemArray;

@property (nonatomic, assign) id <QCPhotosViewDelegate> delegate;

-(void)reloadDataWithImage:(UIImage *)image;

- (void)reloadData;

@end
