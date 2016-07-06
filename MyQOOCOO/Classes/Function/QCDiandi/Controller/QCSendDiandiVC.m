//
//  QCSendDiandiVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/2.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSendDiandiVC.h"
#import "QCTextView.h"
#import "QCWhoCanSeeVC.h"
#import "MessagePhotoView.h"
#import "QCQiniuTocken.h"
#import "QCQinniuUploader.h"
#import "LocationViewController.h"
#import "DevinVideoViewController.h"
#import "QCMoviePlayerViewController.h"

#define kMessagePhotoViewAddBtnClickNotification @"MessagePhotoViewAddBtnClickNotification"
#define kDianDiSeleteUserUidNotification @"DianDiSeleteUserUidNotification"

@interface QCSendDiandiVC ()<UITableViewDataSource,UITableViewDelegate,MessagePhotoViewDelegate,LocationViewDelegate,QCWhoCanSeeVCDelegate>
{
    QCTextView *_textView;
    QCBaseTableView *_tableView;
    UIView *_headerView;
    UIImageView * _videoV;
    UILabel * sizeLabel;
    UILabel * timeLabel;
    NSInteger isOK;
    NSInteger isOK2;
}
@property (nonatomic,assign) int count;
@property (nonatomic,assign) float photosHeight;
@property (nonatomic,strong) MessagePhotoView *photosView ;//图片布局
@property (nonatomic,strong)NSMutableArray *photosArray;//相册图片数组
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSMutableArray*currentIndexArr;//多选数组
@property (nonatomic,strong) NSMutableArray*currenttype;//类型数组
@property (nonatomic,copy) NSString *qiniuToken;

@property (nonatomic,assign) double latitude;//经度
@property (nonatomic,assign) double longitude;//纬度
@property (nonatomic,copy) NSString * address;//地址

@property (nonatomic,copy) NSURL *videoUrl;//本地视频URL
@property (nonatomic,strong) UIView * videoBgV;

@property (nonatomic,assign) NSInteger index;//用去区分 给谁看

@property (nonatomic,copy) NSString * uidStr;

@end

@implementation QCSendDiandiVC

-(NSMutableArray *)photosArray{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc]init];
    }
    return _photosArray;
}


#pragma mark - 录视频
-(UIView *)videoBgV{
    if (!_videoBgV) {
        _videoBgV = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_W, 200)];
        _videoBgV.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40, 50, 107, 107);
        [btn setImage:[UIImage imageNamed:@"but_addimg"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addButtenClick) forControlEvents:UIControlEventTouchUpInside];
        [_videoBgV addSubview:btn];
        
        _videoV  = [[UIImageView alloc]init];
        _videoV .frame = CGRectMake(167, 40, 127, 127);
        _videoV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
        [ _videoV addGestureRecognizer:tap];
        [_videoBgV addSubview:_videoV ];
        
//        sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 127-20-5, 40, 20)];
//        sizeLabel.font = [UIFont systemFontOfSize:10];
//        sizeLabel.textColor = [UIColor whiteColor];
//        [_videoV addSubview:sizeLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(127-40-5, 127-20-5, 40, 20)];
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textAlignment = UITextAlignmentRight;
        timeLabel.textColor = [UIColor whiteColor];
        [_videoV addSubview:timeLabel];
    }
    return _videoBgV;
}

// 视频的加号按钮
-(void)addButtenClick{
    DevinVideoViewController * d = [[DevinVideoViewController alloc]init];
    [d setVideoSelectedBlock:^(NSURL * videoUrl) {//回调返回本地视频的本地URL
//        CZLog(@"%@",videoUrl);
        self.videoUrl = videoUrl;
        _videoV.image=[self getImage:videoUrl];
        timeLabel.text = [self getVideoDurationFromURL:videoUrl];
//        sizeLabel.text = [NSString stringWithFormat:@"%02.2fM",[self fileSizeAtPath:videoUrl]];
    }];
    [self.navigationController pushViewController:d animated:YES];
}

-(void)playVideo{
    
    if (self.videoUrl && [[self.videoUrl absoluteString] length] > 0) {
        //   1、 创建视频播放器
        QCMoviePlayerViewController *movieVc = [[QCMoviePlayerViewController alloc] init];
        movieVc.videoURL = self.videoUrl;
        //   2、 以模态方式弹出视频view
        [self presentViewController:movieVc animated:YES completion:nil];
    }
    
}

