/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "QCChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SRRefreshView.h"
#import "DXChatBarMoreView.h"
#import "DXRecordView.h"
#import "DXFaceView.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatSendHelper.h"
#import "MessageReadManager.h"
#import "MessageModelManager.h"
#import "LocationViewController.h"
#import "ChatGroupDetailViewController.h"
#import "UIViewController+HUD.h"
#import "NSDate+Category.h"
#import "DXMessageToolBar.h"
#import "DXChatBarMoreView.h"
#import "QCChatViewController+Category.h"
#import "ChatroomDetailViewController.h"
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManagerDelegate.h"
#import "UserProfileViewController.h"
#import "UserProfileManager.h"

/**自定群聊详情*/
#import "QCHFChatGroupDetailVC.h"
#import "QCUserViewController2.h"

/**一键回复*/
#import "QCAKeyToReplyVC.h"
/***/
#import "QCHFUserModel.h"
#import "QCGroupModel.h"
#import "User.h"

#import "DevinVideoViewController.h"

#import "QCUserViewController2.h"

#define KPageCount 20
#define KHintAdjustY    50

@interface QCChatViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SRRefreshDelegate, IChatManagerDelegate, DXChatBarMoreViewDelegate, DXMessageToolBarDelegate, LocationViewDelegate, EMCDDeviceManagerDelegate,EMCallManagerDelegate, DXFaceDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
    NSMutableArray *_messages;
    BOOL _isScrollToBottom;
    
    LoginSession * _sessions;
}

@property (nonatomic) BOOL isChatGroup;

@property (nonatomic) EMConversationType conversationType;

@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者
@property (strong, nonatomic) NSDate *chatTagDate;

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic) BOOL isKicked;
@property (nonatomic) BOOL isRobot;
@property (strong, nonatomic) NSMutableArray * HFUsersDataArr;
@property (strong, nonatomic) QCGroupModel * HFGroupDataModel;

@property (strong ,nonatomic) NSUserDefaults * chatUserDefData;

@property (strong,nonatomic)NSDictionary *extDict;

@end

@implementation QCChatViewController

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup
{
    EMConversationType type = isGroup ? eConversationTypeGroupChat : eConversationTypeChat;
    
    self = [self initWithChatter:chatter conversationType:type];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type
{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _HFUsersDataArr = [NSMutableArray array];
        
//        _chatUserDefData = [NSUserDefaults standardUserDefaults];
//        
//        NSString * str = [_chatUserDefData objectForKey:@"打开恢复"];
//        if (str.length > 0) {
//            NSData * dataY = [_chatUserDefData objectForKey:@"HFChatBackUp"];
//            if (dataY) {
//                _HFBackUpChatArr = [NSMutableArray array];
//                _HFBackUpChatArr = [NSKeyedUnarchiver unarchiveObjectWithData:dataY];
//            }
//        }
        
        _isPlayingAudio = NO;
        _chatter = chatter;
        _conversationType = type;
        _messages = [NSMutableArray array];
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter
                                                                    conversationType:type];
        
        for (EMConversation * con in _HFBackUpChatArr) {
//            NSDictionary * dic = [con keyValues];
            CZLog(@"%@", con.chatter);
            CZLog(@"%@", _conversation.chatter)
            if ([_conversation.chatter isEqualToString:con.chatter]) {
                _conversation = con;
            }
        }
        
        if (type == eConversationTypeChat) {
            [self initGetMultiByHids:chatter];
        }else{
            [self initChatGroupDetailByHids:chatter];
        }
        [_conversation markAllMessagesAsRead:YES];
    }
    return self;
}

-(NSDictionary *)extDict{
    if (_extDict == nil) {
        LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
        NSString *userName = sessions.user.nickname;
        NSString *headUrl = sessions.user.avatarUrl;
        _extDict = @{@"u_nick_name":userName,@"u_head_url":headUrl,@"uid":[NSString stringWithFormat:@"%ld",sessions.user.uid]};
    }
    return _extDict;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerBecomeActive];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    _sessions = [[ApplicationContext sharedInstance] getLoginSession];
    
