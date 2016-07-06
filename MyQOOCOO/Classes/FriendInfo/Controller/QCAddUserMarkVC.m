//
//  QCAddUserMarkVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCAddUserMarkVC.h"
#import "QCCommonTableView.h"
#import "QCSeniorTableView.h"
#import "DevinVideoViewController.h"
#import "User.h"
#import "QCTapeViewController.h"

#import "QCQinniuUploader.h"
#import "RecordAudio.h"
@interface QCAddUserMarkVC ()
{

    UIView*bottomv;
    UITableView* bottomTb;
    
    UITextField *textV;
    
     UIScrollView*scrollBaV;
    
    
    QCCommonTableView *commonTable;
    QCSeniorTableView *seniorTable;
    
    
    UISegmentedControl*seg;
    
    UIActionSheet*Figures;
    
    
    UIView *bV;
    UIView *boxV;
    
    UITextField *boxtf;
    BOOL isHighFlag;
}

@end

@implementation QCAddUserMarkVC

-(void)changeValue:(UITextField *)field{
    NSLog(@"length >> %ld",field.text.length);
    if (field.text.length > 10) {
        field.text = [field.text substringToIndex:10];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加标签";
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationded:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveed:) name:UIKeyboardWillHideNotification object:nil];

    //点击推荐标签添加到已选择标签
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changArr:) name:@"changeText" object:nil];
    
    //已选择标签删除
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteText:) name:@"deleteText" object:nil];
    
    UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    rightBtn.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    codeArr = [NSMutableArray array];
    seniorArr = [NSMutableArray array];
    hotArr = [NSMutableArray array];
    commonArr = [NSMutableArray array];
    
    qiniuUrlArr=[NSMutableArray array];
    
    [codeArr addObject: hotArr];
    [codeArr addObject: commonArr];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTag) name:@"addTag" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVoiceUrl:) name:@"voiceUrl" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTag:) name:@"deleteTag" object:nil];

    scrollBaV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*2, self.view.frame.size.height)];
    [self.view addSubview: scrollBaV];
    //设置可滚动范围
    scrollBaV.contentSize=CGSizeMake(self.view.frame.size.width*3, 0);
    scrollBaV.backgroundColor=self.view.backgroundColor;
    
    self.automaticallyAdjustsScrollViewInsets =YES;
    //分页显示
    scrollBaV.pagingEnabled=YES;
    
    //滑动到第一页和最后一页是否允许继续滑动
    
    scrollBaV.bounces=NO;
    
    //取消滚动条
    scrollBaV.showsHorizontalScrollIndicator=NO;//水平(横)
    
    scrollBaV.showsVerticalScrollIndicator=NO;//垂直(竖)
    
    //指定代理人
    scrollBaV.delegate=self;
    
    scrollBaV.userInteractionEnabled=YES;
    
    //一开始显示到第几张
    scrollBaV.contentOffset=CGPointMake(0,0);
    
    UIView*topv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    topv.backgroundColor = RGBA_COLOR(248, 248, 248, 1);
    [self.view addSubview:topv];
        
    QCSeniorModel *mod = [[QCSeniorModel alloc]init];
    mod.type = 4;
    
    [seniorArr addObject:mod];
    
    [self commonTableViewinit];
    [self seniorTableViewinit];
    
    //创建一个分段控件
    //初始化需要一个数组 数组里面放每一段的标题
    NSArray *array=[NSArray arrayWithObjects:@"普通标签", @"高级标签",nil];
    seg = [[UISegmentedControl alloc] initWithItems:array];
    //大小位置
    seg.frame = CGRectMake((topv.bounds.size.width-160)/2, 10, 160, 30);
    //添加
    [topv addSubview:seg];
    
    //颜色
    seg.backgroundColor = [UIColor whiteColor];
    //内容颜色(文字)
    seg.tintColor = RGBA_COLOR(233, 77, 79, 1);
    //选中某一个
    seg.selectedSegmentIndex = 1;
    isHighFlag = 1;
    [scrollBaV setContentOffset:CGPointMake(self.view.frame.size.width*seg.selectedSegmentIndex, 0)animated:YES];
    
    //添加一个事件
    [seg addTarget:self action:@selector(clickWhichOne:) forControlEvents:UIControlEventValueChanged];

    bottomv=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-54-64, self.view.width, 54)];
    bottomv.backgroundColor=self.view.backgroundColor;
    [scrollBaV addSubview:bottomv];
    
    
    textV=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, bottomv.bounds.size.width-85, 44)];
    textV.font = [UIFont systemFontOfSize:18];
    textV.layer.borderColor = [UIColor colorWithHexString:@"efefef"].CGColor;
    textV.layer.borderWidth = 0.5;
    textV.backgroundColor = [UIColor whiteColor];
    textV.delegate = self;
    textV.layer.cornerRadius=5;
    textV.placeholder = @"输入标签内容10个字以内";
    [textV addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    [bottomv addSubview:textV];
    
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.frame = CGRectMake(bottomv.bounds.size.width-75, 5, 70, 44);
    [Btn setTitle:@"确定" forState: UIControlStateNormal];
    Btn.backgroundColor = RGBA_COLOR(233, 77, 79, 1);
    Btn.layer.cornerRadius = 5;
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(BtnCliack) forControlEvents:UIControlEventTouchUpInside];
    [bottomv addSubview:Btn];
    
    // Do any additional setup after loading the view.
}

