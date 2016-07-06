//
//  QCrecordView.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCrecordView.h"
#import "QCrecordV.h"
//设置最多
#define kPictureMaxCount 30
//  都显示成几列
#define kMaxCol 4
#define kPicW ([UIScreen mainScreen].bounds.size.width - 20*2 - 5*4)/4  //图片宽度
#define kPicH 90 //高度
#define kPicMagin 5  // 间距

@implementation QCrecordView




-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        for (NSInteger i = 0; i < kPictureMaxCount ; i++) {
            
          
            QCrecordV*recordV =[[QCrecordV alloc]init];
            
            recordV.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recordVClick:)];
            [recordV addGestureRecognizer:tap];
            recordV.tag = i;
            [self addSubview:recordV];
            
            
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
            [longPressGestureRecognizer addTarget:self action:@selector(longTouchItem:)];
            [longPressGestureRecognizer setMinimumPressDuration:1];
            [longPressGestureRecognizer setAllowableMovement:50.0];
            [recordV addGestureRecognizer:longPressGestureRecognizer];

            
        }
        
        
    }
    
    return self;
    
}
+(CGSize)recordViewSizeWithArrCount:(NSInteger)count
{
    
    
    if (count==0) { //没
        return CGSizeMake(0, 0);
    }
    
    //    最大显示列数
    NSInteger maxCol = kMaxCol;
    //    最大显示行数
    NSInteger row = count / maxCol;
    if (count % maxCol !=0) {
        row++;
    }
    CGFloat recordW = (kPicW + kPicMagin) * maxCol - kPicMagin;
    CGFloat recordH = (kPicH + kPicMagin) * row - kPicMagin;
    
    CGSize recordSize = CGSizeMake(recordW, recordH);
    
    return recordSize;
    
    
}


-(void)recordVClick:(UITapGestureRecognizer*)recognizer{
    
    NSLog(@"123");
    QCGetUserMarkModel*model=self.dataArr[recognizer.view.tag];
    if (isDelete) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"delete" object:nil userInfo:@{@"model":model}];
        isDelete=NO;
    }else{
        if (model.type==5) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpush" object:nil userInfo:@{@"groupId":@(model.groupId)}];
            
        }else{
            
            [self fileDownlowdUseAFN:model.url];
        }
    }
}

-(void)setDataArr:(NSMutableArray *)dataArr
{

    _dataArr = dataArr;
    
    //    最大显示图片列数
    NSInteger maxCol = kMaxCol;
    
    for (NSInteger i = 0; i < kPictureMaxCount; i++) {
        QCrecordV*recordV = self.subviews[i];
        
        if (i < dataArr.count) {//有图片的显示
            recordV.hidden = NO;
            //            计算真实存在的图片占用列数和行数
            CGFloat col = i % maxCol;
            CGFloat row = i / maxCol;
            //            计算子控件frame
            CGFloat pictureX = (kPicW + kPicMagin) * col;
            CGFloat pictureY = (kPicH + kPicMagin) * row;
            recordV.frame = CGRectMake(pictureX, pictureY, kPicW, kPicH);
            
            //            给子控件的属性赋值（传数据）
            recordV.recordmodel = dataArr[i];
        }else{//无图片的要隐藏起来
            recordV.hidden = YES;
        }
    }
    

}

#pragma -mark 播放录音

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
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data  error:&errorr];
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

-(void)longTouchItem:(UILongPressGestureRecognizer*)longResture
{
  
    
        if (longResture.state==UIGestureRecognizerStateBegan) {
            isDelete=YES;
            for (NSInteger i = 0; i < kPictureMaxCount; i++) {
                QCrecordV*recordV = self.subviews[i];
                
                if (i < self.dataArr.count) {//有图片的显示
                    if (recordV.recordmodel.type!=5) {
                        recordV.deleteImage.hidden=NO;
                    }
                }
            }
           
            
            
        }else if(longResture.state==UIGestureRecognizerStateEnded){
            
            
        }
        
}
    
    


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
