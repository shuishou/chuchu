
//
//  QCHFChatBackUpAndRestoreVC.m
//  MyQOOCOO
//
//  Created by Wind on 16/1/9.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCHFChatBackUpAndRestoreVC.h"

#import "QCGroupModel.h"

#import "QCFriendListCell.h"
@interface QCHFChatBackUpAndRestoreVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * tableViews;
    UIView * backUpView;
    UIView * titleView;
}

@property (strong, nonatomic) NSUserDefaults * chatUserDefData;

@property (strong, nonatomic) QCGroupModel * HFGroupDataModel;

@property (strong, nonatomic) NSMutableArray * HFUsersDataArr;
@property (strong, nonatomic) NSMutableArray * HFIsReloadDataArr;
@property (nonatomic,strong) NSMutableArray * positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray * positionFor9ModeImage;
@property (strong, nonatomic) NSMutableArray * HFImageArray;
@property (strong, nonatomic) NSMutableArray *conversations;

//备份数据
@property (strong, nonatomic) NSMutableArray * chatBackUpDataArr;
@end

@implementation QCHFChatBackUpAndRestoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGBA(237, 237, 237, 1);
    
    _chatUserDefData = [NSUserDefaults standardUserDefaults];
    
    _HFUsersDataArr = [NSMutableArray array];
    _chatBackUpDataArr = [NSMutableArray array];
    _HFIsReloadDataArr = [NSMutableArray array];
    
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];
    
    _HFImageArray = [NSMutableArray array];
    
    //初始化图片在UIView中图片的坐标
    [self initImageposition];
    
    if ([_isBackUp boolValue]) {
        //环信原生方法:获取当前所有聊天记录
        NSArray * arr = [[EaseMob sharedInstance].chatManager conversations];
        _conversations = [NSMutableArray array];
        [_conversations addObjectsFromArray:arr];
        
        for (EMConversation *conversation in _conversations) {
            
            if (conversation.conversationType == eConversationTypeChat) {
                [self initGetMultiByHids:conversation.chatter];
            }
            else
            {
                [self initChatGroupDetailByHids:conversation.chatter];
            }
            
        }
    }
    else
    {
        NSData * dataY = [_chatUserDefData objectForKey:@"HFChatBackUp"];
        
        if (dataY) {
            _conversations = [NSKeyedUnarchiver unarchiveObjectWithData:dataY];
            
            for (EMConversation *conversation in _conversations) {
                
                if (conversation.conversationType == eConversationTypeChat) {
                    [self initGetMultiByHids:conversation.chatter];
                }
                else
                {
                    [self initChatGroupDetailByHids:conversation.chatter];
                }
                
            }
        }
    }
    
    
    [self initTableView];
}

- (void)initTableView
{
    tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.bounces = NO;
    tableViews.backgroundColor = kColorRGBA(237, 237, 237, 1);
    
    [self.view addSubview:tableViews];
}