-(void)changArr:(NSNotification *)notification{
    NSLog(@"commonTable.textArr===%@,commonTable.selectedArr===%@",commonTable.textArr,commonTable.selectedArr);
    NSString *addStr = commonTable.textArr[[notification.userInfo[@"index"] integerValue]];
    for (NSString *str in commonArr) {
        if ([str isEqualToString:addStr]) {
            [OMGToast showText:@"重复的标签不保存"];
            return ;
        }
    }
    [commonArr addObject:addStr];
    commonTable.selectedArr = [commonArr mutableCopy];
    [commonTable.textArr removeObjectAtIndex:[notification.userInfo[@"index"] integerValue]];
    [commonTable reloadData];
}

-(void)deleteText:(NSNotification *)notification{
    NSLog(@"commonTable.textArr===%@,commonTable.selectedArr===%@",commonTable.textArr,commonTable.selectedArr);
    [commonArr removeObjectAtIndex:[notification.userInfo[@"index"] integerValue]];
    commonTable.selectedArr = [commonArr mutableCopy];
    [commonTable reloadData];
}


-(void)commonTableViewinit
{
    NSDictionary *dict = @{@"groupType":@(self.groupType)};
    NSLog(@"dict===%@",dict);
    [NetworkManager requestWithURL:USERINFO_ReferrerMARKS parameter:dict success:^(id response) {
        CZLog(@"验证码发送成功response= %@",response);
        NSArray *tempArr = [NSMutableArray arrayWithArray:response];
        
        NSLog(@"tempArr====%@",tempArr);
        NSMutableArray *resultArr = [NSMutableArray array];
        for (NSDictionary *dict in tempArr) {
            NSString *title = dict[@"title"];
            [resultArr addObject:title];
        }
//        commonTable = [[QCCommonTableView alloc]initWithFrame:CGRectMake(0, 64, scrollBaV.bounds.size.width/2, scrollBaV.bounds.size.height-178)];
        commonTable.textArr = resultArr;
        [commonTable reloadData];
//        [scrollBaV addSubview:commonTable];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"验证码发送失败%@",error);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"验证失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新验证", nil];
        [alertView show];
    }];
}

-(void)seniorTableViewinit
{
    //commonTable
    commonTable = [[QCCommonTableView alloc]initWithFrame:CGRectMake(0, 64, scrollBaV.bounds.size.width/2, scrollBaV.bounds.size.height-178)];
    [scrollBaV addSubview:commonTable];
    
    seniorTable=[[QCSeniorTableView alloc]initWithFrame:CGRectMake(scrollBaV.bounds.size.width/2, 64, scrollBaV.bounds.size.width/2, scrollBaV.bounds.size.height-128)];
    seniorTable.dataArr = seniorArr;
    [scrollBaV addSubview:seniorTable];
}

-(void)BtnCliack
{
    NSLog(@"确定");
    [textV  resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        bottomv.frame = CGRectMake(0, HEIGHT(self.view)-54, self.view.width, 54);
    }];

    NSString *resultStr = [textV.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (resultStr.length != 0) {
        for (NSString *str in commonArr) {
            if ([str isEqualToString:resultStr]) {
                [OMGToast showText:@"重复的标签不保存"];
                return ;
            }
        }
        [commonArr insertObject:resultStr atIndex:0];
        commonTable.selectedArr = [commonArr mutableCopy];
        NSLog(@"textV.text===%@,commonArr===%@",resultStr,commonArr);
        [commonTable reloadData];
    }else{
        [OMGToast showWithText:@"不能发送空白标签" bottomOffset:100 duration:1];
    }
    textV.text=nil;
}

//分段控件点击的执行方法
-(void)clickWhichOne:(UISegmentedControl*)segC
{
    [textV  resignFirstResponder];
    [scrollBaV setContentOffset:CGPointMake(self.view.frame.size.width*segC.selectedSegmentIndex, 0)animated:YES];
    isHighFlag = segC.selectedSegmentIndex;
}

