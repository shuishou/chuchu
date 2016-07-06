//
//  QCUserDataVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/7.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCUserDataVC.h"

#import "QCCommonCollectionViewCell.h"

#import "User.h"

#import "QCGetUserMarkModel.h"

#import "QCAddTagVC.h"

#import "QCSelectAreaVC.h"

#import "QCTabBarController.h"

@interface QCUserDataVC ()<UITextFieldDelegate>
{
    UIScrollView*scrollBaV;
    UIImageView* userHead;
    
    NSString*chuhao;
    
    
    UIView*boxV;
    UIView*boxV2;
   
    
    UITextField*nametext;
    UILabel*chuhaolb;
    UITextField*ageText;
    UILabel*sexLb;
    UILabel*addressLb;
    BOOL isChang;
    BOOL isSelectImage;
}

@property(nonatomic,strong)UIView *bV;
@property(nonatomic,strong)UIView *chuView;

@end

@implementation QCUserDataVC

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.isFirstLogin boolValue]){
        self.userMarkArr=[NSMutableArray array];
    }
    
    [self userLabelled];
    isSelectImage = NO;
    
    if (_myData.nickname.length > 0)
    {
        self.title=@"修改资料";
    }else{
        self.title=@"完善个人资料";
    }
    
    self.showMarkFriend = [NSMutableArray array];
    self.showMarkFriend = [self.markfriend mutableCopy];
    self.deleteMarkfriend=[NSMutableArray array];
    isChang=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changAddress:) name:@"SelectArea" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectArr:) name:@"AddTag" object:nil];
    
    UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        
    scrollBaV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*2)];
    [self.view addSubview: scrollBaV];
    
    //设置可滚动范围
    scrollBaV.contentSize=CGSizeMake(0, self.view.frame.size.height+64);
    scrollBaV.backgroundColor=self.view.backgroundColor;
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    //分页显示
    scrollBaV.pagingEnabled=NO;
    
    //滑动到第一页和最后一页是否允许继续滑动
    scrollBaV.bounces=YES;
    
    //取消滚动条
    scrollBaV.showsHorizontalScrollIndicator=NO;//水平(横)
    scrollBaV.showsVerticalScrollIndicator=NO;//垂直(竖)
    
    //指定代理人
    scrollBaV.delegate=self;
    scrollBaV.userInteractionEnabled=YES;
    
    //一开始显示到第几张
    scrollBaV.contentOffset=CGPointMake(0,0);
    
    userHead=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.width-93)/2,30,93,93)];
    [userHead sd_setImageWithURL:[NSURL URLWithString:self.myData.avatarUrl] placeholderImage:[UIImage imageNamed:@"login_user_default_logo"]];
    userHead.layer.cornerRadius=45;
    userHead.layer.masksToBounds=YES;
    userHead.userInteractionEnabled=YES;
    userHead.backgroundColor=[UIColor clearColor];
    [scrollBaV addSubview:userHead];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [userHead addGestureRecognizer:tapGestureRecognizer];

    [self showMyData];
//    [self showMyMark];

    // Do any additional setup after loading the view.
}

-(void)nameInput:(UITextField *)field{
    if (field.text.length > 10) {
        field.text = [field.text substringToIndex:10];
    }
}