#warning 以下三行代码必须写，注册为SDK的ChatManager的delegate
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    // 注册为Call的Delegate
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendReplyImageAndMessage:) name:@"sendReplyImageAndMessage" object:nil];
    
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    _isScrollToBottom = YES;
    
    [self setupBarButtonItem];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self.view addSubview:self.chatToolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    //通过会话管理者获取已收发消息
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:KPageCount append:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    if (_conversationType == eConversationTypeChatRoom)
    {
        [self joinChatroom:_chatter];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    if (_isScrollToBottom) {
        [self scrollViewToBottom:NO];
    }else{
        _isScrollToBottom = YES;
    }
    self.isInvisible = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    self.isInvisible = YES;
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:_conversation.chatter deleteMessages:NO append2Chat:YES];
    }
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    if (_conversation.conversationType == eConversationTypeChatRoom && !_isKicked)
    {
        //退出聊天室，删除会话
        NSString *chatter = [_chatter copy];
        [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:chatter completion:^(EMChatroom *chatroom, EMError *error){
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:YES];
        }];
    }
    
    if (_imagePicker)
    {
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma -mark 通过环信id获取群详情
- (void)initChatGroupDetailByHids:(NSString *)hids
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"hids"] = hids;
    
    [NetworkManager requestWithURL:GETGROUPSBYHIDS parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        
        NSMutableArray * array = [QCGroupModel mj_objectArrayWithKeyValuesArray:response];
        if (array.count > 0)
        {
            NSArray * arr = response;
            NSDictionary * dic = arr[0];
            self.HFGroupDataModel = array[0];
            self.HFGroupDataModel.Id = dic[@"id"];
            
            [_HFUsersDataArr addObjectsFromArray:_HFGroupDataModel.members];
            NSLog(@"_HFUsersDataArr====%@",_HFUsersDataArr);
            [self.tableView reloadData];
        }else{
            [self.tableView reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - 根据hid获取个人信息
- (void)initGetMultiByHids:(NSString *)hids
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"hids"] = hids;
    
    [NetworkManager requestWithURL:USERINFO_GETMULTIBYHIDS parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        NSArray * arr = response;
        if (arr.count > 0) {
            [_HFUsersDataArr addObjectsFromArray:arr];
        }
        [self.tableView reloadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

- (BOOL)isChatGroup
{
    return _conversationType != eConversationTypeChat;
}

- (void)saveChatroom:(EMChatroom *)chatroom
{
    NSString *chatroomName = chatroom.chatroomSubject ? chatroom.chatroomSubject : @"";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
    NSMutableDictionary *chatRooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
    if (![chatRooms objectForKey:chatroom.chatroomId])
    {
        [chatRooms setObject:chatroomName forKey:chatroom.chatroomId];
        [ud setObject:chatRooms forKey:key];
        [ud synchronize];
    }
}

- (void)joinChatroom:(NSString *)chatroomId
{
    [self showHudInView:self.view hint:NSLocalizedString(@"chatroom.joining",@"Joining the chatroom")];
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncJoinChatroom:chatroomId completion:^(EMChatroom *chatroom, EMError *error){
        if (weakSelf)
        {
            QCChatViewController *strongSelf = weakSelf;
            [strongSelf hideHud];
            if (error && (error.errorCode != EMErrorChatroomJoined))
            {
                [strongSelf showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.joinFailed",@"join chatroom \'%@\' failed"), chatroomId]];
            }
            else
            {
                [strongSelf saveChatroom:chatroom];
            }
        }else{
            if (!error || (error.errorCode == EMErrorChatroomJoined))
            {
                [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:chatroomId completion:^(EMChatroom *chatroom, EMError *error){
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatroomId deleteMessages:YES append2Chat:YES];
                }];
            }
        }
    }];
}

- (void)sendReplyImageAndMessage:(NSNotification *)not
{
    NSMutableDictionary * dic = not.object;
    
    [self sendTextMessage:dic[@"content"]];
    
    UIImage * imageRe = dic[@"image"];
    if (imageRe) {
        [self sendImageMessage:imageRe];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isInvisible = YES;
    }else{
        //结束call
        self.isInvisible = NO;
    }
}

#pragma -mark 清空聊天信息
- (void)removeAllMessages:(id)sender
{
    if (_dataSource.count == 0) {
//        [self showHint:NSLocalizedString(@"清除成功", @"no messages")];
        [OMGToast showText:@"清空成功"];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        if (self.isChatGroup && [groupId isEqualToString:_conversation.chatter]) {
            [_conversation removeAllMessages];
            [_messages removeAllObjects];
            _chatTagDate = nil;
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [OMGToast showText:@"清空成功"];
        }
    }else{
        __weak typeof(self) weakSelf = self;
        
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
                        completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                            if (buttonIndex == 1) {
                                [weakSelf.conversation removeAllMessages];
                                [weakSelf.messages removeAllObjects];
                                weakSelf.chatTagDate = nil;
                                [weakSelf.dataSource removeAllObjects];
                                [weakSelf.tableView reloadData];
                            }
                        } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                      otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    }
}


#pragma -mark 聊天详情按扭
- (void)setupBarButtonItem{
    
//    if (self.isChatGroup) {
//        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
//        [detailButton addTarget:self action:@selector(showRoomContact:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
        UIBarButtonItem * detailsBar =[[UIBarButtonItem alloc]initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:self action:@selector(detailsRoomContact:)];
        self.navigationItem.rightBarButtonItem = detailsBar;
//    }
}

- (void)setIsInvisible:(BOOL)isInvisible
{
    _isInvisible =isInvisible;
    if (!_isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}

#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
                
        ChatMoreType type = self.isChatGroup == YES ? ChatMoreTypeGroupChat : ChatMoreTypeChat;
        _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight)-80, _chatToolBar.frame.size.width, 160) type:type];
        _chatToolBar.moreView.backgroundColor = RGBACOLOR(240, 242, 247, 1);
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        NSLog(@"");
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        
            NSString * chatTime = (NSString *)obj;
            NSString * HFNowChatDates;
            
            if (![chatTime containsString:@"上"] && ![chatTime containsString:@"下"] && ![chatTime containsString:@"昨"] && ![chatTime containsString:@"月"]) {
            
                NSDate * chatNowDate = [NSDate dateWithFormatString:@"HH:mm" dateString:chatTime];
                NSInteger unitFlags = NSHourCalendarUnit;
                NSDateComponents * components = [[NSCalendar currentCalendar] components:unitFlags fromDate:chatNowDate];
                NSLog(@"%ld",(long)components.hour);
                if (components.hour < 12) {
                    HFNowChatDates = [NSString stringWithFormat:@"上午 %@", chatTime];
                }else if (12 <= components.hour && components.hour < 18){
                    HFNowChatDates = [NSString stringWithFormat:@"下午 %@", chatTime];
                }else{
                    HFNowChatDates = [NSString stringWithFormat:@"晚上 %@", chatTime];
                }
                
                timeCell.textLabel.text = HFNowChatDates;
            }else{
                timeCell.textLabel.text = (NSString *)obj;
            }
            return timeCell;
        }else{
            MessageModel *model = (MessageModel *)obj;
            //UserProfileEntity *user = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.username];
            if (_HFUsersDataArr.count > 0) {
                if (_HFUsersDataArr.count < 2) {
                    NSLog(@"");
                    NSDictionary * dic = _HFUsersDataArr[0];
                    CZLog(@"User%@,Dic%@", model.username,dic[@"hid"]);
                    NSString * userN = [dic[@"hid"] lowercaseString];
                    if ([model.username isEqualToString:userN]) {
                        model.nickName = dic[@"nickname"];
                        model.headImageURL = [NSURL URLWithString:dic[@"avatarUrl"]];
                    }else{
                        model.nickName = _sessions.user.nickname;
                        model.headImageURL = [NSURL URLWithString:_sessions.user.avatarUrl];
                    }
                }else{
                    for (NSDictionary * dic in _HFUsersDataArr) {
                        CZLog(@"User%@,Dic%@", model.username,dic[@"hid"]);
                        NSString * userN = [dic[@"hid"] lowercaseString];
                        if ([model.username isEqualToString:userN]) {
                            model.nickName = dic[@"nickname"];
                            model.headImageURL = [NSURL URLWithString:dic[@"avatarUrl"]];
                        }
                    }
                }
            }
            
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //content 消息内容  imageRemoteURL 发送的图片URL
            cell.messageModel = model;
            cell.headImageView.tag=indexPath.row+100;
//            [cell.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
//            cell.select^(NSInteger selectedIndex) {
//                
//            };
            return cell;
        }
    }
    
    return nil;
}