#pragma -mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_conversations.count > 0) {
        return _conversations.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"backUpCell";
    
    QCFriendListCell * cell = [tableViews dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[QCFriendListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_conversations.count > 0) {
        EMConversation *conversation = _conversations[indexPath.row];
        if (conversation.conversationType == eConversationTypeChat) {
            if (_HFUsersDataArr.count > 0) {
                for (NSDictionary * dic in _HFUsersDataArr) {
                    
                    if ([conversation.chatter isEqualToString:[dic[@"hid"] lowercaseString]]) {
                        if (dic[@"nickname"]) {
                            cell.titleLabel.text = dic[@"nickname"];
                        }
                        
                        if (dic[@"avatarUrl"]) {
                            CZLog(@"%@" ,dic[@"avatarUrl"]);
                            
                            if ([dic[@"avatarUrl"] containsString:@","]) {
                                NSArray * arr = [dic[@"avatarUrl"] componentsSeparatedByString:@","];
                                [cell.avaterImage sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
                            }
                            else
                            {
                                [cell.avaterImage sd_setImageWithURL:[NSURL URLWithString:dic[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
                            }
                            
                            
                            
                            
                        }
                        else
                        {
                            cell.avaterImage.image = [UIImage imageNamed:@"ios-template-120(1)"];
                        }
                        
                    }
                    
                }
                
            }
            
        }
        else{
            NSString *imageName = @"groupPublicHeader";
            if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
            {
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.titleLabel.text = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        
                        NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                        [ext setObject:group.groupSubject forKey:@"groupSubject"];
                        [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                        conversation.ext = ext;
                        break;
                    }
                }
                
                if (_HFGroupDataModel) {
                    cell.titleLabel.text = _HFGroupDataModel.name;
                    
                    for (NSDictionary * dics in _HFGroupDataModel.members) {
                        NSLog(@"%@", dics[@"avatarUrl"]);
                        
                        UIImageView * ima = [UIImageView new];
                        
                        [ima sd_setImageWithURL:[NSURL URLWithString:dics[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"ios-template-120"]];
                        
                        if (_HFImageArray.count < 4) {
                            [_HFImageArray addObject:ima.image];
                        }
                    }
                    
                    [cell.avaterImage setImage:[self makeGroupAvatar:_HFImageArray]];
                }
                
            }
            else
            {
                if (_HFGroupDataModel) {
                    cell.titleLabel.text = [conversation.ext objectForKey:@"groupSubject"];
                    imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
                    
                    for (NSDictionary * dics in _HFGroupDataModel.members) {
                        NSLog(@"%@", dics[@"avatarUrl"]);
                        
                        UIImageView * ima = [UIImageView new];
                        
                        [ima sd_setImageWithURL:[NSURL URLWithString:dics[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"ios-template-120"]];
                        
                        if (_HFImageArray.count < 4) {
                            [_HFImageArray addObject:ima.image];
                        }
                    }
                    
                    [cell.avaterImage setImage:[self makeGroupAvatar:_HFImageArray]];
                }
                
            }
        }

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WIDTH(self.view)/5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![_isBackUp boolValue]) {
        [self initbackUpView:indexPath.row];
    }
}

//进入可编辑状态
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
        [super setEditing:editing animated:animated];
        [tableViews setEditing:editing animated:animated];
}

//指定编辑的单元
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//指定编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//设置按钮的字体
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_isBackUp boolValue]) {
        return @"备份";
    }
    else
    {
        return @"恢复";
    }
    
}

//完成编辑、提交（关注/取消关注）
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    //判断编辑样式是否相同
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([_isBackUp boolValue]) {
            
            NSData * dataY = [_chatUserDefData objectForKey:@"HFChatBackUp"];
            
            EMConversation * newsCon = _conversations[indexPath.row];
            
            if (dataY) {

                NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:dataY];
                
                [_chatBackUpDataArr removeAllObjects];
                
#pragma -mark 对备份数据进行快速筛选
                __block BOOL isObjectExist = NO;
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    EMConversation * con = (EMConversation *)obj;
                    if ([con.chatter isEqualToString:newsCon.chatter]) {
                        [arr replaceObjectAtIndex:idx withObject:newsCon];
                        isObjectExist = YES;
                        *stop = YES;
                    }
                }];
                
                //如果对象不存在,添加它
                if(!isObjectExist) {
                    [arr addObject:newsCon];
                }
                
                [_chatBackUpDataArr addObjectsFromArray:arr];
            }
            else
            {
                [_chatBackUpDataArr addObject: newsCon];
            }
            
            //将所有的会话记录转成 NSData
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:_chatBackUpDataArr];
            [_chatUserDefData setObject: data forKey:@"HFChatBackUp"];
            
            [tableViews reloadData];
            [OMGToast showText:@"备份成功"];
        }
        else
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HFRestoreMessage" object:_conversations[indexPath.row]];
            
            [_chatUserDefData setObject:@"恢复聊天历史" forKey:@"打开恢复"];
            
            [tableViews reloadData];
        }
    }
}

- (void)initbackUpView:(NSInteger)indexs
{
    backUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    backUpView.backgroundColor = kColorRGBA(52,52,52,0.3);
    backUpView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:backUpView];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(30, (HEIGHT(backUpView)-HEIGHT(backUpView)/3)/2, WIDTH(backUpView)-60, HEIGHT(backUpView)/3)];
    titleView.backgroundColor = [UIColor whiteColor];
    [backUpView addSubview:titleView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)/2-(HEIGHT(titleView)/5)/2-10, WIDTH(titleView), HEIGHT(titleView)/5)];
    label.text = @"是否删除当前备份";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/5];
    [titleView addSubview:label];
    
    UIButton * cancelBu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBu.frame = CGRectMake(0, HEIGHT(titleView)-HEIGHT(titleView)/5, WIDTH(titleView)/2, HEIGHT(titleView)/5);
    [cancelBu setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(cancelBu)*2/5]];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [backUpView removeFromSuperview];
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(doneBu)*2/5]];
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        [_conversations removeObjectAtIndex:indexs];
        
        //将所有的会话记录转成 NSData
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:_conversations];
        [_chatUserDefData setObject: data forKey:@"HFChatBackUp"];
        [backUpView removeFromSuperview];
        [tableViews reloadData];
    }];
    [titleView addSubview:doneBu];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)-HEIGHT(cancelBu)-0.5, WIDTH(titleView), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line];
    
    
    //#pragma -mark 轻点消失
    //    UITapGestureRecognizer * dismissTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    //    [backUpView addGestureRecognizer:dismissTap];
}


