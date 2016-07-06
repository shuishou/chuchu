//
//  QCPicScrollView.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCPicScrollView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "QCPicV.h"
#import "RecordAudio.h"

//设置图片最多
#define kPictureMaxCount 30
//  都显示成3列
#define kMaxCol 1.5
#define kPicW ([UIScreen mainScreen].bounds.size.width - 10*2 - 8*4)/1.5  //图片宽度
#define kPicH 160 //图片高度
#define kPicMagin 8  // 图片之间的间距
@implementation QCPicScrollView

-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
           if (self) {
            
            
            //分页显示
            self.pagingEnabled=NO;
               
            self.userInteractionEnabled=YES;
            self.scrollEnabled=YES;
    
            //滑动到第一页和最后一页是否允许继续滑动
            
            self.bounces=YES;
    
            //取消滚动条
            
            self.showsHorizontalScrollIndicator=NO;//水平(横)
            
            self.showsVerticalScrollIndicator=YES;//垂直(竖)
            
            //指定代理人
            self.delegate=self;
            
            
            
            //偏移量一开始显示到第几张
            self.contentOffset=CGPointMake(self.bounds.size.width*0, self.bounds.size.height*0);
            
    
    
        for (NSInteger i = 0; i < kPictureMaxCount ; i++) {

            QCPicV *pictureView =[[QCPicV alloc]init];
            pictureView.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
            [pictureView addGestureRecognizer:tap];
            
            pictureView.tag = i;
            
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
            [longPressGestureRecognizer addTarget:self action:@selector(longTouchItem:)];
            [longPressGestureRecognizer setMinimumPressDuration:1];
            [longPressGestureRecognizer setAllowableMovement:50.0];
            [pictureView addGestureRecognizer:longPressGestureRecognizer];

            
            [self addSubview:pictureView];
        }
               
    }
    return self;
}

#pragma mark - 集成图片浏览器
-(void)imgClick:(UITapGestureRecognizer*)recognizer{
    QCGetUserMarkModel *igemodel = self.dynamicImgPaths[recognizer.view.tag];
    NSLog(@"igemodelDict ====== %@",[igemodel mj_keyValues]);
    if (isDelete) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"delete" object:nil userInfo:@{@"model":igemodel}];
        isDelete=NO;
    }else{
        if (igemodel.type == 2) {
            //如果是图片
            MJPhotoBrowser *brower = [[MJPhotoBrowser alloc]init];
            NSMutableArray *mjPhotos = [NSMutableArray array];
            NSMutableArray *mjDescriptions = [NSMutableArray array];
            NSInteger imgCount = self.dynamicImgPaths.count;
            for (NSInteger i = 0; i< imgCount; i++) {
                QCGetUserMarkModel *model = self.dynamicImgPaths[i];
                NSLog(@"modelDict=====%@",[model mj_keyValues]);
                if (model.url != nil) {
                    MJPhoto *mjPhoto =[[MJPhoto alloc]init];
                    mjPhoto.url = [NSURL URLWithString:model.url];
                    QCPicV *pic=self.subviews[i];
                    if (pic.model.type != 3 &&pic.model.type != 4) {
                        mjPhoto.srcImageView = pic.bgIge;
                        [mjPhotos addObject:mjPhoto];
                    }
                    [mjDescriptions addObject:model.title];
                }
            }
            
            brower.descriptions = mjDescriptions;
            brower.photos = mjPhotos;
            brower.currentPhotoIndex = (int)recognizer.view.tag;
            [brower show];
        }else if (igemodel.type == 5){
            //如果是添加按钮
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpush" object:nil userInfo:@{@"groupId":@(igemodel.groupId)}];
        }else if(igemodel.type == 3){
            //如果是视频
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpushToVoide" object:nil userInfo:@{@"data":igemodel}];
            
        }else if(igemodel.type == 4){
           [self fileDownlowdUseAFN:igemodel.url];
        }
    }
}

#pragma mark - 播放录音

-(void)fileDownlowdUseAFN:(NSString*)voiceurl
{
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionMan = [[AFURLSessionManager alloc] initWithSessionConfiguration:cfg];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:voiceurl]];
    
    NSURLSessionDownloadTask *dowloadTask = [sessionMan downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 2.文件保存的路径
        NSString *fileName = [NSUUID UUID].UUIDString;
        NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        CZLog(@"%@",filePath);
        if (_avPlayer.playing) {
            [_avPlayer stop];
            return;
        }
        
        NSError *errorr = nil;
        NSData * data = [NSData dataWithContentsOfURL:filePath];
        NSLog(@"%zd",data.length);
         NSData *b = DecodeAMRToWAVE(data);
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:b  error:&errorr];
        if (errorr) {
            CZLog(@"%@",errorr);
        }
        //选加载音频的一部份数据到内存
        [player prepareToPlay];
        _avPlayer = player;
        [player play];
        if (error) {
            CZLog(@"%@",error);
            [OMGToast showText:@"网络异常"];
        }
    }];
    // 执行下载的任务
    [dowloadTask resume];
}


-(void)setDynamicImgPaths:(NSMutableArray *)dynamicImgPaths{
    _dynamicImgPaths = dynamicImgPaths;
    
    //设置可滚动范围
    self.contentSize=CGSizeMake( kPicW*(dynamicImgPaths.count*2)+(8*dynamicImgPaths.count)-([UIScreen mainScreen].bounds.size.width - 10*2),self.bounds.size.height );
    
    //    最大显示图片列数
//    NSInteger maxCol = kMaxCol;
    
    for (NSInteger i = 0; i < kPictureMaxCount; i++) {
        QCPicV *pictureView =self.subviews[i];
        if (i < dynamicImgPaths.count) {//有图片的显示
            pictureView.hidden = NO;
            //            计算子控件frame
            CGFloat pictureX =( kPicW+8)  * i;
            CGFloat pictureY = 8;
            pictureView.frame = CGRectMake(pictureX, pictureY, kPicW, kPicH);
            
            //            给子控件的属性赋值（传数据）
            QCGetUserMarkModel *model=dynamicImgPaths[i];
            pictureView.model = model;
            
        }else{//无图片的要隐藏起来
            pictureView.hidden = YES;
        }
    }
}

#pragma mark - 传入图片数，返回photoView的尺寸
+(CGSize)photoViewSizeWithPictureCount:(NSInteger)count{
    
    if (count==0) { //没图片
        return CGSizeMake(0, 0);
    }
    
    //    最大显示图片列数
    NSInteger maxCol = kMaxCol;
    //    最大显示图片行数
    NSInteger row = 1;
    CGFloat photoW = (kPicW + kPicMagin) * maxCol - kPicMagin;
    CGFloat photoH = (kPicH + kPicMagin) * row - kPicMagin;
    
    CGSize photoSize = CGSizeMake(photoW, photoH);
    
    return photoSize;
}

-(void)longTouchItem:(UILongPressGestureRecognizer*)longResture
{
    if (longResture.state==UIGestureRecognizerStateBegan) {
        isDelete=YES;
        for (NSInteger i = 0; i < kPictureMaxCount; i++) {
            QCPicV*pic = self.subviews[i];
            if (i < self.dynamicImgPaths.count) {//有图片的显示
                
                if (pic.model.type!=5) {
                    pic.deleteImage.hidden=NO;
                }
            }
        }
    }else if(longResture.state==UIGestureRecognizerStateEnded){
        
        
    }
}


@end