#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    _chatTagDate = nil;
    EMMessage *firstMessage = [self.messages firstObject];
    if (firstMessage)
    {
        [self loadMoreMessagesFrom:firstMessage.timestamp count:KPageCount append:YES];
    }
    [_slimeView endRefresh];
}

#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            EMChatViewCell *cell = (EMChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
        }
    }
}

- (void)reloadData{
    _chatTagDate = nil;
    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.tableView reloadData];
    
    //回到前台时
    if (!self.isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    NSLog(@"userInfo====%@",userInfo);
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    NSLog(@"from====%@", model.message.from);
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }else if([eventName isEqualToString:kResendButtonTapEventName]){
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        if ((messageModel.status != eMessageDeliveryState_Failure) && (messageModel.status != eMessageDeliveryState_Pending))
        {
            return;
        }
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    }else if ([eventName isEqualToString:kRouterEventMenuTapEventName]) {
        [self sendTextMessage:[userInfo objectForKey:@"text"]];
    }else if ([eventName isEqualToString:kRouterEventChatHeadImageTapEventName]) {
        //头像点击
        [self chatHeadImagePressed:model];
    }else if ([eventName isEqualToString:@"pushtoUser"]){
         LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
        NSArray *arr = [model.content componentsSeparatedByString:@","];
        if ([arr[3] integerValue]!=sessions.user.uid ) {
        QCUserViewController2*vc=[[QCUserViewController2 alloc]init];
        vc.uid=[arr[3] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
        }else{
        [OMGToast showText:@"这张是自己的名片哟"];
        }
    }
}