#pragma mark 加载个人信息
-(void)showMyData
{
    NSArray*titleArr=[[NSArray alloc]initWithObjects:@"昵称",@"处号",@"年龄",@"性别",@"地址",@"交友标签", nil];

    for (int i=0; i<titleArr.count; i++) {
        UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(0,64*i+93+30+20, 93, 64)];
        title.textAlignment=NSTextAlignmentCenter;
        title.text=titleArr[i];
        title.font=[UIFont systemFontOfSize:14];
        [scrollBaV addSubview:title];
    }

    //姓名
    nametext=[[UITextField alloc]initWithFrame:CGRectMake(93, 93+30+20, scrollBaV.bounds.size.width-93, 64)];
    nametext.placeholder = @"必填";
    nametext.delegate=self;
    nametext.text=self.myData.nickname;
    [nametext addTarget:self action:@selector(nameInput:) forControlEvents:UIControlEventEditingChanged];
    nametext.font=[UIFont systemFontOfSize:14];
    [scrollBaV addSubview:nametext];
    
    //处号
    chuhaolb = [[UILabel alloc]initWithFrame:CGRectMake(93, 64+93+30+20, scrollBaV.bounds.size.width-93, 64)];
    if (self.myData.userno != nil)
    {
       chuhaolb.text=self.myData.userno;
    }else{
       chuhaolb.text=@"必填";
    }
    chuhaolb.userInteractionEnabled=YES;
    chuhaolb.font=[UIFont systemFontOfSize:14];
    chuhaolb.textColor=[UIColor grayColor] ;
    [scrollBaV addSubview:chuhaolb];
    
    UITapGestureRecognizer*tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changchuhaoLb)];
    tap3.numberOfTapsRequired =1;
    [chuhaolb addGestureRecognizer:tap3];
    
    //年龄
    ageText=[[UITextField alloc]initWithFrame:CGRectMake(93, 64*2+93+30+20, scrollBaV.bounds.size.width-93, 64)];
    ageText.placeholder = @"必填";
    ageText.keyboardType = UIKeyboardTypePhonePad;
    ageText.text = [NSString stringWithFormat:@"%d",self.myData.age];
    ageText.font = [UIFont systemFontOfSize:14];
    [scrollBaV addSubview:ageText];
    
    //性别
    sexLb = [[UILabel alloc]initWithFrame:CGRectMake(93, 64*3+93+30+20, scrollBaV.bounds.size.width-93-40, 64)];
    if (self.myData.sex==0)
    {
        sexLb.text = @"男";
    }else if(self.myData.sex == 1){
        sexLb.text = @"女";
    }else {
        sexLb.text = @"必填";
    }
    sexLb.userInteractionEnabled=YES;
    sexLb.textColor=[UIColor grayColor];
    sexLb.font=[UIFont systemFontOfSize:14];
    [scrollBaV addSubview:sexLb];
    
    UITapGestureRecognizer*tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changsexLb)];
    tap2.numberOfTapsRequired =1;
    [sexLb addGestureRecognizer:tap2];
    
    //地址
    addressLb=[[UILabel alloc]initWithFrame:CGRectMake(93, 64*4+93+30+20, scrollBaV.bounds.size.width-93-40, 64)];
    if (self.myData.province!=nil)
    {
        self.province=self.myData.province;
        self.city=self.myData.city;
        addressLb.text=[self.province stringByAppendingString:self.city];
    }else{
        addressLb.text=@"必填";
    }
    addressLb.font=[UIFont systemFontOfSize:14];
    addressLb.textColor=[UIColor grayColor];
    addressLb.userInteractionEnabled=YES;
    [scrollBaV addSubview:addressLb];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLb)];
    tap.numberOfTapsRequired =1;
    [addressLb addGestureRecognizer:tap];
    
    UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(scrollBaV.bounds.size.width-30, 64*3+93+30+20+22, 20, 20)];
    imagev.image=[UIImage imageNamed:@"LJjianyou@2x"];
    [scrollBaV addSubview:imagev];
    
    UIImageView*imagev2=[[UIImageView alloc]initWithFrame:CGRectMake(scrollBaV.bounds.size.width-30,  64*4+93+30+20+22, 20, 20)];
    imagev2.image=[UIImage imageNamed:@"LJjianyou@2x"];
    [scrollBaV addSubview:imagev2];
    
    for (int i=0; i<6; i++) {
        if (i>0) {
            UIView *lines=[[UIView alloc]initWithFrame:CGRectMake(30, 64*i+93+30+20, self.view.frame.size.width-60, 0.5)];
            lines.backgroundColor=[UIColor grayColor];
            lines.alpha=0.3;
            [scrollBaV addSubview:lines];
        }
    }
}

