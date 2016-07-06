//
//  QCSendLunkuVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/19.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSendLunkuVC.h"
#import "QCTextView.h"
#import "NetworkManager.h"
#import "QCQinniuUploader.h"
#import "MessagePhotoView.h"
#import "QCASTVCell.h"
#import "LJButtonView.h"
#define kMessagePhotoViewAddBtnClickNotification @"MessagePhotoViewAddBtnClickNotification"

@interface QCSendLunkuVC ()<MessagePhotoViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *_titleField;
    QCTextView *_contentView;
    MessagePhotoView *_photosView;
    UIView * markGroupView;
    UITableView * markTableV;

    LJButtonView*typeView1;
    LJButtonView*typeView2;
    LJButtonView*typeView3;
}

@property (nonatomic,strong)NSMutableArray *photosArray;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong)UIView *hideView;

@end

@implementation QCSendLunkuVC

-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

-(void)hideKeyboard{
    self.hideView.hidden = YES;
    [_titleField resignFirstResponder];
    [_contentView resignFirstResponder];
}

-(UIView *)hideView{
    if (_hideView == nil) {
        _hideView = [[UIView alloc] initWithFrame:self.view.bounds];
        _hideView.backgroundColor = [UIColor clearColor];
        _hideView.hidden = YES;
        _hideView.userInteractionEnabled = YES;
        [_hideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
        [self.view addSubview:_hideView];
    }
    return _hideView;
}

-(void)hideViewshow{
    [self.view bringSubviewToFront:self.hideView];
    self.hideView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (hideViewshow) name: UIKeyboardDidShowNotification object:nil];
    self.navigationItem.title = @"发帖";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"发布" target:self action:@selector(sendLunku:)];
    if (self.isFree) {
        self.titleArr = @[@"文案",@"创意",@"程序员",@"律师",@"会计",@"模特",@"合伙人",@"销售员",@"其他"];
    }else{
        self.titleArr =  @[@"我是民星",@"二次元",@"萌宠社",@"文学塘",@"去哪玩",@"协会商汇",@"热点筒",@"子女教育",@"创业圈",@"柴米油盐",@"前任现任"];//@[@"明星名人",@"动漫",@"游戏",@"文学艺术",@"体育",@"教育人文",@"娱乐",@"时尚生活",@"军事科学",@"数码科技",@"情感"];
    }
    
    [self setupForDismissKeyboard];//点击屏幕键盘退下
    [self setupContent];
    
    //
    self.funcType = 1;
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyboard) name:kMessagePhotoViewAddBtnClickNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillBeHidden:(NSNotification*)n
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = Main_Screen_Bounds;
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 内容控件
-(void)setupContent{
     //标题
    UILabel*titleLB=[[UILabel alloc]init];
    titleLB.text=@"标题";
    titleLB.textAlignment=NSTextAlignmentCenter;
    titleLB.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:titleLB];
    
    _titleField = [[UITextField alloc]init];
    
    
    if (self.isFree) {
        titleLB.frame=CGRectMake(0,  64 + 20+40, SCREEN_W/4, 40);
        _titleField.frame= CGRectMake(SCREEN_W/4, 64 + 20+40, SCREEN_W/4*3, 40);
    }else {
        titleLB.frame=CGRectMake(0,  64 + 20, SCREEN_W/4, 40);
        _titleField.frame= CGRectMake(SCREEN_W/4, 64 + 20, SCREEN_W/4*3, 40);
    
    }

    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 44)];
    [self.view addSubview:_titleField];
    leftView.backgroundColor = [UIColor clearColor];
    _titleField.leftViewMode = UITextFieldViewModeAlways;
    _titleField.leftView = leftView;
    _titleField.delegate=self;
    _titleField.placeholder = @"请输入标题";
    _titleField.backgroundColor = [UIColor whiteColor];//标题背景
    //横线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleField.frame), SCREEN_W, 1)];
    [self.view addSubview:lineView];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    //内容
   _contentView = [[QCTextView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame), SCREEN_W, 100)];
    _contentView.delegate=self;
    [self.view addSubview:_contentView];
    _contentView.placeHolder = @"请输入内容";
    _contentView.placeHolderColor = [UIColor colorWithHexString:@"BDBDC3"];
    _contentView.font = [UIFont systemFontOfSize:15];
  
    //图片
    _photosView = [[MessagePhotoView alloc ]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), SCREEN_W, 200)];
    _photosView.delegate = self;
    [self.view addSubview:_photosView];
    
    
    if (self.isFree) {
        
        
        //类型
        UILabel*typeLB=[[UILabel alloc]initWithFrame:CGRectMake(0,  64 + 20, SCREEN_W/4, 40)];
        typeLB.text=@"类型";
        typeLB.textAlignment=NSTextAlignmentCenter;
        typeLB.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:typeLB];
        
        UIView*typeV=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_W/4, 64 + 20, SCREEN_W/4*3, 40)];
        typeV.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:typeV];
        
        typeView1=[[LJButtonView alloc]initWithFrame:CGRectMake(0, 0, typeV.frame.size.width/3, typeV.frame.size.height)];
        typeView1.imagev.image=[UIImage imageNamed:@"icon_clickbox_pre"];
        typeView1.label.text=@"我要接活";
        typeView1.tag=1;
        [typeV addSubview:typeView1];
        
        typeView2=[[LJButtonView alloc]initWithFrame:CGRectMake(typeV.frame.size.width/3, 0, typeV.frame.size.width/3, typeV.frame.size.height)];
        typeView2.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
        typeView2.label.text=@"我要派活";
        typeView2.tag=2;
        [typeV addSubview:typeView2];
        
        typeView3=[[LJButtonView alloc]initWithFrame:CGRectMake(typeV.frame.size.width/3*2, 0, typeV.frame.size.width/3, typeV.frame.size.height)];
        typeView3.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
        typeView3.label.text=@"交流";
        typeView3.tag=3;
        [typeV addSubview:typeView3];
        
        
        UITapGestureRecognizer *Tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTypeV:)];
        UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTypeV:)];
        
        UITapGestureRecognizer *Tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTypeV:)];
        
        [typeView1 addGestureRecognizer:Tap1];
        [typeView2 addGestureRecognizer:Tap2];
        [typeView3 addGestureRecognizer:Tap3];
        
        
        UIView *lineViews = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(typeV.frame), SCREEN_W, 1)];
        [self.view addSubview:lineViews];
        lineViews.backgroundColor = UIColorFromRGB(0xF1F1F1);
        
        
    }
}