#pragma mark - 键盘弹出
//键盘将要弹出的方法
-(void)keyBoardWillShowNotificationded:(NSNotification *)not
{
    //获取键盘高度
    NSDictionary *dic = not.userInfo;
    //获取坐标
    CGRect rc = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    
    NSLog(@"isHighFlag===%d",isHighFlag);
    if (!isHighFlag)
    {
        //调整输入框的位置
        [UIView animateWithDuration:0.1 animations:^{
            bottomv.frame = CGRectMake(0, self.view.frame.size.height-f-54,self.view.width, 54);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            if (self.view.width > 320) {
                boxV.frame = CGRectMake(40, 120,self.view.width-80,200);
            }else{
                boxV.frame = CGRectMake(40, 40,self.view.width-80,200);
            }
        }];
    }
}

//键盘消失的方法
-(void)keyBoardRemoveed:(NSNotification *)not
{
    NSLog(@"isHighFlag===%d",isHighFlag);
    if ( !isHighFlag ) {
        //调整输入框的位置
        [UIView animateWithDuration:0.1 animations:^{
            bottomv.frame = CGRectMake(0, HEIGHT(self.view)-54, self.view.width, 54);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            boxV.frame = CGRectMake(40,(self.view.height-280)/2,self.view.width-80,200);
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

#pragma mark - UIScrollView的代理方法
// 一旦滚动就会执行
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

//其他代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽");
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"结束拖拽");
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"开始减速");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"减速结束");
    seg.selectedSegmentIndex=scrollView.contentOffset.x /self.view.frame.size.width;
}

#pragma mark - 选择拍照
-(void)takePhoto
{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - 选择相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    [self presentModalViewController:picker animated:YES];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString* filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        NSLog(@"%@",filePath);
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
       
        photoige=image;
        _boxTitle = @"添加照片描述";
        //        设置图片
        [self popBoxView];
        
    }
}

#pragma mark - 取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - 通知

-(void)addVoiceUrl:(NSNotification*)n
{
    [seniorArr insertObject:n.userInfo[@"Url"] atIndex:0];
    
    seniorTable.dataArr=seniorArr;
    [seniorTable reloadData];
}

-(void)addTag
{

    Figures = [[UIActionSheet alloc]
               initWithTitle:nil
               delegate:self
               cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
               otherButtonTitles:@"录视频",@"发语音",@"拍照",@"从相册选择",nil];
    
    [Figures showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == Figures.cancelButtonIndex)
    {
        NSLog(@"取消");
    }

    switch (buttonIndex) {
        case 0://视频
        {
            CaptureViewController * c = [CaptureViewController new];
            c.delegate = self;
            [self presentViewController:c animated:YES completion:nil];
        }
            break;
        case 1://语音
        {
            QCTapeViewController*tap=[QCTapeViewController new];
            [self.navigationController pushViewController:tap animated:YES];
        }
            break;
        case 2://拍照
            self.istype=YES;
            [self takePhoto];
            break;
        case 3://相册
            self.istype=YES;
            [self LocalPhoto];
            break;
        default:
            break;
    }
}

-(void)deleteTag:(NSNotification*)n
{
    NSInteger index=[n.userInfo[@"index"] integerValue];
    [seniorArr removeObjectAtIndex:index];
//    seniorArr=n.userInfo[@"index"];
    seniorTable.dataArr=seniorArr;
    [seniorTable reloadData];
}

- (void)starButtonClicked:(id)sender
{
    [self popupLoadingView:@"上传中"];
    
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(touchRightBtn) object:sender];
    [self performSelector:@selector(touchRightBtn) withObject:sender afterDelay:3.0f];
}

-(void)touchRightBtn
{
    NSLog(@"提交");

    switch (seg.selectedSegmentIndex) {
        case 0:
           //普通标签
            [self pushcommonMark];
            break;
        case 1:
            if (seniorArr.count>1) {
                for (int i=0; i<seniorArr.count-1; i++)
                {
                    if (i+1==seniorArr.count-1) {
                        QCSeniorModel *mod = seniorArr[i];
                        [self uploadToQiuniu:mod isOK:YES];
                    }else{
                         QCSeniorModel*mod=seniorArr[i];
                        [self uploadToQiuniu:mod isOK:NO];
                    }
                }
            }else{
                [OMGToast showText:@"请添加标签"];
            }
            break;
        default:
            break;
    }
}

