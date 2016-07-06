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

#import "QCChatListVC.h"
#import "SRRefreshView.h"
#import "QCChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "QCChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "UserProfileManager.h"
#import "HFSearchFriendListVc.h"
#import "QCLoginVC.h"

#import "QCHFUserModel.h"
#import "QCGroupModel.h"

#import "EMCDDeviceManager.h"
#import "EMCDDeviceManagerDelegate.h"



@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.chatter]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.chatter];
        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.chatter];
    } else if (self.conversationType == eConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"groupSubject"] || [self.ext objectForKey:@"isPublic"]) {
           return [self.ext objectForKey:@"groupSubject"];
        }
    }
    return self.chatter;
}

@end

@interface QCChatListVC ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,QCChatViewControllerDelegate, EMCDDeviceManagerDelegate>
{
    UISearchDisplayController *searchDisplayController;
}
@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
//@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;

@property (strong, nonatomic) NSMutableArray * HFUsersDataArr;
@property (strong, nonatomic) NSMutableArray * HFGroupDataArr;
@property (strong, nonatomic) NSMutableArray * HFIsReloadDataArr;
@property (strong, nonatomic) QCGroupModel * HFGroupDataModel;

@property (nonatomic,strong) NSMutableArray * positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray * positionFor9ModeImage;
@property (strong, nonatomic) NSMutableArray * HFImageArray;


//@property (strong, nonatomic) EMSearchDisplayController *searchController;
//备份聊天记录

//@property(nonatomic,assign)NSInteger unreadNum;

@end

@implementation QCChatListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    
//    [self.view addSubview:self.searchBar];
    [self showSearchView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = RGBACOLOR(241, 241, 241, 1);
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self networkStateView];

