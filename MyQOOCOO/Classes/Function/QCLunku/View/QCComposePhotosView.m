//
//  QCComposePhotoView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/19.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCComposePhotosView.h"
#import "Item.h"
#import "PicAndTextActionSheet.h"

#define imageH 80
#define imageW 80
#define kMaxColumn 4
#define kMaxImageCount 9
#define kDeleteImageWH 24
#define kDeleteImage @"but_deletelatel" //删除按钮图片
#define kAddImage @"but_addimg" //添加按钮图片


@interface QCComposePhotosView()<DownSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSInteger editTag;//表示编辑按钮-1为新添加的添加按钮
}

@end

@implementation QCComposePhotosView
#pragma mark - 懒加载
-(NSMutableArray *)images{
    if (_images == nil) {
        _images = [[NSMutableArray alloc]init];
        
    }
    return _images;
}

#pragma mark - 初始化
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //创建按钮
        UIButton *button = [self creatButtonWithImage:kAddImage andSelector:nil];
        [button addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    return self;
}

-(void)addNew:(UIButton *)button{
    if (![self deleteBtnClose:button]) {
        editTag = -1;
        [self callImagePicker];
    }
    
}
-(void)changeOld:(UIButton *)button{
    if (![self deleteBtnClose:button]) {
        editTag = button.tag;
        [self callImagePicker];
    }
}
//删除删除按钮
-(BOOL)deleteBtnClose:(UIButton *)button{
    if (button.subviews.count == 2) {
        [[button.subviews lastObject] removeFromSuperview];
        [self stopShake:button];
        return YES;
    }
    return NO;
}
#pragma mark - 调用图片选择器
-(void)callImagePicker{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 添加按钮
-(UIButton *)creatButtonWithImage:(id)imageNameOrImage andSelector:(SEL)selector{
    UIImage *addImage = nil;
    if ([imageNameOrImage isKindOfClass:[NSString class]]) {
        addImage = [UIImage imageNamed:imageNameOrImage];
    }
    if ([imageNameOrImage isKindOfClass:[UIImage class]]) {
        addImage = imageNameOrImage;
    }
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:addImage forState:UIControlStateNormal];
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = self.subviews.count;
    //添加长按删除
    if (addBtn.tag!= 0) {
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [addBtn addGestureRecognizer:longpress];
    }
    return addBtn;
    
}
-(void)longPress:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIButton *btn = (UIButton *)gesture.view;
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.bounds = CGRectMake(0, 0, kDeleteImageWH, kDeleteImageWH);
        [deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:[UIImage imageNamed:kDeleteImage] forState:UIControlStateNormal];
        deleteBtn.frame = CGRectMake(btn.width - deleteBtn.width, 0, kDeleteImageWH, kDeleteImageWH);
        [btn addSubview:deleteBtn];
        [self startShake:btn];//开始抖动
    }
    
}
//删除图片
-(void)deletePicture:(UIButton *)button{
    [self.images removeObject:[(UIButton *)button.superview imageForState:UIControlStateNormal]];
    [button.superview removeFromSuperview];
    if ([[self.subviews lastObject] isHidden]) {
        [[self.subviews lastObject] setHidden:NO];
    }
}
-(void)startShake:(UIButton *)button{
    double angel1 = -2/180.0 * M_PI;
    double angel2 = 2/180.0 * M_PI;
    CAKeyframeAnimation *keyAnimate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//动画
    keyAnimate.values = @[@(angel1),@(angel2),@(angel1)];
    keyAnimate.duration = .25;
    keyAnimate.repeatCount = MAXFLOAT;//重复次数
    keyAnimate.removedOnCompletion = NO;
    keyAnimate.fillMode = kCAFillModeForwards;
    [button.layer addAnimation:keyAnimate forKey:@"shake"];//在layer层添加动画
}
-(void)stopShake:(UIButton *)button{
    [button.layer removeAnimationForKey:@"shake"];
}

#pragma mark - 对所有的子控件布局
-(void)layoutSubviews{
    [super layoutSubviews];
    int count = (int)self.subviews.count;
    int maxColum = kMaxColumn;
    CGFloat marginX = (self.width - imageW * maxColum) / (kMaxColumn + 1);
    CGFloat marginY = marginX;
    for (int i = 0; i < count; i++) {
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        UIButton *button = self.subviews[i];
        btnX = (i % maxColum) * (marginX + imageW) + marginX;
       btnY = (i / maxColum) * (marginY + imageH) +marginY;
        button.frame = CGRectMake(btnX, btnY, imageW, imageH);
    }
}
//能否设置photoViewHigh
-(void)setPhotoViewHigh:(CGFloat)photoViewHigh{
    
}

#pragma mark - imagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];//从字典里面
    if (editTag == -1) {
        UIButton *button = [self creatButtonWithImage:image andSelector:@selector(changeOld:)];
        [self insertSubview:button atIndex:self.subviews.count - 1];
        [self.images addObject:image];
        if (self.subviews.count - 1 == kMaxImageCount) {
            [[self.subviews lastObject] setHidden:YES];
        }
        
    }else{
        //根据tag修改需要编辑的控件
        UIButton *button = (UIButton *)[self viewWithTag:editTag];
//        NSInteger index = [self.images indexOfObject:[button imageForState:UIControlStateNormal]];
        NSInteger index = [self.images indexOfObject:button];
        
//        [self.images removeObjectAtIndex:index];
        [button setImage:image forState:UIControlStateNormal];
        [self.images insertObject:image atIndex:index];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 添加图片
-(void)addImageButtonClick:(UIButton *)sender{
    //弹出sheetView
    Item *item1 = [[Item alloc]init];
    item1.icon = @"photo";
    item1.title = @"从相册选择";
    Item *item2 = [[Item alloc]init];
    item2.icon = @"camera";
    item2.title = @"拍照";
    NSArray *listData = [NSArray arrayWithObjects:item1,item2, nil];
    PicAndTextActionSheet *sheet = [[PicAndTextActionSheet alloc]initWithList:listData title:@"选择图片"];
    sheet.delegate = self;
    [sheet showInView:nil];
    
}
-(void) didSelectIndex:(NSInteger)index{
    if (index == 1) {
        [self callImagePicker];
    }
}


@end
