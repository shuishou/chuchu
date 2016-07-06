//
//  QCPhotosView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCPhotosView.h"
#import "ZYQAssetPickerController.h"
#import "XSUtils.h"
// 每行有4个
#define kZBMessageShareMenuPerRowItemCount 4
#define kZBMessageShareMenuPerColum 2

#define kZBShareMenuItemIconSize 60
#define KZBShareMenuItemHeight 80

#define MaxItemCount 9
#define ItemWidth 107
#define ItemHeight 107


@interface QCPhotosView (){
    UILabel *lblNum;
}


/**
 *  这是背景滚动视图
 */
@property(nonatomic,strong) UIScrollView *photoScrollView;
@property (nonatomic, weak) UIScrollView *shareMenuScrollView;
@property (nonatomic, weak) UIPageControl *shareMenuPageControl;
@property(nonatomic,weak)UIButton *btnviewphoto;
@end

@implementation QCPhotosView
@synthesize photoMenuItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

//这个方法没有执行
- (void)photoItemButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelecteShareMenuItem:atIndex:)]) {
        NSInteger index = sender.tag;
        //        NSLog(@"self.photoMenuItems.count is %lu",(unsigned long)self.photoMenuItems.count);
        if (index < self.photoMenuItems.count) {
            [self.delegate didSelectePhotoMenuItem:[self.photoMenuItems objectAtIndex:index] atIndex:index];
        }
    }
}

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithHex:0XFAFAFA];
    
    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _photoScrollView.contentSize = CGSizeMake(1024, CGRectGetHeight(self.frame));
    
    photoMenuItems = [[NSMutableArray alloc]init];
    _itemArray = [[NSMutableArray alloc]init];
    [self addSubview:_photoScrollView];
    lblNum = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-50, CGRectGetWidth(self.frame), 30)];
    lblNum.font = [UIFont systemFontOfSize:12];
    lblNum.textColor = [UIColor colorWithHex:0x868686];
    lblNum.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lblNum];
    
    [self initlizerScrollView:self.photoMenuItems];
    
}

-(void)reloadDataWithImage:(UIImage *)image{
    [self.photoMenuItems addObject:image];
    
    [self initlizerScrollView:self.photoMenuItems];
}

-(void)initlizerScrollView:(NSArray *)imgList{
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CZLog(@"imglistCount = %zd",imgList.count);
    for(int i=0;i<imgList.count;i++){
        
        UIImage *tempImg;
        if ([imgList[i] isKindOfClass:[ALAsset class]]) {
            ALAsset * asset=imgList[i];
            tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        }else{
            tempImg = imgList[i];
        }
        
        
        
        //  UIImage *image = [imgList objectAtIndex:i];
        
        MessagePhotoMenuItem *photoItem = [[MessagePhotoMenuItem alloc]initWithFrame:CGRectMake(30+ i * (ItemWidth + 5 ), 40, ItemWidth, ItemHeight)];
        photoItem.delegate = self;
        photoItem.index = i;
        photoItem.contentImage = tempImg;
        [self.photoScrollView addSubview:photoItem];
        [self.itemArray addObject:photoItem];
    }
    
    if(imgList.count < MaxItemCount){
        UIButton * btnphoto=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnphoto setFrame:CGRectMake(30 + (ItemWidth+5) * imgList.count, 40, ItemWidth, ItemHeight)];//
        [btnphoto setImage:[UIImage imageNamed:@"but_addimg"] forState:UIControlStateNormal];
        //给添加按钮加点击事件
        [btnphoto addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScrollView addSubview:btnphoto];
    }
    
    NSInteger count = MIN(imgList.count +1, MaxItemCount);
    lblNum.text = [NSString stringWithFormat:@"已选%ld张，共可选9张",(unsigned long)self.photoMenuItems.count];
    lblNum.backgroundColor = [UIColor clearColor];
    [self.photoScrollView setContentSize:CGSizeMake(50 + (ItemWidth + 5)*count, 0)];
    
    if ([self.delegate respondsToSelector:@selector(getChooseImageArray:)]) {
        [self.delegate getChooseImageArray:imgList];
    }
}
-(void)openMenu{
    
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    [myActionSheet showInView:self.window];
    
}
//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
}

//开始拍照
-(void)takePhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([XSUtils cameraLimit]==NO) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许库牌访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        if ([self.delegate respondsToSelector:@selector(addTakePhoto:)]) {
            [self.delegate addTakePhoto:picker];
        }
    }
    
}

-(void)localPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    picker.maximumNumberOfSelection = MaxItemCount;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    
    [self.delegate addPicker:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.photoMenuItems.count<10) {
            [self.photoMenuItems addObject:chosenImage];
            [self initlizerScrollView:self.photoMenuItems];
        }
    });
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.photoMenuItems.count<10) {
        if (self.photoMenuItems.count+assets.count<=10) {
            [self.photoMenuItems addObjectsFromArray:assets];
            [self initlizerScrollView:self.photoMenuItems];
        }else{
            for (int i = 0; i<=10-self.photoMenuItems.count; i++) {
                [self.photoMenuItems addObject:assets[i]];
                
            }
            [self initlizerScrollView:self.photoMenuItems];
        }
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadData {
    [ self initlizerScrollView:nil];
}
- (void)dealloc {
    
}

#pragma mark - MessagePhotoItemDelegate

-(void)messagePhotoItemView:(MessagePhotoMenuItem *)messagePhotoItemView didSelectDeleteButtonAtIndex:(NSInteger)index{
    [self.photoMenuItems removeObjectAtIndex:index];
    [self initlizerScrollView:self.photoMenuItems];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.shareMenuPageControl setCurrentPage:currentPage];
}


@end