#pragma mark - 发送论库到服务器
-(void)sendLunku:(id)sender{
    
    [self hideKeyboard];
    
    if (_titleField.text.length < 1) {
        [OMGToast showText:@"请输入标题"];
        return;
    }
    if (_contentView.text.length < 1) {
        
        [OMGToast showText:@"请输入内容"];
        return;
    }
    if (_contentView.text.length>5000) {
        [OMGToast showText:@"内容不得大于5000字"];
        return;
    }
    if (_titleField.text.length >50) {
        [OMGToast showText:@"标题不得大于50字"];
    }
    [self initMarksGroup];
}

#pragma mark - 选择贴类型
- (void)initMarksGroup
{
    markGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    markGroupView.backgroundColor = kColorRGBA(52,52,52,0.3);
    markGroupView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:markGroupView];
    
    markTableV = [[UITableView alloc] initWithFrame:CGRectMake(30, (HEIGHT(markGroupView)-HEIGHT(markGroupView)/2)/2, WIDTH(markGroupView)-60, HEIGHT(markGroupView)/2-10) style:UITableViewStylePlain];
    markTableV.delegate = self;
    markTableV.dataSource = self;
    markTableV.bounces = NO;
    markTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    markTableV.backgroundColor = [UIColor whiteColor];
    [markGroupView addSubview:markTableV];
    
    UIView * heView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(markTableV), HEIGHT(self.view)/9)];
    heView.backgroundColor = [UIColor whiteColor];
    UIImageView * cancelImaage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(heView)-HEIGHT(heView)/2-16, HEIGHT(heView)/2-(HEIGHT(heView)/2)/2, HEIGHT(heView)/2, HEIGHT(heView)/2)];
    cancelImaage.image = [UIImage imageNamed:@"deletes"];
    cancelImaage.userInteractionEnabled = YES;
    [heView addSubview:cancelImaage];
    
    UITapGestureRecognizer * cancelTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTap:)];
    [heView addGestureRecognizer:cancelTap];
    UITapGestureRecognizer * cancelTaps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTap:)];
    [cancelImaage addGestureRecognizer:cancelTaps];
    
    markTableV.tableHeaderView = heView;
}

- (void)cancelTap:(UITapGestureRecognizer *)taps
{
    [markGroupView removeFromSuperview];
}