//    [self searchController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
    [self registerNotifications];
    
    LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
    if (![session isValidate]) {
        QCLoginVC *loginVC = [[QCLoginVC alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (void)removeChatroomConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.conversationType == eConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (void)showSearchView
{
    UILabel * searchLa = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width-16, WIDTH(self.view)/10)];
    searchLa.backgroundColor = [UIColor whiteColor];
    searchLa.textAlignment = NSTextAlignmentCenter;
    searchLa.textColor = [UIColor colorWithHexString:@"999999"];
    searchLa.text = @"搜索";
    searchLa.font = [UIFont systemFontOfSize:HEIGHT(searchLa)/2];
    searchLa.layer.masksToBounds = YES;
    searchLa.layer.cornerRadius = 5;
    [self.view addSubview:searchLa];
    
    searchLa.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [searchLa addGestureRecognizer:tap1];
}

- (void)searchViewTapped:(UITapGestureRecognizer *)taps
{
    HFSearchFriendListVc * friendListVc = [[HFSearchFriendListVc alloc] init];
    UINavigationController * friendNa = [[UINavigationController alloc] initWithRootViewController:friendListVc];
    friendListVc.hidesBottomBarWhenPushed = YES;
    [self presentViewController:friendNa animated:YES completion:nil];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (WIDTH(self.view)/10+16), self.view.frame.size.width, self.view.frame.size.height - 113-(WIDTH(self.view)/10+16)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[QCChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

//- (EMSearchDisplayController *)searchController
//{
//    if (_searchController == nil) {
//        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
//        _searchController.delegate = self;
//        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        __weak QCChatListVC *weakSelf = self;
//        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//            static NSString *CellIdentifier = @"ChatListCell";
//            QCChatListCell *cell = (QCChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            
//            // Configure the cell...
//            if (cell == nil) {
//                cell = [[QCChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//            
//            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            cell.name = conversation.chatter;
//            if (conversation.conversationType == eConversationTypeChat) {
//                cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
//                cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
//            }
//            else{
//                NSString *imageName = @"groupPublicHeader";
//                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:conversation.chatter]) {
//                        cell.name = group.groupSubject;
//                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//                        break;
//                    }
//                }
//                cell.placeholderImage = [UIImage imageNamed:imageName];
//            }
//            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
//            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
//            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
//            if (indexPath.row % 2 == 1) {
//                cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
//            }else{
//                cell.contentView.backgroundColor = [UIColor whiteColor];
//            }
//            return cell;
//        }];
//        
//        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
//            return [QCChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
//        }];
//        
//        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            [weakSelf.searchController.searchBar endEditing:YES];
//            
//            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            QCChatViewController *chatController;
//            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
//                chatController = [[QCChatViewController alloc] initWithChatter:conversation.chatter
//                                                                 conversationType:conversation.conversationType];
//                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
//            }else {
//                chatController = [[QCChatViewController alloc] initWithChatter:conversation.chatter
//                                                            conversationType:conversation.conversationType];
//                chatController.title = [conversation showName];
//            }
//            [weakSelf.navigationController pushViewController:chatController animated:YES];
//        }];
//    }
//    
//    return _searchController;
//}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
//    CZLog(@"会话对象列表%@", )
    NSArray* sorte = [conversations sortedArrayUsingComparator:
           ^(EMConversation *obj1, EMConversation* obj2){
               EMMessage *message1 = [obj1 latestMessage];
               EMMessage *message2 = [obj2 latestMessage];
               if(message1.timestamp > message2.timestamp) {
                   return(NSComparisonResult)NSOrderedAscending;
               }else {
                   return(NSComparisonResult)NSOrderedDescending;
               }
           }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        NSDateFormatter * dateForma = [[NSDateFormatter alloc] init];
        [dateForma setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDateFormatter * dateFormay = [[NSDateFormatter alloc] init];
        [dateFormay setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter * dateFormah = [[NSDateFormatter alloc] init];
        [dateFormah setDateFormat:@"HH:mm"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:lastMessage.timestamp/1000];
        NSString * chatStr = [dateFormay stringFromDate:confromTimesp];
        NSDate * chatDates = [dateFormay dateFromString:chatStr];
        NSString * chatTimeStr = [dateFormah stringFromDate:confromTimesp];
        NSDate * chatNowDate = [dateFormah dateFromString:chatTimeStr];
        
        //现在时间
        NSDate * nDate = [NSDate date];
        NSString * nowsStr = [dateFormay stringFromDate:nDate];
        NSDate * nowDate = [dateFormay dateFromString:nowsStr];
        
        if ([chatDates timeIntervalSinceDate:nowDate] < 0.0)
        {
            ret = [dateFormay stringFromDate:confromTimesp];
        }
        else
        {
            NSInteger unitFlags = NSHourCalendarUnit;
            NSDateComponents * components = [[NSCalendar currentCalendar] components:unitFlags fromDate:chatNowDate];
            NSLog(@"%ld",(long)components.hour);
            
            if (components.hour <= 12) {
                ret = [NSString stringWithFormat:@"上午 %@", [dateFormah stringFromDate:confromTimesp]];
            }
            else if (12 < components.hour && components.hour <= 18)
            {
                ret = [NSString stringWithFormat:@"下午 %@", [dateFormah stringFromDate:confromTimesp]];
            }
            else if (18 < components.hour)
            {
                ret = [NSString stringWithFormat:@"晚上 %@", [dateFormah stringFromDate:confromTimesp]];
            }
        }
    }
    
    return ret;
}

#pragma mark - 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    NSLog(@"ret====%ld",(long)ret);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messagesNumber" object:nil userInfo:@{@"number":conversation}];
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"图片", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([didReceiveText  containsString:@"send_content_from_card_to_show"]) {
                    ret = @"[名片]";

    
                }else{
                
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"语音信息", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"位置信息", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"视频信息", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
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
        
        if (_HFIsReloadDataArr.count == self.dataSource.count) {
            [self.tableView reloadData];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", ferror);
    }];
}

#pragma mark 通过环信id获取群详情
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

            [_HFGroupDataArr addObject:_HFGroupDataModel];
            [_HFIsReloadDataArr addObject:_HFGroupDataModel];
            
            if (_HFIsReloadDataArr.count == self.dataSource.count) {
                [self.tableView reloadData];
            }
        }else{
            [self.tableView reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}


#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    QCChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[QCChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    if (conversation.conversationType == eConversationTypeChat) {
        if (_HFUsersDataArr.count > 0) {
            for (NSDictionary *dic in _HFUsersDataArr) {
                NSLog(@"dic====%@",dic);
                
                if ([conversation.chatter isEqualToString:[dic[@"hid"] lowercaseString]]) {
                    if (dic[@"note"]) {
                        cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:dic[@"note"]];
                    }else if (dic[@"nickname"]) {
                        cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:dic[@"nickname"]];
                    }
                    
                    if (dic[@"avatarUrl"]) {
                        CZLog(@"%@" ,dic[@"avatarUrl"]);
                        
                        if ([dic[@"avatarUrl"] containsString:@","]) {
                            NSArray * arr = [dic[@"avatarUrl"] componentsSeparatedByString:@","];
                            [cell.placeholderImage sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];//ios-template-120(1)
                        }else{
                            [cell.placeholderImage sd_setImageWithURL:[NSURL URLWithString:dic[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];//ios-template-120(1)
                        }
                    }else{
                        cell.placeholderImage.image = [UIImage imageNamed:@"default-avatar_1"];//ios-template-120(1)
                    }
                }
            }
        }
    }else{
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                
                if ([group.groupId isEqualToString:conversation.chatter]) {
//                    cell.name = group.groupSubject;
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";

                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
            
            if (_HFGroupDataModel) {
                cell.name = _HFGroupDataModel.name;
                
                for (NSDictionary * dics in _HFGroupDataModel.members) {
                    NSLog(@"%@", dics[@"avatarUrl"]);
                    
                    UIImageView * ima = [UIImageView new];
                    
                    [ima sd_setImageWithURL:[NSURL URLWithString:dics[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
                    
                    if (_HFImageArray.count < 4) {
                        [_HFImageArray addObject:ima.image];
                    }
                }
                
                [cell.placeholderImage setImage:[self makeGroupAvatar:_HFImageArray]];
            }
            
            if (_HFGroupDataArr.count > 0) {
                for (QCGroupModel * model in _HFGroupDataArr) {
                    if ([conversation.chatter isEqualToString:model.hid]) {
                        
                        cell.name = model.name;
                        
                        for (NSDictionary * dics in model.members) {
                            NSLog(@"%@", dics[@"avatarUrl"]);
                            
                            UIImageView * ima = [UIImageView new];
                            
                            [ima sd_setImageWithURL:[NSURL URLWithString:dics[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
                            
                            if (_HFImageArray.count < 4) {
                                [_HFImageArray addObject:ima.image];
                            }
                        }
                        [cell.placeholderImage setImage:[self makeGroupAvatar:_HFImageArray]];
                    }
                }
            }
        }
        else
        {
            if (_HFGroupDataArr.count > 0) {
                for (QCGroupModel * model in _HFGroupDataArr) {
                    if ([conversation.chatter isEqualToString:model.hid]) {
                        
                        cell.name = model.name;
                        imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
                        
                        for (NSDictionary * dics in model.members) {
                            NSLog(@"%@", dics[@"avatarUrl"]);
                            
                            UIImageView * ima = [UIImageView new];
                            
                            [ima sd_setImageWithURL:[NSURL URLWithString:dics[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
                            
                            if (_HFImageArray.count < 4) {
                                [_HFImageArray addObject:ima.image];
                            }
                        }
                        
                        [cell.placeholderImage setImage:[self makeGroupAvatar:_HFImageArray]];
                    }
                }
            }
        }
    }
    
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    if (self.dataSource.count <= 1) {
        cell.Cline.backgroundColor = [UIColor whiteColor];
    }else{
        if (indexPath.row == self.dataSource.count-1) {
            cell.Cline.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            cell.Cline.backgroundColor = RGBACOLOR(230, 230, 230, 1);
        }
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [QCChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)updateUnreadNum{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSInteger resultNum = 0;
    for (EMConversation *conversation in conversations){
        NSInteger temp = [self unreadMessageCountByConversation:conversation];
        resultNum += temp;
    }
    
    if (resultNum > 0) {
        UITabBarItem *item=[self.tabBarController.tabBar.items objectAtIndex:1];
        item.badgeValue=[NSString stringWithFormat:@"%ld",resultNum];
    }else{
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
        item.badgeValue = nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    QCChatViewController *chatController;
    NSString *title = conversation.chatter;
    if (conversation.conversationType != eConversationTypeChat) {
        if ([[conversation.ext objectForKey:@"groupSubject"] length])
        {
            title = [conversation.ext objectForKey:@"groupSubject"];
        }else{
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    title = group.groupSubject;
                    break;
                }
            }
        }
    }else if (conversation.conversationType == eConversationTypeChat) {
        for (NSDictionary * dic in _HFUsersDataArr) {
            
            if ([conversation.chatter isEqualToString:[dic[@"hid"] lowercaseString]]) {
                if (dic[@"note"]) {
                    
                title = [[UserProfileManager sharedInstance] getNickNameWithUsername:dic[@"note"]];
                }else if (dic[@"nickname"]) {
                    title = [[UserProfileManager sharedInstance] getNickNameWithUsername:dic[@"nickname"]];
                }
                
            }
            
        }
    }
    
    NSString *chatter = conversation.chatter;
    chatController = [[QCChatViewController alloc] initWithChatter:chatter
                                                  conversationType:conversation.conversationType];
    chatController.title = title;
    chatController.delelgate = self;
    [self.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"    ";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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


//#pragma mark - UISearchBarDelegate
//
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar setShowsCancelButton:YES animated:YES];
//    
//    return YES;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    __weak typeof(self) weakSelf = self;
//    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
//        if (results) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.searchController.resultsSource removeAllObjects];
//                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
//                [weakSelf.searchController.searchResultsTableView reloadData];
//            });
//        }
//    }];
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    return YES;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    searchBar.text = @"";
//    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
//    [searchBar resignFirstResponder];
//    [searchBar setShowsCancelButton:NO animated:YES];
//}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    
    _HFUsersDataArr = [NSMutableArray array];
    _HFGroupDataArr = [NSMutableArray array];
    _HFIsReloadDataArr = [NSMutableArray array];
    
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];
    
    _HFImageArray = [NSMutableArray array];
    
    //初始化图片在UIView中图片的坐标
    [self initImageposition];
    
     [self updateUnreadNum];
    
    for (EMConversation *conversation in self.dataSource) {

        if (conversation.conversationType == eConversationTypeChat) {
            [self initGetMultiByHids:conversation.chatter];
        }else{
            [self initChatGroupDetailByHids:conversation.chatter];
        }
    }
    
    [_tableView reloadData];
    [self hideHud];
}


- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }

}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
//    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
    return nil;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}

@end
