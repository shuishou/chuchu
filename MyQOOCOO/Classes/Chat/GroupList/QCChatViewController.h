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

#import <UIKit/UIKit.h>
#import "EMChatManagerDefs.h"

@protocol QCChatViewControllerDelegate <NSObject, NSCopying>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface QCChatViewController : UIViewController
@property (strong, nonatomic, readonly) NSString *chatter;
@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong, nonatomic) NSMutableArray *HFBackUpChatArr; //备份数据
@property (nonatomic) BOOL isInvisible;
@property (nonatomic, assign) id <QCChatViewControllerDelegate> delelgate;
@property (strong, nonatomic) EMConversation *conversation;//会话管理者

@property(nonatomic,assign)BOOL isUserPush;

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)reloadData;

- (void)hideImagePicker;

#pragma mark - sendMessage
-(void)sendTextMessage:(NSString *)textMessage;
-(void)sendImageMessage:(UIImage *)image;
-(void)sendAudioMessage:(EMChatVoice *)voice;
-(void)sendVideoMessage:(EMChatVideo *)video;
-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
-(void)addMessage:(EMMessage *)message;
- (EMMessageType)messageType;
@end