#pragma mark 头像点击方法
- (void)chatHeadImagePressed:(MessageModel *)model
{
    NSLog(@"_HFUsersDataArr===%@,ext===%@,from====%@,to====%@,model.isSender===%d,uid====%@",_HFUsersDataArr,model.message.ext[@"u_nick_name"],model.message.from,model.message.to,model.isSender,model.message.ext[@"uid"]);
    
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (self.conversationType == eConversationTypeGroupChat){
        BOOL isUs = NO;
        NSInteger uid = 0;
        for (NSDictionary *dict in _HFUsersDataArr) {
            uid = [dict[@"uid"] integerValue];
            if ([model.message.ext[@"uid"] integerValue] == sessions.user.uid) {
                isUs = YES;
                break ;
            }else{
                isUs = NO;
            }
        }
        
        if (isUs) {
            self.tabBarController.selectedIndex = 3;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
             @"3"];
        }else{
            QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
            user.uid = [model.message.ext[@"uid"] integerValue];
            [self.navigationController pushViewController:user animated:YES];
        }
    }else if(self.conversationType == eConversationTypeChat){
        NSLog(@"0000000000====%@",_HFUsersDataArr[0]);
        
        NSDictionary *dict = _HFUsersDataArr[0];
        NSInteger uid = [dict[@"uid"] integerValue];
        if ([model.message.ext[@"uid"] integerValue] == sessions.user.uid) {
            self.tabBarController.selectedIndex = 3;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
             @"3"];
        }else{
            QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
            user.uid = uid;
            [self.navigationController pushViewController:user animated:YES];
        }
        
//        
//        if (_HFUsersDataArr.count == 1) {
//            NSDictionary *dict = _HFUsersDataArr[0];
//            NSString *nickname = [NSString stringWithFormat:@"%@",dict[@"nickname"]];
//            if (![sessions.user.nickname isEqualToString:nickname]) {
//                self.tabBarController.selectedIndex = 3;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
//                 @"3"];
//            }
//        }else{
//            for (NSDictionary *dict in _HFUsersDataArr) {
//                NSInteger uid = [dict[@"uid"] integerValue];
//                if ([model.message.ext[@"u_nick_name"] isEqualToString:sessions.user.nickname]) {
//                    self.tabBarController.selectedIndex = 3;
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
//                     @"3"];
//                }else{
//                    QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
//                    user.uid = uid;
//                    [self.navigationController pushViewController:user animated:YES];
//                }
//            }
//        }
        
    }
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model
{
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        
        return;
    }
    