-(void)showMyMark
{
    CGRect rect = CGRectMake(0, 64*6+93+30+20,scrollBaV.bounds.size.width, 40);
    NSMutableArray*temparr2 = self.showMarkFriend;
    if (temparr2.count>0)
    {
        float a=temparr2.count/3;
        if (a<1)
        {
            rect.size.height = 40;
        }else{
            if(temparr2.count%3 != 0 && temparr2.count > 3)
            {
                rect.size.height = 40*(int)a+40;
            }else{
                rect.size.height = 40*(int)a;
            }
        }
    }else{
        rect.size.height = 40;
    }
    
    scrollBaV.contentSize=CGSizeMake(0, self.view.frame.size.height+(64*7)+93+30+20+rect.size.height+20+64);
    
    //创建一个布局类
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    //设置最小行间距
    layout.minimumLineSpacing=2;
    //这是最小列间距
    layout.minimumInteritemSpacing=2;
    //设置垂直滚动
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //设置外面上下左右的间距
    layout.sectionInset=UIEdgeInsetsMake(2, 20, 20, 20);
    
    //借助布局类创建一个UICollectionView
    cv=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64*6+93+30+20,scrollBaV.bounds.size.width, rect.size.height) collectionViewLayout:layout];
    
    //注册cell UICollectionView的cell必须注册
    [cv registerClass:[QCCommonCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //注册header
    [cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    cv.scrollEnabled = NO;
    
    //设置代理
    cv.delegate = self;
    cv.dataSource = self;
    cv.backgroundColor = self.view.backgroundColor ;
    
    [scrollBaV addSubview:cv];
    [cv reloadData];
}

#pragma mark - CV代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"[self.showMarkFriend count ]===%lu",(unsigned long)[self.showMarkFriend count ]);
    return [self.showMarkFriend count];
}

//item什么样子
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QCCommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    QCGetUserMarkModel *get = self.showMarkFriend[indexPath.row];
    cell.lb.text = get.title;
    NSLog(@"get.title====%@,get.type===%d",get.title,get.type);
    cell.type = get.type;
    return cell;
}

//控制每个小方块的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/3-20, 38);
}

//点击的低级分区的第几个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@,count====%ld",self.showMarkFriend[(long)indexPath.row],[self.showMarkFriend count]);
    QCGetUserMarkModel *get = self.showMarkFriend[indexPath.row];
    if (get.type == 5) {
        QCAddTagVC *addTag = [[QCAddTagVC alloc]init];
        NSMutableArray*arr = self.showMarkFriend;
        if ([sexLb.text isEqualToString:@"男"])
        {
            addTag.isMan = 1;
        }else{
            addTag.isMan = 2;
        }
        
        //     QCGetUserMarkModel *get = self.showMarkFriend[indexPath.row];
        //
        //    if (get.type != 5) {
        //        [arr  removeObjectAtIndex:arr.count-1];
        //    }
        
        addTag.userMarkArr=[arr mutableCopy];
        [self.navigationController pushViewController:addTag animated:YES];
    }
}

- (void)starButtonClicked:(id)sender
{
    if (nametext.text==nil)
    {
        [OMGToast showText:@"请输入昵称"];
        return ;
    }else if (ageText.text == nil) {
        [OMGToast showText:@"请输入年龄"];
        return ;
    }else if (addressLb.text==nil) {
        [OMGToast showText:@"请输入地址"];
        return ;
    }
    
    NSInteger ageNum = [ageText.text integerValue];
    if (ageText.text != nil) {
        if (ageNum >= 1 && ageNum <= 100) {
//            [self popupLoadingView:@"上传中"];
            //先将未到时间执行前的任务取消。
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(touchRights:) object:sender];
            [self performSelector:@selector(touchRights:) withObject:sender afterDelay:0.5f];
        }else{
            [OMGToast showText:@"请输入正确的年龄"];
        }
    }
}

-(void)touchRights:(UIButton*)bt
{
     @synchronized(self){
         
     }
    
    [MBProgressHUD showMessage:nil background:NO];
    self.traveled=0;
    self.istraveled=0;
    NSLog(@"保存");
    
    
    if (nametext.text != nil && ageText.text !=nil && addressLb.text != nil)
    {
        //依次请求changUserData，pushcommonMark，deleteTagwith，changUserNumber
        [self  changUserData];
        
        if (self.myData.isUpdateUserno == 0) {
             [self changUserNumber];
        }
    }
}

#pragma mark - 修改个人资料
-(void)changUserData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"nickname"] = nametext.text;
    dic[@"sex"]=@(sex);
    dic[@"province"]=self.province;
    dic[@"city"]=self.city;
    dic[@"age"]=@([ageText.text integerValue]);
    
    [NetworkManager requestWithURL:USERDATA parameter:dic success:^(id response) {
        NSLog(@"%@",response);
        if (isSelectImage == YES) {
            [self changUserFace];
        }else{
            if (self.newmarkFriend.count > 0)
            {
                [self pushcommonMark];
            }else{
                if (self.deleteMarkfriend.count > 0) {
                    for (int j=0; j < self.deleteMarkfriend.count; j++) {
                        if ([self.deleteMarkfriend[j] isEqualToString:@"0"]) {
                            QCGetUserMarkModel *mod = self.markfriend[j];
                            [self deleteTagwith:mod.ID];
                        }
                    }
                }else{
                    [self ispop];
                }
            }
        }
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"十分抱歉,请求失败"];
    }];
}