//获取视频的截图
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

//获取视频长度
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
////获取视频大小
//- (float) fileSizeAtPath:(NSURL*) filePath{
//    
//      NSString *str=[[filePath absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSFileManager* manager = [NSFileManager defaultManager];
//    //    if ([manager fileExistsAtPath:filePath]){
//    NSError * error;
//    float size = [[manager attributesOfItemAtPath:str error:&error] fileSize];
//    NSLog(@"%@",error);
//    return size/1024/1024;
//    //    }
//    //    return 0.0;
//}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 1;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"完成" target:self action:@selector(sendDiandi)];
    self.currentIndex = 0;//默认选择外圈
    self.currentIndexArr=[[NSMutableArray alloc]initWithObjects:@(1),@(0),@(0), nil];
    self.currenttype=[[NSMutableArray alloc]init];
    
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.data = [[NSMutableArray alloc]initWithArray:@[@[@"地点",@"谁可以看"],@[@"外圈",@"内圈",@"日记"]]];
    [self.view addSubview:_tableView];
    
    //初始化子控件
    [self setupTextView];
    if (!self.isVideo) {
      [self setupPhotosView];
    }
    
    //headView
    _tableView.tableHeaderView = [self setupHeaderView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addBtnClick) name:kMessagePhotoViewAddBtnClickNotification object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seleteUserUid:) name:kDianDiSeleteUserUidNotification object:nil];
    

}


-(void)seleteUserUid:(NSNotification*)n{
    NSMutableArray * uidArr = n.userInfo[@"uidArr"];
    //把数组转换成字符串
   self.uidStr =[uidArr componentsJoinedByString:@","];
//    CZLog(@"%@",self.uidStr);
    
}


-(void)addBtnClick{
    [_textView resignFirstResponder];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)sendDiandi{
    [_textView resignFirstResponder];
    if (_textView.text.length <1) {
        [OMGToast showText:@"请输入内容"];
        return;
    }else if (_textView.text.length >5000){
        [OMGToast showText:@"最大内容为5000字"];
        return;

    }
    
    
   
    for (int i; i<self.currentIndexArr.count; i++) {
        

        
        if ([self.currentIndexArr[i] isEqual:@(1)]) {
            isOK=isOK+1;
            [self.currenttype addObject:@(i+1)];
        }
    }
    
            if (isOK==0) {
               [OMGToast showText:@"请勾选同步类型"];
            
            return;
            }
        
    if (self.isVideo) {//发短视频
        [self sendVideoContent];
    }else{// 发送图片帖子
        [self sendIamgeContent];
    }


}