#pragma -mark 播放音频
    if (model.type == eMessageBodyType_Voice) {
        //发送已读回执
        if ([self shouldAckMessage:model.message read:YES])
        {
//            model.message.ext =
            [self sendHasReadResponseForMessages:@[model.message]];
        }
        __weak QCChatViewController *weakSelf = self;
        BOOL isPrepare = [self.messageReadManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak QCChatViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.chatVoice.localPath completion:^(NSError *error) {
                [weakSelf.messageReadManager stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model
{
    _isScrollToBottom = NO;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)chatVideoCellPressed:(MessageModel *)model
{
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.messageBody;
    if (videoBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
    {
        NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
        if (localPath && localPath.length > 0)
        {
            //发送已读回执
            if ([self shouldAckMessage:model.message read:YES])
            {
                [self sendHasReadResponseForMessages:@[model.message]];
            }
            [self playVideoWithVideoPath:localPath];
            return;
        }
    }
    
    __weak QCChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            //发送已读回执
            if ([weakSelf shouldAckMessage:model.message read:YES])
            {
                [weakSelf sendHasReadResponseForMessages:@[model.message]];
            }
            NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
            if (localPath && localPath.length > 0) {
                [weakSelf playVideoWithVideoPath:localPath];
            }
        }else{
            [weakSelf showHint:NSLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    } onQueue:nil];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath
{
    _isScrollToBottom = NO;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model
{
    __weak QCChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            if (imageBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
            {
                //发送已读回执
                if ([self shouldAckMessage:model.message read:YES])
                {
                    [self sendHasReadResponseForMessages:@[model.message]];
                }
                NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    self.isScrollToBottom = NO;
                    if (image)
                    {
                        [self.messageReadManager showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return ;
                }
            }
            [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //发送已读回执
                    if ([weakSelf shouldAckMessage:model.message read:YES])
                    {
                        [weakSelf sendHasReadResponseForMessages:@[model.message]];
                    }
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            [weakSelf.messageReadManager showBrowserWithImages:@[image]];
                        }
                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [weakSelf showHint:NSLocalizedString(@"message.imageFail", @"image for failure!")];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark - IChatManagerDelegate发送消息

-(void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)didReceiveHasReadResponse:(EMReceipt*)receipt
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             
             if ([model.messageId isEqualToString:receipt.chatId])
             {
                 model.message.isReadAcked = YES;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak QCChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                
                if ([object isKindOfClass:[MessageModel class]]) {
                    MessageModel *model = (MessageModel *)object;
                    if ([message.messageId isEqualToString:model.messageId]) {
                        MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        if ([self->_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                            NSString *showName = [self->_delelgate nickNameWithChatter:model.username];
                            cellModel.nickName = showName?showName:cellModel.username;
                        }else {
                            cellModel.nickName = cellModel.username;
                        }
                        
                        if ([self->_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                            cellModel.headImageURL = [NSURL URLWithString:[self->_delelgate avatarWithChatter:cellModel.username]];
                        }
                        
                        //Demo集成Parse,获取用户个人信息
                        UserProfileEntity *user = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.username];
                        
                        if (user && user.imageUrl.length > 0) {
                            model.headImageURL = [NSURL URLWithString:user.imageUrl];
                        }
                        
                        if (user && user.nickname.length > 0) {
                            model.nickName = user.nickname;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                        });
                        break;
                    }
                }
            }
        }
    });
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}

-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self addMessage:message];
        if ([self shouldAckMessage:message read:NO])
        {
            [self sendHasReadResponseForMessages:@[message]];
        }
        if ([self shouldMarkMessageAsRead])
        {
            [self markMessagesAsRead:@[message]];
        }
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    }
}

- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error
{
    if (error && [_conversation.chatter isEqualToString:conversationChatter]) {
        
        __weak QCChatViewController *weakSelf = self;
        for (int i = 0; i < self.dataSource.count; i ++) {
            id object = [self.dataSource objectAtIndex:i];
            if ([object isKindOfClass:[MessageModel class]]) {
                MessageModel *currentModel = [self.dataSource objectAtIndex:i];
                EMMessage *currMsg = [currentModel message];
                if ([messageId isEqualToString:currMsg.messageId]) {
                    currMsg.deliveryState = eMessageDeliveryState_Failure;
                    MessageModel *cellModel = [MessageModelManager modelWithMessage:currMsg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView endUpdates];
                        
                    });
                    
                    if (error && error.errorCode == EMErrorMessageContainSensitiveWords)
                    {
                        CGRect frame = self.chatToolBar.frame;
                        [self showHint:NSLocalizedString(@"message.forbiddenWords", @"Your message contains forbidden words") yOffset:-frame.size.height + KHintAdjustY];
                    }
                    break;
                }
            }
        }
    }
}


- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if (![offlineMessages count])
    {
        return;
    }
    if ([self shouldMarkMessageAsRead])
    {
        [_conversation markAllMessagesAsRead:YES];
    }
    _chatTagDate = nil;
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:[self.messages count] + [offlineMessages count] append:NO];
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (self.isChatGroup && [group.groupId isEqualToString:_chatter]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didInterruptionRecordAudio
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    
    [self stopAudioPlayingWithChangeCategory:YES];
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error && self.isChatGroup && [_chatter isEqualToString:group.groupId])
    {
        self.title = group.groupSubject;
    }
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - EMChatBarMoreViewDelegate

#pragma -mark 表情
- (void)moreViewFaceAction:(DXChatBarMoreView *)moreView
{
    [self keyBoardHidden];
    
}

#pragma -mark 相册
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
}

#pragma -mark 相机
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
#endif
}

#pragma -mark 地图定位
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];

    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

#pragma -mark 回复
- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    QCAKeyToReplyVC * vc = [[QCAKeyToReplyVC alloc] init];
    vc.title = @"快捷回复";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark 视频