-(void)changUserFace
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSData *mydata=UIImageJPEGRepresentation(userHead.image , 0.4);
    
    NSString *pictureDataString=[mydata base64Encoding];
    dic[@"image"]=pictureDataString;
    
    [NetworkManager requestWithURL:USERHEAR parameter:dic success:^(id response) {
        NSLog(@"%@",response);
        if (self.newmarkFriend.count > 0)
        {
            [self pushcommonMark];
        }else{
            if (self.deleteMarkfriend.count > 0) {
                for (int j=0; j < self.deleteMarkfriend.count; j++) {
                    if ([self.deleteMarkfriend[j] isEqualToString:@"0"]) {
                        QCGetUserMarkModel *mod = self.markfriend[j];
                        [self deleteTagwith:mod.ID];
                    }
                }
            }else{
                 [self ispop];
            }
        }
     } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
         CZLog(@"%@", error);
         [MBProgressHUD hideHUD];
         [OMGToast showText:@"十分抱歉,请求失败"];
     }];
}


#pragma mark 获取用户标签大类
-(void)userLabelled
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    
    dic[@"uid"]=@(sessions.user.uid);
    
    //[MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETMARKGROUP parameter:dic success:^(id response) {
        self.userMarkArr=[response mutableCopy];
        
        NSLog(@"self.userMarkArr===%@",self.userMarkArr);
        self.groupId=[[self.userMarkArr[1] valueForKey:@"id"] integerValue];
        
        [self getMarksByGroupId:self.groupId];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma mark 获取标签数据
-(void)getMarksByGroupId:(long)GroupId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"groupId"]=@(GroupId);
    dic[@"page"]=@0;
    
    [NetworkManager requestWithURL:QUERYTAG parameter:dic success:^(id response) {
        NSLog(@"%@",response);
        NSMutableArray*temparr =[[NSMutableArray alloc]initWithArray:response];
        NSLog(@"temparr====%@",temparr);
        NSMutableArray*userArr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < temparr.count; i++) {
            QCGetUserMarkModel*getUserMark=[[QCGetUserMarkModel alloc]init];
            getUserMark=[QCGetUserMarkModel mj_objectWithKeyValues:temparr[i]];
            getUserMark.ID = [[temparr[i] valueForKey:@"id"] integerValue];
            [userArr addObject:getUserMark];
            
        }
        
        QCGetUserMarkModel *mod = [[QCGetUserMarkModel alloc]init];
        mod.type = 5;
        
        [userArr addObject:mod];
        self.markfriend = userArr;
        self.showMarkFriend = [self.markfriend mutableCopy];
        NSLog(@"self.showMarkFriend===%ld",[self.showMarkFriend count]);
        
        
        [self showMyMark];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma mark 批量添加用户标签
-(void)pushcommonMark
{
    NSString* title;
    for (int i = 0; i <self.newmarkFriend.count; i++) {
        if (i==0) {
            title=[self.newmarkFriend[i] valueForKey:@"title"];
        }else{
            title=[NSString stringWithFormat:@"%@,%@",title,[self.newmarkFriend[i] valueForKey:@"title"]];
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
    
    NSLog(@"dic====%@",dic);
    [NetworkManager requestWithURL:USERINFO_ADDPACTHMARKS parameter:dic success:^(id response) {
 
        if (self.deleteMarkfriend.count > 0) {
            for (int j=0; j < self.deleteMarkfriend.count; j++) {
                if ([self.deleteMarkfriend[j] isEqualToString:@"0"]) {
                    QCGetUserMarkModel *mod = self.markfriend[j];
                    [self deleteTagwith:mod.ID];
                }
            }
        }else{
            [self ispop];
        }

    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"十分抱歉,请求失败"];
    }];
}


#pragma mark 删除标签
-(void)deleteTagwith:(NSInteger)ID
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    dic[@"userMarkId"] = @(ID);//
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_DELETPUSERMARK parameter:dic success:^(id response) {
        [OMGToast showText:@"发送成功"];
        [self ispop];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"十分抱歉,请求失败"];
    }];
}