#pragma mark - 发表视频帖子
-(void)sendVideoContent{
    NSString *str=[[self.videoUrl absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (str.length>0) { //发送带视频的点滴
        [self popupLoadingView:@"正在发送..."];

//        1、上传视频的缩略图到七牛
         [QCQinniuUploader uploadImage:_videoV.image progress:nil success:^(NSString *url) {
          
             [self uploadVideoToQiniu:url];
             
         } failure:^{
             [OMGToast showText:@"发布失败"];
              [self hideLoadingView];
         }];
        
    }else{
        //  发表无图片无视频的文本帖子
        [self sendText];
    }
}

  //     2、上传视频到七牛
-(void)uploadVideoToQiniu:(NSString*)imgUtl{
  
    [QCQinniuUploader uploadVideo:self.videoUrl progress:nil
                          success:^(NSString *url) {
                              
     [self sendVideoToCompany:imgUtl videoUrl:url];
                              
        } failure:^{
      [OMGToast showText:@"发布失败"];
      [self hideLoadingView];
  }];

}

//    3、发表视频帖子到服务器
-(void)sendVideoToCompany:(NSString*)imgUtl videoUrl:(NSString *)videoUrl{
    
    NSString * url = [NSString stringWithFormat:@"%@,%@",imgUtl,videoUrl];
    
    //           CZLog(@"%@",url);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"permission"] = @(self.index);// Y  Int	权限1-所有人 2-仅自己 3-选择性可见
    params[@"content"] = _textView.text;//内容
    params[@"type"] = @1;// 类型，1，普通，2来自日省
    params[@"ranges"] = [self.currenttype componentsJoinedByString:@","];//1、外圈，2、内圈，3、日记
    params[@"contentType"] = @2;//内容类型：视频
    params[@"coverUrl"] = url;// 第一个
    if (self.address) {
        params[@"locLat"] = @(self.latitude);// 经度
        params[@"locLng"] = @(self.longitude);//纬度
        params[@"address"] = self.address;// 地址
    }
    
    if (self.uidStr.length>0) {
        params[@"defineUids"] = self.uidStr;// UID
    }
    
    [NetworkManager requestWithURL:RECORD_CREATE_URL parameter:params success:^(id response) {
        [self hideLoadingView];
        
      
            
        
        
        [OMGToast showText:@"发布成功"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self hideLoadingView];
        [OMGToast showText:@"发布失败"];
    }];
    

}



//title  	N	string	标题
//coverUrl	N	string	图片url
//locLat	N	double	经度
//locLng	N	double	纬度
//locGeo	N	string	Geo
//address	N	String	地址
//permission	Y	Int	权限1-所有人   2-仅自己   3-选择性可见
//contentType	Y	int	内容类型
//content	    Y   string	内容
//defineUids	N	String	被限制的uid集合，以“，”分隔
//type	        Y	Int	类型，1，普通，2来自日省
//ranges	    Y	int	1、外圈，2、内圈，3、日记
#pragma mark - 发表带图片的帖子
-(void)sendIamgeContent{
    if (_photosArray.count>0) { //发送带图片的点滴
        [self popupLoadingView:@"正在发送..."];
        [QCQinniuUploader uploadImages:self.photosArray progress:nil success:^(NSArray *urlArray) {
            NSString * str = [urlArray componentsJoinedByString:@","];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"permission"] = @(self.index);// Y	Int	权限1-所有人  2-仅自己 3-选择性可见
            params[@"content"] = _textView.text;//内容
            params[@"type"] = @1;// 类型，1，普通，2来自日省
            params[@"ranges"] = [self.currenttype componentsJoinedByString:@","];// 	1、外圈，2、内圈，3、日记
            params[@"contentType"] = @1;//内容类型：视频为2，其他都为1
            params[@"coverUrl"] = str;// 图片URL
            if (self.address) {
                params[@"locLat"] = @(self.latitude);// 经度
                params[@"locLng"] = @(self.longitude);//纬度
                params[@"address"] = self.address;// 地址
            }
            
            if (self.uidStr.length>0) {
                params[@"defineUids"] = self.uidStr;// UID
            }
            [NetworkManager requestWithURL:RECORD_CREATE_URL parameter:params success:^(id response) {
                [self hideLoadingView];
                
                
                
                [OMGToast showText:@"发布成功"];
                [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1];
                
            } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
                [self hideLoadingView];
                [OMGToast showText:@"发布失败"];
            }];
            
        } failure:^{
            [OMGToast showText:@"图片上传失败"];
            [self hideLoadingView];
        }];
    }else{
        //    发表无图片无视频的文本帖子
        [self sendText];
    }
}

#pragma mark - 发表无图片无视频的文本帖子
-(void)sendText{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"permission"] = @(self.index);// Y	Int	权限1-所有人   2-仅自己 3-选择性可见
        param[@"content"] = _textView.text;//内容
        param[@"type"] = @1;// 类型，1，普通，2来自日省
        param[@"ranges"] = [self.currenttype componentsJoinedByString:@","];// 	1、外圈，2、内圈，3、日记
        param[@"contentType"] = @1;//内容类型：纯文字
        if (self.address) {
            param[@"locLat"] = @(self.latitude);// 经度
            param[@"locLng"] = @(self.longitude);//纬度
            param[@"address"] = self.address;// 地址
        }
    
       if (self.uidStr.length>0) {
          param[@"defineUids"] = self.uidStr;// UID
       }
    CZLog(@"%@",param);
    
        [self popupLoadingView:@"正在发送..."];
        [NetworkManager requestWithURL:RECORD_CREATE_URL parameter:param success:^(id response) {
            [self hideLoadingView];
            [OMGToast showText:@"发送成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            [self hideLoadingView];
        }];
}


