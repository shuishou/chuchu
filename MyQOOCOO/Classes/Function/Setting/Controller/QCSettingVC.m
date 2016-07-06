//
//  QCSettingVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/1.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSettingVC.h"
#import "QCBaseTableView.h"
//自控制器
#import "QCNewMessageVC.h"
#import "QCChatSettingVC.h"
#import "QCFuntionManageVC.h"
#import "QCAboutQOOCOOVC.h"
#import "QCLoginVC.h"

#import "QCHFMoreVC.h"
@interface QCSettingVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    QCBaseTableView *_tableView;
    UILabel * temSize;
}
@property ( nonatomic , assign) int count;
@end

@implementation QCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count =0;
    
    self.navigationItem.title = @"设置";
    self.navigationItem.rightBarButtonItem = nil;
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.data = [[NSMutableArray alloc]initWithArray:@[@[@"新消息通知",@"聊天"],@[@"功能管理"],@[@"清理缓存"],@[@"关于出处"]]];
    [self.view addSubview:_tableView];
    
    
    //退出登录
    [self setupLogout];
}

#pragma mark - 退出登录
-(void)setupLogout{
    float height = 20 * 4 + 44 * 5 + 64;
    UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 115, height +34, 230, 40)];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.backgroundColor = UIColorFromRGB(0xE54545);
    logoutBtn.layer.cornerRadius = 2;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}
-(void)logoutBtnClick:(id)sender{
    [NetworkManager requestWithURL:USER_LOGOUT_URL parameter:nil success:^(id response) {
        [[ApplicationContext sharedInstance]removeLoginSession];
         __weak QCSettingVC *weakSelf = self;
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:nil completion:^(NSDictionary *info, EMError *error) {
            if (error &&error.errorCode !=EMErrorServerNotLogin) {
                [weakSelf showHint:error.debugDescription];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"isLogOut"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:AppExitUserNotification object:nil userInfo:nil];
                [OMGToast showText:@"注销成功"];
                QCLoginVC *loginVC = [[QCLoginVC alloc]init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        } onQueue:nil];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH(_tableView)/8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                QCNewMessageVC *newMessageVC = [[QCNewMessageVC alloc]init];
                [self.navigationController pushViewController:newMessageVC animated:YES];
            }
            if (indexPath.row == 1) {
                QCChatSettingVC *chatSettingVC = [[QCChatSettingVC alloc]init];
                [self.navigationController pushViewController:chatSettingVC animated:YES];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                QCHFMoreVC * vc = [[QCHFMoreVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定清理缓存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 3:
            if (indexPath.row == 0) {
                QCAboutQOOCOOVC *aboutQOOCOOVC = [[QCAboutQOOCOOVC alloc]init];
                [self.navigationController pushViewController:aboutQOOCOOVC animated:YES];
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    cell.textLabel.text = [[_tableView.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:(WIDTH(_tableView)/8)/3-1];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _count ++;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 2) {
        temSize = [UILabel new];
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            float CacheSize = totalSize;
            temSize.text = [NSString stringWithFormat:@"%.2fM",CacheSize/1024/1024];
        }];
        temSize.font = [UIFont systemFontOfSize:12];
        temSize.textAlignment = NSTextAlignmentCenter;
        temSize.textColor = [UIColor colorWithHexString:@"666666"];
        temSize.frame = CGRectMake(0, 0, 60, 30);
        cell.accessoryView = temSize;
    }
    
    return cell;
}

#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        CZLog(@"清理缓存");
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                float CacheSize = totalSize;
                temSize.text = [NSString stringWithFormat:@"%.2fM",CacheSize/1024/1024];
            }];
        }];
    }
}


@end