#pragma mark - 获取七牛的tocken
-(void)uploadToQiuniu:(QCSeniorModel*)mod isOK:(BOOL)OK
{
    id data;
    if (mod.type==1) {
        data=mod.image;
        
        [QCQinniuUploader uploadImage:data progress:^(NSString *key, float percent) {
            //        CZLog(@"===key=%@",key);
        } success:^(NSString *url) {
            CZLog(@"===url=%@",url);//上传成功获取到七牛返回来的url
            [self pushseniorMark:mod  qiniuUrl:url isOK:OK];
           
        } failure:^{
            [OMGToast showText:@"上传图片失败"];
            [self hideLoadingView];
        }];
    }else if (mod.type==2){
        //音频缩略图
        data=mod.image;
        
        [QCQinniuUploader uploadImage:data progress:^(NSString *key, float percent) {
            //        CZLog(@"===key=%@",key);
        } success:^(NSString *url) {
            CZLog(@"===url=%@",url);//上传成功获取到七牛返回来的url
            
            mod.strUrl=url;
        
            id datas=mod.url;
            
            NSString *recordPath=mod.filePath;
            
            NSData * a =[NSData dataWithContentsOfFile:recordPath];
            NSData *data = EncodeWAVEToAMR(a,1,16);
            
            [[NSFileManager defaultManager]createFileAtPath:recordPath contents:data attributes:nil];
            
            NSURL * url2 = [NSURL fileURLWithPath:recordPath];
            
       
            //  1、先把音频上传到七牛服务器
            [QCQinniuUploader uploadVocieFile:url2 progress:nil success:^(NSString *url) {
                CZLog(@"%@",url);
                
                CZLog(@"===url=%@",url);//上传成功获取到七牛返回来的url
                
                [self pushseniorMark:mod  qiniuUrl:url isOK:OK];
                //    2、发送音频URL到服务器
            } failure:^{
                [self hideLoadingView];
                [OMGToast showText:@"上传音频失败"];
            }];
            
        } failure:^{
            [self hideLoadingView];
        }];
    }else if (mod.type==3){
            //视频缩略图
            data=mod.image;
        
            [QCQinniuUploader uploadImage:data progress:^(NSString *key, float percent) {
            //        CZLog(@"===key=%@",key);
        } success:^(NSString *url) {
            CZLog(@"===url=%@",url);//上传成功获取到七牛返回来的url
            
            mod.strUrl=url;
            //视频
            id datas=mod.url;
            
            [QCQinniuUploader uploadVideo:datas progress:^(NSString *key, float percent) {
                //        CZLog(@"===key=%@",key);
            } success:^(NSString *url) {
                CZLog(@"===url=%@",url);//上传成功获取到七牛返回来的url
                [self pushseniorMark:mod  qiniuUrl:url isOK:OK];
                
            } failure:^{
                 [OMGToast showText:@"上传视频失败"];
               [self hideLoadingView];
            }];
        } failure:^{
            [self hideLoadingView];
        }];
    }else if (mod.type==4){
        [self hideLoadingView];
        return;
    }
}

#pragma mark - 添加高级标签（根据类型多次请求）
-(void)pushseniorMark:(QCSeniorModel*)mod qiniuUrl:(NSString*)url isOK:(BOOL)OK
{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    dic[@"groupId"]=@(self.groupId);
    dic[@"title"]=mod.describeStr;
    
    
    if (mod.type==1) {
        dic[@"type"]=@(2);
    } else if(mod.type==2){
         dic[@"type"]=@(4);
    } else if(mod.type==3){
         dic[@"type"]=@(3);
    }
    

//    dic[@"type"]=@(mod.type);//1-文字  2-图片  3-视频  4-音频
    dic[@"url"]=url;
    dic[@"note"]=mod.describeStr;//多媒体标签描述？？？？
    dic[@"level"]=@(2);
    dic[@"destUid"]=@(sessions.user.uid);//添加人uid
    dic[@"uid"]=@(sessions.user.uid);//被添加人uid
    
    if (mod.type==1) {
        
    }else if(mod.type==2){
        dic[@"thumbnail"]=mod.strUrl;
        dic[@"durations"]=@([mod.str intValue]);//音频时长
    }else if(mod.type==3){
        dic[@"thumbnail"]=mod.strUrl;
        dic[@"durations"]=@([mod.str intValue]);//视频时长
    }
    
    

       [NetworkManager requestWithURL:USERINFO_ADDUSERMARK parameter:dic success:^(id response) {
        [self hideLoadingView];
        [OMGToast showText:@"发送成功"];
        if (OK==YES) {
        
        [self hideLoadingView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"commturn" object:nil userInfo:nil];

        [self.navigationController popViewControllerAnimated:YES];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [self hideLoadingView];
    }];
}

#pragma mark - 批量添加用户标签
-(void)pushcommonMark
{
    NSString* title;
    
    for (int i=0; i<commonArr.count; i++) {
        if (i==0) {
            title=commonArr[i];
        }else{
            title=[NSString stringWithFormat:@"%@,%@",title,commonArr[i]];
        }
    }
   
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"groupId"]=@(self.groupId);
    dic[@"title"]=title;
    dic[@"type"]=@(1);
    dic[@"level"]=@(1);
    dic[@"destUid"]=@(sessions.user.uid);
    dic[@"uid"]=@(sessions.user.uid);
    
    //[MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_ADDPACTHMARKS parameter:dic success:^(id response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"commturn" object:nil userInfo:nil];
        [self hideLoadingView];
        [OMGToast showText:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [self hideLoadingView];
//        [MBProgressHUD hideHUD];
    }];
}

