//
//  QCTabBarController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//
#import "QCFreeController.h"
#import "QCTabBarController.h"
#import "QCFuntionController2.h"

#import "QCNavigationVC.h"

#import "QCChatMainVc.h"


#import "QCProfileViewController2.h"

#import "QCChatListVC.h"

@interface QCTabBarItem ()


@end

@implementation QCTabBarItem

-(void)setTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage selectedBack:(UIImage *)backImage{
    [self setTitle:title forState:UIControlStateNormal];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:selectedImage forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage imageWithColor:normalTabbarColor andSize:self.bounds.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xed6664) andSize:self.bounds.size] forState:UIControlStateSelected];
    
    [self setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [self setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
}


@end


@interface QCTabBarController ()<IChatManagerDelegate>
{
    QCChatListVC *chatCtr;
}

@end

@implementation QCTabBarController{
    QCTabBarItem * chat;
    QCTabBarItem * func;
     EMConversation*modelss;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmodel:) name:@"messagesNumber" object:nil];
    
    
//    self.tabBar.barTintColor=UIColorFromRGB(0xed6664);
    self.tabBar.tintColor=UIColorFromRGB(0xed6664);

    
//    // 加 2 个 控制器
    QCChatMainVc *chatVc = [[QCChatMainVc alloc] init];
    QCFuntionController2 *fucVc2 = [[QCFuntionController2 alloc]init];
    QCFreeController*freeVc=[[QCFreeController alloc]init];
    QCProfileViewController2*addtagVc=[[QCProfileViewController2 alloc]init];
    addtagVc.isRootVC=YES;
    
    
    [self addChildVCWith:freeVc title:@"自由人" nmlImgName:@"icon_ziyouren" selImgName:@"icon_ziyouren_pre"];
    [self addChildVCWith:chatVc title:@"聊天" nmlImgName:@"icon_liaotian" selImgName:@"icon_liaotian_pre"];
    [self addChildVCWith:fucVc2 title:@"功能" nmlImgName:@"icon_gongneng" selImgName:@"icon_gongneng_pre"];
    [self addChildVCWith:addtagVc title:@"贴标签" nmlImgName:@"icon_tiebiaoqian" selImgName:@"icon_tiebiaoqian_pre"];

    self.delegate=self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveUnreadNum:) name:@"unreadNum" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatenreadMessageCount:) name:@"updateUnreadNum" object:nil];
    
}

#pragma mark 获取并显示未读消息数
-(void)reciveUnreadNum:(NSNotification *)notification{
   NSUInteger unreadNum = [notification.userInfo[@"unreadNum"]integerValue];
    
    UITabBarItem *item=[self.tabBar.items objectAtIndex:1];
    item.badgeValue=[NSString stringWithFormat:@"%ld",unreadNum];
}


#pragma mark 刷新未读消息数
-(void)updatenreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    UITabBarItem *item=[self.tabBar.items objectAtIndex:1];
    item.badgeValue=[NSString stringWithFormat:@"%ld",unreadCount];
}



/**
 *  添加tabbar子控制器
 *
 *  @param vc         tabbar子控制器
 *  @param title      tabbarBtn 标题
 *  @param nmlImgName tabbarBtn 普通图片
 *  @param selImgName tabbarBtn 选中图片
 */
-(void)addChildVCWith:(UIViewController *)vc title:(NSString*)title nmlImgName:(NSString*)nmlImgName selImgName:(NSString*)selImgName{
    
    
    
    QCNavigationVC *nav = [[QCNavigationVC alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    if ([title isEqualToString:@"聊天"]) {
      NSInteger integer=  [self unreadMessageCountByConversation:modelss];
        if (integer>0) {
            
        
    nav.tabBarItem.badgeValue=[NSString stringWithFormat:@"%ld",integer];
        }
    
    }

    nav.tabBarItem.title = title;
    UIImage *nmlImg = [UIImage imageNamed:nmlImgName];
    nmlImg = [nmlImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.image = nmlImg;
    
    UIImage *selImg = [UIImage imageNamed:selImgName];
    selImg = [selImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage =selImg;
}

//代理方法
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    //点击的第几个
//    NSLog(@"%ld",tabBarController.selectedIndex);
//    //点击之后取消红色小圆圈
//    UINavigationController*nav=(UINavigationController*)viewController;
//    nav.tabBarItem.badgeValue=nil;
}
// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

-(void)getmodel:(NSNotification*)n
{
    modelss= n.userInfo[@"numkber"];
}

//#pragma mark - IChatManagerDelegate
//
//- (void)didUpdateConversationList:(NSArray *)conversationList
//{
//    [self setupUnreadMessageCount];
//    [chatCtr refreshDataSource];
//}
//
//// 未读消息数量变化回调
//-(void)didUnreadMessagesCountChanged
//{
//    [self setupUnreadMessageCount];
//}
//
//// 统计未读消息数
//-(void)setupUnreadMessageCount
//{
//    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
//    NSInteger unreadCount = 0;
//    for (EMConversation *conversation in conversations) {
//        unreadCount += conversation.unreadMessagesCount;
//    }
//    if (unreadCount > 0) {
//        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//    }else{
//        chatCtr.tabBarItem.badgeValue = nil;
//    }
//    
//    //    UIApplication *application = [UIApplication sharedApplication];
//    //    [application setApplicationIconBadgeNumber:unreadCount];
//}


@end
