//
//  QCViewController.m
//  MyQOOCOO
//
//  Created by Devin on 15/12/31.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "DevinVideoViewController.h"

#import <AVFoundation/AVFoundation.h>

#define SUIScreenW [UIScreen mainScreen].bounds.size.width

#define SUIScreenH [UIScreen mainScreen].bounds.size.height

#define VideoSaveKey @"USERRECENTRECORDVIDEO"
@interface DevinVideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,captureViewControllerDelegate>


@property (nonatomic,strong)UICollectionView * videoCollection;

@property (nonatomic,strong)NSMutableArray * videoArr;

@end

@implementation DevinVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSaveVideo];
    
    [self loadVideoCollection];
    // Do any additional setup after loading the view.
}

-(void)loadSaveVideo{
    
    NSData * data = [[NSUserDefaults standardUserDefaults] valueForKey:VideoSaveKey];
    
    if (data == nil) {
        
        _videoArr = [NSMutableArray new];
        
        data = [NSKeyedArchiver archivedDataWithRootObject:_videoArr];
        
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:VideoSaveKey];
        
        return;
        
    }
    
    _videoArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
}

-(void)loadVideoCollection{
    
    
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.minimumLineSpacing = 10;

    flowLayout.itemSize = CGSizeMake((SUIScreenW - 40)/3, (SUIScreenW - 40)/3);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _videoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SUIScreenW, SUIScreenH) collectionViewLayout:flowLayout];
    
    _videoCollection.dataSource = self;
    
    _videoCollection.delegate = self;
    
    _videoCollection.backgroundColor = [UIColor whiteColor];
    
    [_videoCollection registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"videoCell"];
    
    [self.view addSubview:_videoCollection];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * ID = @"videoCell";
    
    VideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.layer.masksToBounds = YES;
    
    cell.layer.cornerRadius = 10;
    
    cell.layer.borderColor = [UIColor orangeColor].CGColor;
    
    cell.layer.borderWidth = 1;
    
    if (indexPath.row == 0) {
        
        cell.layer.borderWidth = 0;
        cell.preImage.image = [UIImage imageNamed:@"组-18"];
        cell.videoSize.text = @"";
        cell.videoDuration.text = @"";
        
    }else{
        
        cell.preImage.image = [self getImage:_videoArr[indexPath.row - 1]];
        cell.videoDuration.text = [self getVideoDurationFromURL:_videoArr[indexPath.row - 1]];
        NSURL * path = _videoArr[indexPath.row - 1];
        cell.videoSize.text = [NSString stringWithFormat:@"%.2fM",[self fileSizeAtPath:[path absoluteString]]];
        
    }
    
    
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"%@",_videoArr);
    
    return _videoArr.count+1;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        CaptureViewController * c = [CaptureViewController new];
        
        c.delegate = self;
        
        [self presentViewController:c animated:YES completion:nil];
        
    }else{
        
        if (self.VideoSelectedBlock) {
            self.VideoSelectedBlock(_videoArr[indexPath.row - 1]);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

-(void)returnVideoURL:(NSURL *)url{
    
    [_videoArr addObject:url];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:_videoArr];
    
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:VideoSaveKey];
    
    [_videoCollection reloadData];
    
}


-(UIImage *)getImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getVideoDurationFromURL:(NSURL *)url{

NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                 forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];  // 初始化视频媒体文件
double minute = 0, second = 0;
second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
if (second >= 60) {
    int index = second / 60;
    minute = index;
    second = second - index*60;
}
    return [NSString stringWithFormat:@"%02.0f:%02.0f",minute,second];
    
}

- (float) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
    NSError * error;
        float size = [[manager attributesOfItemAtPath:filePath error:&error] fileSize];
    NSLog(@"%@",error);
        return size/1024/1024;
//    }
//    return 0.0;
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