#pragma -mark 根据hid获取个人信息
- (void)initGetMultiByHids:(NSString *)hids
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"hids"] = hids;
    
    [NetworkManager requestWithURL:USERINFO_GETMULTIBYHIDS parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        NSArray * arr = response;
        
        if (arr.count > 0) {
            [_HFUsersDataArr addObject:arr[0]];
            //是否可以刷新
            [_HFIsReloadDataArr addObject:arr[0]];
        }
        
        if (_HFIsReloadDataArr.count == _conversations.count) {
            [tableViews reloadData];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma -mark 通过环信id获取群详情
- (void)initChatGroupDetailByHids:(NSString *)hids
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"hids"] = hids;
    
    [NetworkManager requestWithURL:GETGROUPSBYHIDS parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        
        NSMutableArray * array = [QCGroupModel mj_objectArrayWithKeyValuesArray:response];
        
        if (array.count > 0) {
            NSArray * arr = response;
            NSDictionary * dic = arr[0];
            self.HFGroupDataModel = array[0];
            self.HFGroupDataModel.Id = dic[@"id"];
            
            [_HFIsReloadDataArr addObject:_HFGroupDataModel];
            
            if (_HFIsReloadDataArr.count == _conversations.count) {
                [tableViews reloadData];
            }
        }
        else
        {
            [tableViews reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

- (UIImage *)makeGroupAvatar: (NSMutableArray *)imageArray {
    //数组为空，退出函数
    if ([imageArray count] == 0){
        return nil;
    }
    
    UIView *groupAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,193,193)];
    groupAvatarView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < [imageArray count]; i++){
        UIImageView *tempImageView;
        if ([imageArray count] < 5){
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor4ModeImage objectAtIndex:i]CGRectValue]];
        }
        else{
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor9ModeImage objectAtIndex:i]CGRectValue]];
        }
        [tempImageView setImage:[imageArray objectAtIndex:i]];
        [groupAvatarView addSubview:tempImageView];
    }
    
    //把UIView设置为image并修改图片大小55*55
    UIImage *reImage = [self scaleToSize:[self convertViewToImage:groupAvatarView]size:CGSizeMake(55, 55)];
    
    return reImage;
}


- (void)initImageposition{
    
    //初始化4图片模式和9图片模式
    for(int i = 0; i < 9; i++){
        CGRect tempMode4Rect;
        CGRect tempMode9Rect;
        float mode4PositionX = 0;
        float mode4PositionY = 0;
        float mode9PositionX = 0;
        float mode9PositionY = 0;
        
        switch (i) {
            case 0:
                mode4PositionX = 4;
                mode4PositionY = 4;
                mode9PositionX = 4;
                mode9PositionY = 4;
                break;
            case 1:
                mode4PositionX = 98.5;
                mode4PositionY = 4;
                mode9PositionX = 67;
                mode9PositionY = 4;
                break;
            case 2:
                mode4PositionX = 4;
                mode4PositionY = 98.5;
                mode9PositionX = 130;
                mode9PositionY = 4;
                break;
            case 3:
                mode4PositionX = 98.5;
                mode4PositionY = 98.5;
                mode9PositionX = 4;
                mode9PositionY = 67;
                break;
            case 4:
                mode9PositionX = 67;
                mode9PositionY = 67;
                break;
            case 5:
                mode9PositionX = 130;
                mode9PositionY = 67;
                break;
            case 6:
                mode9PositionX = 4;
                mode9PositionY = 130;
                break;
            case 7:
                mode9PositionX = 67;
                mode9PositionY = 130;
                break;
            case 8:
                mode9PositionX = 130;
                mode9PositionY = 130;
                break;
            default:
                break;
        }
        
        //添加4模式图片坐标到数组
        if (i < 4 ){
            tempMode4Rect = CGRectMake(mode4PositionX, mode4PositionY, 90.5, 90.5);
            [_positionFor4ModeImage addObject:[NSValue valueWithCGRect:tempMode4Rect]];
        }
        
        //添加4模式图片坐标到数组
        tempMode9Rect = CGRectMake(mode9PositionX, mode9PositionY, 59, 59);
        [_positionFor9ModeImage addObject:[NSValue valueWithCGRect:tempMode9Rect]];
    }
}

-(UIImage*)convertViewToImage:(UIView*)v{
    
    CGSize s = v.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
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
