//
//  QCHFAddReplyVC.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/30.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFAddReplyVC.h"
#import "ALActionSheetView.h"
#import "MessagePhotoView.h"
#import "QCQinniuUploader.h"
@interface QCHFAddReplyVC ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITextView * HFTextView;
    NSString * replyText;
    UIImageView * addImage;
    NSString * imageurl;
}
@property ( nonatomic , assign) int count;
@property ( nonatomic , assign) float photosHeight;
@property (nonatomic , strong) MessagePhotoView *photosView ;//图片布局
@end

@implementation QCHFAddReplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(initAddReplyData:)];
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    [self initView];
    
    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards:)];
    [self.view addGestureRecognizer:taps];
}

- (void)dismissKeyboards:(UITapGestureRecognizer *)taps
{
    [self.view endEditing:YES];
}

- (void)initView
{
    UIView * addView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, WIDTH(self.view), HEIGHT(self.view)-16)];
    addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addView];
    
    HFTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, WIDTH(addView)-16, HEIGHT(addView)/7+10)];
    HFTextView.delegate = self;
    HFTextView.font = [UIFont systemFontOfSize:HEIGHT(HFTextView)/6];
    HFTextView.textColor = [UIColor colorWithHexString:@"333333"];
//    HFTextView.layer.borderColor = [UIColor blackColor].CGColor;
//    HFTextView.layer.borderWidth = 1;
    HFTextView.selectedRange=NSMakeRange(HFTextView.text.length,0);
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    UILabel * placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH(HFTextView)-10, HEIGHT(HFTextView)/6)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont systemFontOfSize:HEIGHT(placeHolderLabel)];
    placeHolderLabel.textColor = [UIColor colorWithHexString:@"999999"];
    placeHolderLabel.backgroundColor = [UIColor whiteColor];
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"填写快捷回复内容";
    [HFTextView addSubview:placeHolderLabel];
    if ([[HFTextView text] length] == 0) {
        [[HFTextView viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[HFTextView viewWithTag:999] setAlpha:0];
    }
    [addView addSubview:HFTextView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(X(HFTextView), MaxY(HFTextView),WIDTH(addView)/10*2 , WIDTH(addView)/10)];
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/5];
    label.textColor = [UIColor colorWithRed:140.0/255 green:140.0/255 blue:140.0/255 alpha:1];
    label.text = @"图片(可选)";
    [addView addSubview:label];
    
    addImage = [[UIImageView alloc] initWithFrame:CGRectMake(X(HFTextView), MaxY(label), WIDTH(label), WIDTH(label))];
    [addImage setImage:[UIImage imageNamed:@"but_addimg"]];
    addImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)];
    [addImage addGestureRecognizer:tap];
    
    [addView addSubview:addImage];
    
}

//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[HFTextView text] length] == 0) {
        [[HFTextView viewWithTag:999] setAlpha:1];
    }
    else {
        [[HFTextView viewWithTag:999] setAlpha:0];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length > 0) {
        
        if (textView.text.length <= 50) {
            replyText = textView.text;
        }
    }
    
}

//如果输入超过规定的字数50，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=50)
    {
        [OMGToast showText:@"文本信息不能超过50个字"];
        return  NO;
    }
    else
    {
        return YES;
    }
}

#pragma -mark 添加图片
- (void)addImage:(UITapGestureRecognizer *)tap
{
    UIAlertController *alert = [[UIAlertController alloc] init];
    //    self.alert = alert;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = tap.view;
    }
    
    __weak QCHFAddReplyVC * addRe = self;
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        CZLog(@"点击取消");
    }];
    
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CZLog(@"点击拍照");
        [addRe localCamera];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CZLog(@"点击相册");
        [addRe localPhoto];
        
    }];

    [alert addAction:cancelAction];
    [alert addAction:archiveAction];
    [alert addAction:deleteAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//打开本地相册
- (void)localPhoto{
    
    UIImagePickerController *HFPicke = [[UIImagePickerController alloc]init];
    HFPicke.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    HFPicke.delegate = self;
    HFPicke.allowsEditing = YES;
    HFPicke.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:HFPicke animated:YES completion:nil];
}

//打开相机
- (void)localCamera
{
    UIImagePickerController * HFimagePicker = [[UIImagePickerController alloc] init];
    HFimagePicker.delegate = self;
    HFimagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    HFimagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    HFimagePicker.allowsEditing = YES;
    [self presentViewController:HFimagePicker animated:YES completion:nil];
}

//当选择一张图片后执行这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
    
#pragma -mark 相册模式
    if ([type isEqualToString:(NSString*)kUTTypeImage] && picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary)
    {
        
        UIImageView * imageView = [UIImageView new] ;
        
        //获取照片的原图
        imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [MBProgressHUD showMessage:nil background:NO];
        [QCQinniuUploader uploadImage:imageView.image progress:nil success:^(NSString *url) {
            
            imageurl = url;
            CZLog(@"===%@",imageurl);
            addImage.image = nil;
            addImage.image = imageView.image;
            
            [MBProgressHUD hideHUD];
            //    关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^{
            
        }];
        
    }
#pragma -mark 相机模式
    else if ([type isEqualToString:(NSString*)kUTTypeImage] && picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        UIImageView * imageView = [UIImageView new] ;
        
        //获取照片的原图
        imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];

        [MBProgressHUD showMessage:nil background:NO];
        [QCQinniuUploader uploadImage:imageView.image progress:nil success:^(NSString *url) {
            
            imageurl = url;
            CZLog(@"===%@",imageurl);
            addImage.image = nil;
            addImage.image = imageView.image;
            
            [MBProgressHUD hideHUD];
            //    关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^{
            
        }];
        
    }
    
}


#pragma -mark 添加快捷回复
- (void)initAddReplyData:(UIBarButtonItem *)bar
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (replyText.length > 0) {
        dic[@"content"] = replyText;
    }
    else
    {
        [OMGToast showText:@"请填写标题"];
        return;
    }
    
    if (imageurl.length > 0) {
        dic[@"url"] = imageurl;
    }
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:ADDREPLY parameter:dic success:^(id response) {
        CZLog(@"%@", response)
        
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideHUD];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
