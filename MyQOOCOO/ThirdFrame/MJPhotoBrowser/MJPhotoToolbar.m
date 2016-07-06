//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"

@interface MJPhotoToolbar()
{
    AppDelegate * app;
    // 显示页码
    UILabel *_indexLabel;
    UILabel *_descriptionLabel;
    UIButton *_saveImageBtn;
}
@end

@implementation MJPhotoToolbar

@synthesize Delegate;
@synthesize DeleteImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;

    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = CGRectMake(0, 20, self.bounds.size.width, 30);
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    } else {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = CGRectMake(0, 20, self.bounds.size.width, 30);;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _indexLabel.text = @"1/1";
        [self addSubview:_indexLabel];
    }
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont boldSystemFontOfSize:16];
    _descriptionLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 20);
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = [UIColor whiteColor];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _descriptionLabel.text = @"";
    [self addSubview:_descriptionLabel];
}

-(void)deleteThisImage
{
    if ( [Delegate respondsToSelector:@selector(DeleteThisImage:)] ) {
        [Delegate DeleteThisImage:_currentPhotoIndex];
    }
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %d", _currentPhotoIndex + 1, _photos.count];
    
    if (self.descriptions.count >= currentPhotoIndex + 1) {
        _descriptionLabel.text = self.descriptions[currentPhotoIndex];
    }
    
    if (_photos.count >= _currentPhotoIndex + 1) {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        // 按钮
        _saveImageBtn.enabled = photo.image != nil && !photo.save;
    }
}

@end
