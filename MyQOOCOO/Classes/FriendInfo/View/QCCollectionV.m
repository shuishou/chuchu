//
//  QCCollectionV.m
//  MyQOOCOO
//
//  Created by lanou on 15/12/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCCollectionV.h"
#import "QC_LJCollectionViewCell.h"
#import "RecordAudio.h"

@implementation QCCollectionV


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataArr=[[NSMutableArray alloc]init];
        //注册cell UICollectionView的cell必须注册
        [self registerClass:[QC_LJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        //注册header
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
       
        self.scrollEnabled=NO;

        //设置代理
        self.delegate =self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        
    }
    return self;

}


#pragma -mark CV代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

//item什么样子

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    QC_LJCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }

    if (cell.type==5) {
        [cell.deleteIge removeFromSuperview];
    }
    
 
    
    QCGetUserMarkModel*data=self.dataArr[indexPath.row];
    cell.type=data.type;
    
    
    
    
    cell.titlelb.text=data.title;
    
    if (_isDelete==YES) {
        cell.deleteIge.hidden=NO;
    }else if(_isDelete==NO){
        cell.deleteIge.hidden=YES;
    }

    
    NSURL*url;

    switch (data.type) {
        case 1:
            //文字
           
            break;
        case 2:
            //图片
            url=[NSURL URLWithString:data.url];
             [cell.imagev sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_img"]];
            
       
            break;
        case 3:
            //视频
            url=[NSURL URLWithString:data.thumbnail];
             [cell.imagev sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_img"]];

            break;
        case 4:
            //录音
            break;
        case 5:
            //添加
            break;
            
        default:
            break;
    }
    
    
//    cell.imagev.image=nil;
//    [cell.imagev sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bg_img"]];
    cell.msLb.text=[NSString stringWithFormat:@"%d'",data.durations];
    
    

    if (indexPath.row!=self.dataArr.count -1) {
        
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [longPressGestureRecognizer addTarget:self action:@selector(longTouchItem:)];
        [longPressGestureRecognizer setMinimumPressDuration:2];
        [longPressGestureRecognizer setAllowableMovement:50.0];
        [cell addGestureRecognizer:longPressGestureRecognizer];
    }

    
    return cell;
}

//控制每个小方块的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.bounds.size.width/3-2, 170);
    
}

//点击的低级分区的第几个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isDelete!=YES) {
    
        QC_LJCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        NSLog(@"%ld",(long)indexPath.row);
        if (self.isAdd == YES && self.dataArr.count == indexPath.row+1) {
            
            QCGetUserMarkModel*data=self.dataArr[indexPath.row];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpush" object:nil userInfo:@{@"groupId":@(data.groupId)}];
        }else{
            QCGetUserMarkModel*data=self.dataArr[indexPath.row];
            switch (data.type) {
                case 1:
                    //文字
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpushToText" object:nil userInfo:@{@"data":data}];
                    break;
                case 2:
                    //图片
                {
                    MJPhotoBrowser * brower = [[MJPhotoBrowser alloc]init];
                    MJPhoto *mjPhoto =[[MJPhoto alloc]init];
                    
                    //     有高清大图切换的时候才需要
                    mjPhoto.url = [NSURL URLWithString:data.url];
                    mjPhoto.srcImageView = cell.imagev;
                    
                    brower.photos = [@[mjPhoto] mutableCopy];
                    [brower show];
                }
                    break;
                case 3:
                    //视频
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpushToVoide" object:nil userInfo:@{@"data":data}];
                    break;
                case 4:
                    [self fileDownlowdUseAFN:data.url];
                    //录音
                    break;
                case 5:
                    //添加
                    NSLog(@"121212");
                    break;
                    
                default:
                    break;
            }
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"delete" object:nil userInfo:@{@"index":@(indexPath.row),@"inSection":@(self.inSection)}];
        
        _isDelete=NO;
    }
    
}



-(void)longTouchItem:(UILongPressGestureRecognizer*)longResture
{
 if (self.isEdite!=YES) {
    
    if (longResture.state==UIGestureRecognizerStateBegan) {
        
        
        _isDelete=YES;
                    
        [self reloadData];
           
                 
    }else if(longResture.state==UIGestureRecognizerStateEnded){
        
        
    }
    
 }
    
}


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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