- (void)moreViewVideoAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":self.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeVideo]}];
    
    DevinVideoViewController * vc = [[DevinVideoViewController alloc] init];
    vc.title = @"本地视频";
    
    [vc setVideoSelectedBlock:^(NSURL * chatVideo) {
        
        NSURL *mp4 = [self convert2Mp4:chatVideo];
        
        EMChatVideo *chatVideos = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideos];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LocationViewDelegate

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    NSDictionary *ext = nil;
    EMMessage *locationMessage = [ChatSendHelper sendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter messageType:[self messageType] requireEncryption:NO ext:ext];
    [self addMessage:locationMessage];
}

#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    if ([self canRecord]) {
        DXRecordView *tmpView = (DXRecordView *)recordView;
        tmpView.center = CGPointMake(kUIScreenW/2, kUIScreenH/2 - 150);
        
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];

        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
                 NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                       displayName:@"audio"];
            voice.duration = aDuration;
            [weakSelf sendAudioMessage:voice];
        }else {
            [weakSelf showHudInView:self.view hint:NSLocalizedString(@"录音时间太短", @"The recording time is too short")];
            weakSelf.chatToolBar.recordButton.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                weakSelf.chatToolBar.recordButton.enabled = YES;
            });
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        [self sendImageMessage:orgImage];
    }
    self.isInvisible = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}

#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    
    _longPressIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:_longPressIndexPath.row];
        [_conversation removeMessage:model.message];
        [self.messages removeObject:model.message];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:_longPressIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataSource removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - private

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    MessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}

- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:count before:timestamp];
        if ([messages count] > 0) {
            NSInteger currentCount = 0;
            if (append)
            {
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                NSArray *formated = [weakSelf formatMessages:messages];
                id model = [weakSelf.dataSource firstObject];
                if ([model isKindOfClass:[NSString class]])
                {
                    NSString *timestamp = model;
                    [formated enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                        if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                        {
                            [weakSelf.dataSource removeObjectAtIndex:0];
                            *stop = YES;
                        }
                    }];
                }
                currentCount = [weakSelf.dataSource count];
                [weakSelf.dataSource insertObjects:formated atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formated count])]];
                
                EMMessage *latest = [weakSelf.messages lastObject];
                weakSelf.chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)latest.timestamp];
            }
            else
            {
                weakSelf.messages = [messages mutableCopy];
                weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
            
            //从数据库导入时重新下载没有下载成功的附件
            for (EMMessage *message in messages)
            {
                [weakSelf downloadMessageAttachments:message];
            }
            
            NSMutableArray *unreadMessages = [NSMutableArray array];
            for (NSInteger i = 0; i < [messages count]; i++)
            {
                EMMessage *message = messages[i];
                if ([self shouldAckMessage:message read:NO])
                {
                    [unreadMessages addObject:message];
                }
            }
            if ([unreadMessages count])
            {
                [self sendHasReadResponseForMessages:unreadMessages];
            }
        }
    });
}

- (void)downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ([messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.attachmentDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }
    }
}

#pragma -mark 信息内容
- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                
                NSString * HFChatDates;
                
                BOOL isHFTodays = [createDate isToday];
                BOOL isYesterdays = [createDate isYesterday];
                
                if (isHFTodays) {
                    NSString * todayDates = [createDate currentDateString:@"HH:mm"];
                    
                    //获取某一个时间的某一个时间值
                    NSInteger unitFlags = NSHourCalendarUnit;
                    NSDateComponents * components = [[NSCalendar currentCalendar] components:unitFlags fromDate:createDate];
                    NSLog(@"%ld",(long)components.hour);
                    
                    if (components.hour < 12) {
                        HFChatDates = [NSString stringWithFormat:@"上午 %@", todayDates];
                    }
                    else if (12 <= components.hour && components.hour < 18)
                    {
                        HFChatDates = [NSString stringWithFormat:@"下午 %@", todayDates];
                    }
                    else
                    {
                        HFChatDates = [NSString stringWithFormat:@"晚上 %@", todayDates];
                    }
                }
                else if (isYesterdays)
                {
                    NSString * yesterdayDates = [createDate currentDateString:@"HH:mm"];
                    
                    HFChatDates = [NSString stringWithFormat:@"昨天 %@", yesterdayDates];
                }
                else
                {
                    HFChatDates = [createDate currentDateString:@"yyyy年MM月dd日 HH:mm"];
                }
                
                [formatArray addObject:HFChatDates];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                NSString *showName = [_delelgate nickNameWithChatter:model.username];
                model.nickName = showName?showName:model.username;
            }else {
                model.nickName = model.username;
            }
            
            if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
            }
            
            //Demo集成Parse,获取用户个人信息
            UserProfileEntity *user = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.username];
            
            if (user && user.imageUrl.length > 0) {
                model.headImageURL = [NSURL URLWithString:user.imageUrl];
            }
            
            if (user && user.nickname.length > 0) {
                model.nickName = user.nickname;
            }
            
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MessageModel *model = [MessageModelManager modelWithMessage:message];
    if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
        NSString *showName = [_delelgate nickNameWithChatter:model.username];
        model.nickName = showName?showName:model.username;
    }else {
        model.nickName = model.username;
    }
    
    if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
        model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
    }
    
    //Demo集成Parse,获取用户个人信息
    UserProfileEntity *user = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.username];
    
    if (user && user.imageUrl.length > 0) {
        model.headImageURL = [NSURL URLWithString:user.imageUrl];
    }
    
    if (user && user.nickname.length > 0) {
        model.nickName = user.nickname;
    }

    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}