-(void)changUserNumber
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"userno"] = chuhaolb.text;
    [NetworkManager requestWithURL:USERNUMBER parameter:dic success:^(id response) {
        NSLog(@"%@",response);

    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

-(void)ispop
{
    [MBProgressHUD hideHUD];
    if([self.isFirstLogin boolValue]){
        QCTabBarController *tabVC = [[QCTabBarController alloc]init];
        [self presentViewController:tabVC animated:YES completion:nil];
    }else{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"changFace" object:nil userInfo:nil];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"commturn" object:nil userInfo:nil];
       [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addressLb
{
    QCSelectAreaVC*selectVC=[[QCSelectAreaVC alloc]init];
    [self.navigationController pushViewController:selectVC animated:YES];
}

#pragma mark - 选择拍照
-(void)tapGestureRecognized:(UITapGestureRecognizer*)resture
{
    UIActionSheet*Figure = [[UIActionSheet alloc]
              initWithTitle:nil
              delegate:self
              cancelButtonTitle:@"取消"
              destructiveButtonTitle:nil
              otherButtonTitles: @"从相册选择",@"拍照",nil];
    [Figure showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex) {
        case 0:
            [self LocalPhoto];
            break;
        case 1:
            [self takePhoto];
            break;
        default:
            break;
    }
}

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

#pragma mark 选择相册
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
        
        //设置图片
        userHead.image = image;
        isSelectImage = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}

#pragma mark - 通知
-(void)changAddress:(NSNotification*)n
{
    addressLb.text=n.userInfo[@"str"];
    self.province=n.userInfo[@"province"];
    self.city=n.userInfo[@"city"];
}

-(void)objectArr:(NSNotification*)n
{
    self.newmarkFriend=[n.userInfo[@"newArr"] mutableCopy];
    self.deleteMarkfriend=[n.userInfo[@"isdelete"]mutableCopy];
    self.showMarkFriend =[n.userInfo[@"sumArr"]mutableCopy];
    
//   [self.showMarkFriend removeLastObject];

    
    QCGetUserMarkModel *mod=[[QCGetUserMarkModel alloc]init];
    mod.type=5;
    [self.showMarkFriend addObject:mod];
    
    [cv removeFromSuperview];
    [self showMyMark];
    NSLog(@"%@",self.showMarkFriend);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//isUpdateUserno

#pragma mark 处号修改弹出视图
-(UIView *)chuView{
    if (_chuView == nil) {
        _chuView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
        _chuView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        _chuView.hidden = YES;
        [self.view addSubview:_chuView];
        
        boxV2=[[UIView alloc]initWithFrame:CGRectMake(40,(self.view.height-200)/2-80,self.view.width-80,200)];
        boxV2.backgroundColor = [UIColor whiteColor];
        [_chuView addSubview:boxV2];
        
        
        UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, boxV2.bounds.size.width, 50)];
        lb.text = @"处号只能修改一次";
        lb.textAlignment=NSTextAlignmentCenter;
        lb.font=[UIFont systemFontOfSize:18];
        [boxV2 addSubview:lb];
        
        boxtf=[[UITextField alloc]initWithFrame:CGRectMake(20, (boxV2.bounds.size.height- 30)/2, boxV2.bounds.size.width-40, 30)];
        boxtf.font = [UIFont systemFontOfSize:16];
        boxtf.delegate=self;
        [boxV2 addSubview:boxtf];
        
        UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        choiceBtn.frame=CGRectMake(0, boxV2.frame.size.height-45, boxV2.frame.size.width/2, 45);
        [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
        [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        choiceBtn.tag = 1;
        choiceBtn.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        choiceBtn.layer.borderWidth = 0.5;
        [choiceBtn addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
        [boxV2 addSubview:choiceBtn];
        
        UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
        [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        choiceBtn2.frame=CGRectMake(boxV2.frame.size.width/2,boxV2.frame.size.height-45, boxV2.frame.size.width/2, 45);
        [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
        [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
        choiceBtn2.tag = 2;
        choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        choiceBtn2.layer.borderWidth=0.5;
        [choiceBtn2 addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
        [boxV2 addSubview:choiceBtn2];
    }
    return _chuView;
}

-(void)changchuhaoLb
{
    //isUpdateUserno
    if (self.myData.isUpdateUserno == 0) {
        self.chuView.hidden = !self.chuView.hidden;
    }
}

#pragma mark 性别修改弹出视图
-(void)changsexLb
{
    [nametext resignFirstResponder];
    [ageText resignFirstResponder];
    self.bV.hidden = !self.bV.hidden;
}

-(void)sexChoiceTap{
    self.bV.hidden = YES;
}

-(UIView *)bV{
    if (_bV == nil) {
        _bV = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
        _bV.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        _bV.userInteractionEnabled = YES;
        [_bV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexChoiceTap)]];
        
        _bV.hidden = YES;
        boxV=[[UIView alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height/4*3,self.view.frame.size.width-40,self.view.frame.size.height/4)];
        boxV.backgroundColor=[UIColor whiteColor];
        [_bV addSubview:boxV];
        [self.view addSubview:self.bV];
        
        
        UIButton*bt=[UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bt.frame=CGRectMake(boxV.frame.size.width-60, 0, 60, boxV.frame.size.height/3);
        bt.font=[UIFont systemFontOfSize:14];
        bt.tag = 2;
        [bt setTitle:@"确定" forState:UIControlStateNormal];
        [bt setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(touchsexBt:) forControlEvents:UIControlEventTouchUpInside];
        [boxV addSubview:bt];
        
        bt2=[UIButton buttonWithType:UIButtonTypeCustom];
        [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bt2.frame=CGRectMake(0,  boxV.frame.size.height/3, boxV.frame.size.width, boxV.frame.size.height/3);
        bt2.font=[UIFont systemFontOfSize:14];
        [bt2 setTitle:@"男" forState:UIControlStateNormal];
        bt2.tag=0;
        [bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt2 addTarget:self action:@selector(touchsexBt:) forControlEvents:UIControlEventTouchUpInside];
        [boxV addSubview:bt2];
        
        bt3=[UIButton buttonWithType:UIButtonTypeCustom];
        [bt3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bt3.frame = CGRectMake(0,  boxV.frame.size.height/3*2, boxV.frame.size.width, boxV.frame.size.height/3);
        bt3.font = [UIFont systemFontOfSize:14];
        bt3.tag=1;
        [bt3 setTitle:@"女" forState:UIControlStateNormal];
        [bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt3 addTarget:self action:@selector(touchsexBt:) forControlEvents:UIControlEventTouchUpInside];
        [boxV addSubview:bt3];
    }
    return _bV;
}

-(void)touchsexBt:(UIButton*)bt
{
    switch (bt.tag) {
        case 0:
            sex = bt.tag;
            bt3.backgroundColor = [UIColor whiteColor];
            bt2.backgroundColor = [UIColor colorWithHexString:@"efefef"];
            break;
        case 1:
            sex=bt.tag;
            bt2.backgroundColor=[UIColor whiteColor];
            bt3.backgroundColor=[UIColor colorWithHexString:@"efefef"];
            break;
        case 2:
            if (sex==0) {
               sexLb.text=@"男";
            }else{
               sexLb.text=@"女";
            }
//            [bV removeFromSuperview];
//            [boxV removeFromSuperview];
//            [self.bV removeFromSuperview];
            self.bV.hidden = YES;
            break;
        default:
            break;
    }

}

-(void)choiceBtnCliack:(UIButton*)bt
{
    
    
    
    if (bt.tag==1) {
       // 取消
        isChang=NO;
        self.chuView.hidden = YES;
    }else{
    //确定
       
      
            for (int i=0; i<boxtf.text.length; i++) {
                NSRange range=NSMakeRange(i,1);
                NSString *subString=[boxtf.text substringWithRange:range];
                const char *cString=[subString UTF8String];
                if (strlen(cString)==3)
                {
                    NSLog(@"昵称是汉字");
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"处号不能有汉字" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                    return ;
                    
                }else if(strlen(cString)==1)
                {
                    NSLog(@"昵称是字母");
                    if(boxtf.text.length<6||boxtf.text.length>12){
                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"不要输入低于6个或者高于12个" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertView show];
                        return ;
                    }
                }
            }
            
            chuhaolb.text = boxtf.text;
            
            isChang = YES;
        

    }
    self.chuView.hidden = YES;
}

@end
