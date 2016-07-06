//
//  QCChatSettingVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/2.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "QCChatSettingVC.h"

#import "QCHFChatBackUpAndRestoreVC.h"

@interface QCChatSettingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    QCBaseTableView *_tableView;
}
@property ( nonatomic , assign) int count;
@property (strong, nonatomic) NSUserDefaults * QCSetUserDe1;
@end

@implementation QCChatSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _QCSetUserDe1 = [NSUserDefaults standardUserDefaults];
    
    self.count = 0;
    self.navigationItem.title = @"聊天";
    self.navigationItem.rightBarButtonItem = nil;
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.data = [[NSMutableArray alloc]initWithArray:@[@[@"使用听筒播放语音"],@[@"聊天记录备份和恢复",@"清空聊天记录"]]];
    [self.view addSubview:_tableView];
}
#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 2;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 20;
    }
    else
    {
        return WIDTH(_tableView)/8-4;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH(_tableView)/8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                UIAlertController *alert = [[UIAlertController alloc] init];
                //    self.alert = alert;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    alert.popoverPresentationController.sourceView = _tableView;
                }
                
                __weak QCChatSettingVC * chatSet = self;
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    CZLog(@"点击取消");
                }];
                
                
                UIAlertAction *backUpAction = [UIAlertAction actionWithTitle:@"备份" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    CZLog(@"点击备份");
                    
                    QCHFChatBackUpAndRestoreVC * vc = [[QCHFChatBackUpAndRestoreVC alloc] init];
                    vc.title = @"备份";
                    vc.isBackUp = @1;
                    [chatSet.navigationController pushViewController:vc animated:YES];
                }];
                UIAlertAction *restoreAction = [UIAlertAction actionWithTitle:@"恢复" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    CZLog(@"点击恢复");
                    
                    QCHFChatBackUpAndRestoreVC * vc = [[QCHFChatBackUpAndRestoreVC alloc] init];
                    vc.title = @"恢复";
                    vc.isBackUp = @0;
                    [chatSet.navigationController pushViewController:vc animated:YES];
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:backUpAction];
                [alert addAction:restoreAction];
                
                
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            case 1:
            {
                // deleteMessage,是否删除会话中的message，YES为删除
                [[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:YES append2Chat:YES];
                [_QCSetUserDe1 setObject:@"" forKey:@"打开恢复"];
                [OMGToast showText:@"所有记录已经清除"];
            }
                break;
            default:
                break;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * HFHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_tableView), WIDTH(_tableView)/8-4)];
    
    if (section == 1) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 0, WIDTH(HFHeader)-29, HEIGHT(HFHeader))];
        label.font = [UIFont systemFontOfSize:(WIDTH(_tableView)/8)/3-1];
        label.textColor = UIColorFromRGB(0x999999);
        label.text = @"聊天消息";
        [HFHeader addSubview:label];
    }
    
    return HFHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            UIImageView * HFLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, WIDTH(_tableView)/8-0.5, WIDTH(_tableView), 0.5)];
            HFLine.backgroundColor = kColorRGBA(220, 220, 220, 1);
            [cell.contentView addSubview:HFLine];
        }
    }
   
    
    cell.textLabel.text = [[_tableView.data objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:(WIDTH(_tableView)/8)/3-1];
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *qcSwtich = [[UISwitch alloc]init];
        qcSwtich.tag = _count;
        NSString * values = [_QCSetUserDe1 objectForKey:@"设置使用听筒播放"];
        if (values) {
            [qcSwtich setOn:NO animated:YES];
        }
        else
        {
            [qcSwtich setOn:YES animated:YES];
        }
        _count ++;
        [qcSwtich addTarget:self action:@selector(qcSwitchChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = qcSwtich;
    }
    
    return cell;
}
#pragma mark - qcSwitch
-(void)qcSwitchChange:(UISwitch *)sender{
    UISwitch *qcSwitch = (UISwitch *)sender;
    //打开
    if ([qcSwitch isOn])
    {
        [_QCSetUserDe1 removeObjectForKey:@"设置使用听筒播放"];
    }
    //关闭
    else
    {
        [_QCSetUserDe1 setValue:@"0" forKey:@"设置使用听筒播放"];
    }
    
}


@end