#pragma -mark 接受/发送最新信息
-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    __weak QCChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

#pragma -mark 环信自带的个人/群聊详情
- (void)showRoomContact:(id)sender
{
    [self.view endEditing:YES];
    
    
    if (self.conversationType == eConversationTypeGroupChat) {
        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:_chatter];
        [self.navigationController pushViewController:detailController animated:YES];
    }
    else if (self.conversationType == eConversationTypeChatRoom)
    {
        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:_chatter];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

#pragma -mark 自定义个人/群聊详情
- (void)detailsRoomContact:(UIBarButtonItem *)bar
{
    if (self.isUserPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.view endEditing:YES];
        if (self.conversationType == eConversationTypeGroupChat || self.conversationType == eConversationTypeChatRoom) {
            QCHFChatGroupDetailVC * detailController = [[QCHFChatGroupDetailVC alloc] initWithGroupId:_chatter];
            detailController.hids = _chatter;
            detailController.title = @"群组信息";
            [self.navigationController pushViewController:detailController animated:YES];
        }else if (self.conversationType == eConversationTypeChat){
            QCUserViewController2 *user = [[QCUserViewController2 alloc]init];
            
            if (_HFUsersDataArr.count > 0) {
                user.uid = [[_HFUsersDataArr[0] valueForKey:@"uid"] integerValue];
                user.isFriend = [[_HFUsersDataArr[0] valueForKey:@"isFriends"] boolValue];
                [self.navigationController pushViewController:user animated:YES];
            }
            
            
        }
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessage:message];
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    }
}

- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}

#pragma -mark 点击播放录音/图片/视频/地图
- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldMarkMessageAsRead
{
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    return YES;
}