#pragma mark - headerview
-(UIView *)setupHeaderView{
    _headerView = [[UIView alloc]init];
    [_headerView addSubview:_textView];
    if (self.isVideo) {//视频
        [_headerView addSubview:self.videoBgV];
        _headerView.frame = CGRectMake(0, 0, SCREEN_W, _textView.height + _videoBgV.height);
    }else{//图片
       [_headerView addSubview:_photosView];
        _headerView.frame = CGRectMake(0, 0, SCREEN_W, _textView.height + _photosView.height);
    }
    return _headerView;
}

#pragma mark - textViewAndPhotosView
-(void)setupTextView{
    _textView = [[QCTextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 150)];
    _textView.placeHolder = @"写点滴";
    _textView.placeHolderColor = [UIColor grayColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.alwaysBounceVertical = YES;
    [self setupForDismissKeyboard];//键盘消失事件
}
-(void)setupPhotosView{
    _photosView = [[MessagePhotoView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_W, 200)];
    _photosView.delegate = self;
    [self.view addSubview:_photosView];
    
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        NSArray *array = [_tableView.data objectAtIndex:1];
        return array.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W - 10, 30)];
    label.textColor = UIColorFromRGB(0x666666);
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    if (section == 1) {
        label.text = @"同步到";
    }
    [customView addSubview:label];
    return customView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0 ) {//地图定位
                LocationViewController* locationVC = [[LocationViewController alloc]init];
                locationVC.delegate = self;
                
                [self.navigationController pushViewController:locationVC animated:YES];
                
            }
            if (indexPath.row == 1) {//看贴的权限
                QCWhoCanSeeVC *whoCanSeeVC = [[QCWhoCanSeeVC alloc]init];
                whoCanSeeVC.delegate = self;
                
                
                [self.navigationController pushViewController:whoCanSeeVC animated:YES];
            }
            break;
            
        case 1:
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath ];
            if (newCell.accessoryType == UITableViewCellAccessoryNone) {
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                newCell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            
            _currentIndex = indexPath.row;
            
            if ([self.currentIndexArr[_currentIndex]isEqual:@(0)]) {
                self.currentIndexArr[_currentIndex]=@(1);
            }else{
                self.currentIndexArr[_currentIndex]=@(0);
                
            }
            
        }
            break;
        default:
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [[_tableView.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    _count ++;
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0) {
           cell.detailTextLabel.text = self.address;
        }else{
            if (self.index==1) {
              cell.detailTextLabel.text =@"所有人";
            }else if (self.index==2){
              cell.detailTextLabel.text =@"仅自己";
            }else if (self.index==3){
              cell.detailTextLabel.text =@"不给谁看";
            }
        }
    }
    if (indexPath.section == 1) {
        cell.tintColor = kGlobalTitleColor;
    }
    return cell;
}

-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
            
            if ([self.currentIndexArr[indexPath.row] isEqual:@(1)]) {
                            return UITableViewCellAccessoryCheckmark;
                        }else{
                            return UITableViewCellAccessoryNone;
                        }
        
        
        
    }
    return UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark - 图片处理
-(void)addUIImagePicker:(UIImagePickerController *)picker{
    [self presentViewController:picker animated:YES completion:^{
    }];
}
-(void)addPicker:(UIImagePickerController *)picker{
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)addTakePhoto:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)getChooseImageArray:(NSArray *)imgsArray{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i = 0; i<imgsArray.count; i++) {
        UIImage *tempImg;
        if ([imgsArray[i] isKindOfClass:[ALAsset class]]) {
            ALAsset * asset=imgsArray[i];
            tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        }else{
            tempImg=imgsArray[i];
        }
        [array addObject:tempImg];
    }
    _photosArray = array; //接受到的图片数组
    CZLog(@"%@",_photosArray);
    UILabel * label = [[UILabel alloc]init]; //(UILabel *)[_barView viewWithTag:10010];
    if ([label isKindOfClass:[UILabel class]]) {
        if (imgsArray.count>0) {
            label.text = [NSString stringWithFormat:@"%lu",(unsigned long)imgsArray.count];
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }
    }
}


#pragma mark - 地图定位后返回地址 LocationViewDelegate
-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address{
//    CZLog(@"%lf,%lf,%@",latitude,longitude,address);
    self.latitude = latitude;
    self.longitude = longitude;
    self.address = address;
    
    [_tableView reloadData];
}

#pragma mark - 看帖权限 QCWhoCanSeeVCDelegate
-(void)whoCanSeeWhitTypeIndex:(NSInteger)index{
    
    self.index = index;
    [_tableView reloadData];
}


@end