-(void)inputChange:(UITextField *)field{
    if (field.text.length > 10) {
        field.text = [field.text substringToIndex:10];
    }
}

-(void)tapBack:(UITapGestureRecognizer *)gesture{
    [boxtf resignFirstResponder];
    [bV removeFromSuperview];
    [boxV removeFromSuperview];
}

-(void)popBoxView
{
    self.isADD=NO;
    
    bV = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    bV.backgroundColor=[UIColor blackColor];
    bV.alpha=0.5;
    [self.view addSubview:bV];
    bV.userInteractionEnabled = YES;
    [bV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
    
    
    boxV=[[UIView alloc]initWithFrame:CGRectMake(40,(self.view.height-200)/2,self.view.width-80,200)];
    boxV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boxV];
    
    
    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, boxV.bounds.size.width, 50)];
    lb.text=self.boxTitle;
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=[UIFont systemFontOfSize:18];
    [boxV addSubview:lb];
    
    boxtf=[[UITextField alloc]initWithFrame:CGRectMake(20, (boxV.bounds.size.height- 30)/2, boxV.bounds.size.width-40, 30)];
    boxtf.font=[UIFont systemFontOfSize:16];
    boxtf.delegate=self;
    [boxtf addTarget:self action:@selector(inputChange:) forControlEvents:UIControlEventEditingChanged];
    [boxtf becomeFirstResponder];
    [boxV addSubview:boxtf];
    
    UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn.frame=CGRectMake(0, boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
    [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
    [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    choiceBtn.tag = 1;
    choiceBtn.layer.borderColor = [UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn.layer.borderWidth = 0.5;
    [choiceBtn addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn];
    
    UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn2.frame = CGRectMake(boxV.frame.size.width/2,boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
    [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
    [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
    choiceBtn2.tag=2;
    choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn2.layer.borderWidth=0.5;
    [choiceBtn2 addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn2];
    
}


-(void)choiceBtnCliack:(UIButton*)bt
{
    if (bt.tag==1) {
        // 取消
        self.isADD=NO;
    }else{
        //确定
        for (QCSeniorModel *model in seniorArr) {
            if ([model.describeStr isEqualToString:boxtf.text]) {
                [OMGToast showText:@"存在相同标签"];
                return ;
            }
        }
        
        if (boxtf.text.length > 0) {
            if (self.istype == YES) {
                self.isADD = YES;
                self.describeStr = boxtf.text;
                self.mod = [[QCSeniorModel alloc]init];
                self.mod.image = photoige;
                self.mod.type=1;
                self.mod.describeStr = self.describeStr;
            }else{
                self.mod.describeStr=boxtf.text;
            }
            
            [seniorArr insertObject:self.mod atIndex:0];
            seniorTable.dataArr = seniorArr;
            
            [seniorTable reloadData];
        }else{
            [OMGToast showText:@"输入不能为空"];
            return ;
        }
    }
    [bV removeFromSuperview];
    [boxV removeFromSuperview];
    
}


- (void)returnVideoURL:(NSURL *)url
{

    self.istype=NO;
    [self popBoxView];
    self.mod=[[QCSeniorModel alloc]init];
    self.mod.image=[self getImage:url];
    self.mod.type=3;
    self.mod.url=url;
    self.mod.str=[self getVideoDurationFromURL:url];
    
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

-(NSString *)getVideoDurationFromURL:(NSURL *)url{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];  // 初始化视频媒体文件
    double minute = 0, second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
//    if (second >= 60) {
//        int index = second / 60;
//        minute = index;
//        second = second - index*60;
//    }
    return [NSString stringWithFormat:@"%.0f'",second];
    
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
