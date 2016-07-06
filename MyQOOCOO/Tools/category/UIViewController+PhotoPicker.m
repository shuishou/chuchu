//
//  UIViewController+PhotoPicker.m
//
//
//  Created by liangq on 14-8-11.
//  Copyright (c) 2014年 fenguo. All rights reserved.
//

#import "UIViewController+PhotoPicker.h"
#import "MF_Base64Additions.h"
#import <objc/runtime.h>

@interface UIViewController ()

//是否裁剪
@property (nonatomic, assign) BOOL clip;
@property (nonatomic, assign) NSString *sclip;
@end

@implementation UIViewController (PhotoPicker)

#pragma mark - 运行时相关
static char clipKey;

- (BOOL)clip {
    return [(NSNumber *)objc_getAssociatedObject(self, &clipKey) boolValue];
}

- (void)setClip:(BOOL)clip {
    objc_setAssociatedObject(self, &clipKey, @(clip), OBJC_ASSOCIATION_ASSIGN);
}


- (void)showPhotoPickerWithClip:(BOOL)clip{
    self.clip = clip;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark --UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self pickImageFromCamera];
        
    }else if (buttonIndex == 1){
        
        [self pickImageFromPhotoLibrary];
    }
}

- (void)pickImageFromPhotoLibrary
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //Todo 完善
    BOOL isCropper = self.clip; //是否裁剪
    if (isCropper) {
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        //imagePicker.showsCameraControls =NO;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)pickImageFromCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    //Todo 完善
    BOOL isCropper = self.clip; //是否裁剪
    if (isCropper) {
        //imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
    }

    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];

    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //
    BOOL isCropper = self.clip; //是否裁剪
    if (isCropper && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }
    
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self didPickPhoto:image];
    }else if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self didPickPhoto:image];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  使用的类必须覆盖此方法
 *
 *  @param image 获取修改后的图片
 */
-(void)didPickPhoto:(UIImage*)image{

}

/**
 *  从相机获取图片后的东西，使用的类必须覆盖此方法
 *
 *  @param image 获取并修改后的图片
 */
//-(void)didPickPhotoFromCamera:(UIImage*)image{
//
//}

/**
 *  从相册获取图片后的东西，使用的类必须覆盖此方法
 *
 *  @param image 获取并修改后的图片
 */
//-(void)didPickPhotoFromAlbum:(UIImage*)image{
//
//}

/**
 *保存图片，返回成功与失败
 */
- (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    return [imageData writeToFile:fullPathToFile atomically:NO];
}


- (NSString *)getImagePathWithName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,                                                                          NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:imageName];
}

-(NSString *)base64StringFromImage:(UIImage *)tempImage
{
    NSData *data;
    //图片是否png格式
//    if(UIImagePNGRepresentation(tempImage)){
//        data = UIImagePNGRepresentation(tempImage);
//    }else {
//        data = UIImageJPEGRepresentation(tempImage, 1.0);
//    }
    data = UIImageJPEGRepresentation(tempImage, 1.0);
    if ((float)data.length/1024 > 800) {
//        data = UIImageJPEGRepresentation(tempImage, 1024*1000.0/(float)data.length);
        data = UIImageJPEGRepresentation(tempImage, 1024*500.0/(float)data.length);
        //data = UIImageJPEGRepresentation(tempImage, 0.8);
    }
    
    return [MF_Base64Codec base64StringFromData:data];
}



@end