- (void)cancelTaps:(UITapGestureRecognizer *)taps
{
    [markGroupView removeFromSuperview];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCASTVCell * cells = [QCASTVCell QCASTVCell:markTableV];
    cells.groupMarksLabel.text = self.titleArr[indexPath.row];
    return cells;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [markGroupView removeFromSuperview];
    if (self.isFree) {
        NSLog(@"indexPath.row===%ld",indexPath.row);
        [self FreePublish:indexPath.row];
    }else{
        [self sendContent:indexPath.row];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (HEIGHT(markGroupView)-HEIGHT(self.view)/9)/self.titleArr.count;
}

#pragma mark - 发表帖子
-(void)sendContent:(NSInteger)index{
    if (_photosArray.count>0) {
         //有图
        [self popupLoadingView:@"正在发送..."];
        [QCQinniuUploader uploadImages:self.photosArray progress:nil success:^(NSArray *urlArray) {
            
            NSString * str = [urlArray componentsJoinedByString:@","];
            
            CZLog(@"%zd",index);
            NSDictionary *parameter = @{@"title":_titleField.text,@"content":_contentView.text,@"type":@(index+1),@"image":str,@"funcType":@(self.funcType)};
            NSLog(@"parameter====%@",parameter);
            [NetworkManager requestWithURL:FORUM_CREATE parameter:parameter success:^(id response) {
                [self hideLoadingView];
                [OMGToast showText:@"发送成功"];
                
         //刷新列表数据
                [[NSNotificationCenter defaultCenter]postNotificationName:kReloadLKdataNotification object:nil userInfo:@{@"index":@(index+1)}];
                
                [self.navigationController popViewControllerAnimated:YES];
            } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
                [self hideLoadingView];
            }];
        } failure:^{
            [OMGToast showText:@"图片上传失败"];
            [self hideLoadingView];
        }];
    }
    
    if (_photosArray.count == 0) {
        //无图则直接发送文本内容
        NSString *title = _titleField.text;
        NSString *content = _contentView.text;
        NSDictionary *parameter = @{@"title":title,@"content":content,@"type":@(index+1),@"funcType":@(self.funcType)};
        [self popupLoadingView:@"正在发送..."];
        NSLog(@"parameter====%@",parameter);
        [NetworkManager requestWithURL:FORUM_CREATE parameter:parameter success:^(id response) {
            [self hideLoadingView];
            [OMGToast showText:@"发送成功"];
            
            //        刷新列表数据
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadLKdataNotification object:nil userInfo:@{@"index":@(index+1)}];
            
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            [self hideLoadingView];
        }];
    }
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
    UILabel * label = [[UILabel alloc]init];
    if ([label isKindOfClass:[UILabel class]]) {
        if (imgsArray.count>0) {
            label.text = [NSString stringWithFormat:@"%lu",(unsigned long)imgsArray.count];
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }
    }
}

#pragma mark - 自由人发帖
-(void)FreePublish:(NSInteger)index
{
    if (_photosArray.count>0) {
        //有图
        [self popupLoadingView:@"正在发送..."];
        [QCQinniuUploader uploadImages:self.photosArray progress:nil success:^(NSArray *urlArray) {
            NSString * str = [urlArray componentsJoinedByString:@","];
            CZLog(@"%zd",index);
            NSDictionary *parameter = @{@"title":_titleField.text,@"content":_contentView.text,@"type":@(index+1),@"image":str,@"funcType":@(self.funcType)};
            NSLog(@"parameter====%@",parameter);
            [NetworkManager requestWithURL:Publish parameter:parameter success:^(id response) {
                [self hideLoadingView];
                [OMGToast showText:@"发送成功"];
                
                //                刷新列表数据
                [[NSNotificationCenter defaultCenter]postNotificationName:kReloadLKdataNotification object:nil userInfo:@{@"index":@(index+1)}];
                
                [self.navigationController popViewControllerAnimated:YES];
            } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
                [self hideLoadingView];
            }];
            
        } failure:^{
            [OMGToast showText:@"图片上传失败"];
            [self hideLoadingView];
        }];
    }
    
    CZLog(@"%zd",index);
    
    if (_photosArray.count==0) {
        //无图则直接发送文本内容
        NSString *title = _titleField.text;
        NSString *content = _contentView.text;
        NSDictionary *parameter = @{@"title":title,@"content":content,@"type":@(index+1),@"funcType":@(self.funcType)};
        [self popupLoadingView:@"正在发送..."];
        NSLog(@"parameter====%@",parameter);
        [NetworkManager requestWithURL:Publish parameter:parameter success:^(id response) {
            [self hideLoadingView];
            [OMGToast showText:@"发送成功"];
            
            //  刷新列表数据
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadLKdataNotification object:nil userInfo:@{@"index":@(index+1)}];
            
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            [self hideLoadingView];
        }];
    }
}

-(void)touchTypeV:(UITapGestureRecognizer*)tap
{
    NSLog(@"%ld",tap.view.tag);
    
    switch (tap.view.tag) {
        case 1:
            typeView1.imagev.image=[UIImage imageNamed:@"icon_clickbox_pre"];
            typeView2.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
            typeView3.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
            break;
        case 2:
            typeView1.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
            typeView2.imagev.image=[UIImage imageNamed:@"icon_clickbox_pre"];
            typeView3.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
            break;

        case 3:
            typeView1.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
            typeView2.imagev.image=[UIImage imageNamed:@"icon_clickbox"];
            typeView3.imagev.image=[UIImage imageNamed:@"icon_clickbox_pre"];
            break;
        default:
            break;
    }
    self.funcType = (int)tap.view.tag;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, -50, Main_Screen_Width, Main_Screen_Height);
    }];
}

@end