- (EMMessageType)messageType
{
    EMMessageType type = eMessageTypeChat;
    switch (_conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - public

- (void)hideImagePicker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
    NSLog(@"self.extDict====%@",self.extDict);
//    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:self.extDict];
    [self addMessage:tempMessage];
}

-(void)sendImageMessage:(UIImage *)image
{
//    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:self.extDict];
    [self addMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice
{
//    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:self.extDict];
    [self addMessage:tempMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video
{
//    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:self.extDict];
    [self addMessage:tempMessage];
}

- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}

- (void)markMessagesAsRead:(NSArray*)messages
{
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}

#pragma mark - EMCDDeviceManagerDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_isPlayingAudio) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - EMChatManagerChatroomDelegate

- (void)chatroom:(EMChatroom *)chatroom occupantDidJoin:(NSString *)username
{
    CGRect frame = self.chatToolBar.frame;
    [self showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.join", @"\'%@\'join chatroom\'%@\'"), username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)chatroom:(EMChatroom *)chatroom occupantDidLeave:(NSString *)username
{
    CGRect frame = self.chatToolBar.frame;
    [self showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.leave", @"\'%@\'leave chatroom\'%@\'"), username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)beKickedOutFromChatroom:(EMChatroom *)chatroom reason:(EMChatroomBeKickedReason)reason
{
    if ([_chatter isEqualToString:chatroom.chatroomId])
    {
        _isKicked = YES;
        CGRect frame = self.chatToolBar.frame;
        [self showHint:[NSString stringWithFormat:NSLocalizedString(@"chatroom.remove", @"be removed from chatroom\'%@\'"), chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (reason == eCallReasonNull) {
        if ([[EMCDDeviceManager sharedInstance] isPlaying]) {
            [self stopAudioPlayingWithChangeCategory:NO];
        }
    }
}

#pragma mark - 创建带附件的消息体和批量导入消息的示例
//- (void)loadMessage
//{
//    NSDictionary *imageDic = @{EMMessageBodyAttrKeySecret:@"fmIgiuSuEeSdyLffbqYspd3oOH6uMSGkXaOvZUF9ayy5b26c",
//                               EMMessageBodyAttrKeySize:@{EMMessageBodyAttrKeySizeWidth:@640,EMMessageBodyAttrKeySizeHeight:@1136},
//                               EMMessageBodyAttrKeyFileName:@"image.jpg",
//                               EMMessageBodyAttrKeyType:EMMessageBodyAttrTypeImag,
//                               EMMessageBodyAttrKeyUrl:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/7e622080-e4ae-11e4-8a29-c1c8b3fc3a16",
//                               EMMessageBodyAttrKeyFileLength:@178212};
//    EMImageMessageBody *imageBody = [EMImageMessageBody imageMessageBodyFromBodyDict:imageDic forChatter:_chatter];
//    EMMessage *image = [[EMMessage alloc] initMessageWithID:@"50152415936119390" sender:_chatter receiver:@"my_test4" bodies:@[imageBody]];
//    image.timestamp = ([[NSDate date] timeIntervalSince1970] - 10) * 1000;
//    image.isReadAcked = YES;
//    image.deliveryState = eMessageDeliveryState_Delivered;
//    image.isRead = YES;
//    image.isGroup = self.isChatGroup;
//    image.conversationChatter = @"my_test5";
//
//    NSDictionary *voiceDic = @{EMMessageBodyAttrKeySecret:@"ZTKmSuSxEeS2upsPo9JVK-E7e7W_Ieu6g55uSbYCQikqSmh1",
//                               EMMessageBodyAttrKeyFileName:@"audio chat",
//                               EMMessageBodyAttrKeyDuration:@6,
//                               EMMessageBodyAttrKeyType:EMMessageBodyAttrTypeAudio,
//                               EMMessageBodyAttrKeyUrl:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/6532a640-e4b1-11e4-9a0a-019cf64935ae",
//                               EMMessageBodyAttrKeyFileLength:@8870};
//
//    EMVoiceMessageBody *voiceBody = [EMVoiceMessageBody voiceMessageBodyFromBodyDict:voiceDic forChatter:_chatter];
//    EMMessage *voice = [[EMMessage alloc] initMessageWithID:@"50152415936119490" sender:_chatter receiver:@"my_test4" bodies:@[voiceBody]];
//    voice.timestamp = ([[NSDate date] timeIntervalSince1970] - 5) * 1000;
//    voice.isReadAcked = YES;
//    voice.deliveryState = eMessageDeliveryState_Delivered;
//    voice.isRead = YES;
//    voice.isGroup = isChatGroup;
//    voice.conversationChatter = @"my_test5";
//
//    NSDictionary *videoDic = @{EMMessageBodyAttrKeySecret:@"ANfQauSzEeSWceXUdNLCzOoCWyafJ0jg5AticaEKlEVCeqD2",
//                               EMMessageBodyAttrKeyDuration:@12,
//                               EMMessageBodyAttrKeyThumbSecret:@"AHShyuSzEeS9Eo2-FC-hEqTv7L96P5LNxUCo2zGrbZfu9FWz",
//                               EMMessageBodyAttrKeySize:@{EMMessageBodyAttrKeySizeWidth:@68,EMMessageBodyAttrKeySizeHeight:@90},
//                               EMMessageBodyAttrKeyThumb:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/0074a1c0-e4b3-11e4-9adb-9da24ed370c3",
//                               EMMessageBodyAttrKeyFileName:@"video.mp4",
//                               EMMessageBodyAttrKeyType:@"video",
//                               EMMessageBodyAttrKeyFileLength:@1235670,
//                               EMMessageBodyAttrKeyUrl:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/00d7d060-e4b3-11e4-9906-8311a663fa09"};
//
//    EMVideoMessageBody *videoBody = [EMVideoMessageBody videoMessageBodyFromBodyDict:videoDic forChatter:_chatter];
//    EMMessage *video = [[EMMessage alloc] initMessageWithID:@"50152415936119590" sender:_chatter receiver:@"my_test4" bodies:@[videoBody]];
//    video.timestamp = ([[NSDate date] timeIntervalSince1970] - 1) * 1000;
//    video.isReadAcked = YES;
//    video.deliveryState = eMessageDeliveryState_Delivered;
//    video.isRead = YES;
//    video.isGroup = isChatGroup;
//    video.conversationChatter = @"my_test5";
//    [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[image, voice, video]];
//    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
//}

@end
