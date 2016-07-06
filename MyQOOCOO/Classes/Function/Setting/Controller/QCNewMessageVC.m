//
//  QCNewMessageVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/1.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCNewMessageVC.h"

@interface QCNewMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    QCBaseTableView *_tableView;
}
@property ( nonatomic , assign) int count;
@property (strong, nonatomic) NSUserDefaults * QCSetUserDe;
@end

@implementation QCNewMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _QCSetUserDe = [NSUserDefaults standardUserDefaults];
    
    self.count = 0;
    self.navigationItem.title = @"新消息通知";
    self.navigationItem.rightBarButtonItem = nil;
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.data = [[NSMutableArray alloc]initWithArray:@[@[@"新消息通知",@"通知显示消息详情"],@[@"声音",@"振动"],@[@"内圈更新"], @[@"外圈更新"]]];
    [self.view addSubview:_tableView];
}
#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2 || section == 3) {
        return 1;
    }
    else
    {
        
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2 || section == 3) {
        return 0;
    }
    else
    {
        return 20;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    else
    {
        return WIDTH(_tableView)/8-4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * newsMessage = [_QCSetUserDe objectForKey:@"设置消息通知"];

    if (newsMessage.length == 0) {
        return WIDTH(_tableView)/8;
    }
    else
    {
        if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3) {
            return WIDTH(_tableView)/8;
        }
        else
        {
            return 0;
        }
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * HFFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_tableView), WIDTH(_tableView)/8-4)];
    HFFooterView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, WIDTH(HFFooterView)-28, HEIGHT(HFFooterView))];
    label.textColor = UIColorFromRGB(0x999999);
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:(WIDTH(_tableView)/8)/3-1];
    switch (section) {
        case 0:
        {
            label.text = @"若关闭,当收到消息时,通知提示将不显示发信人和内容摘要";
            [HFFooterView addSubview:label];
        }
            break;
        case 2:
        {
            label.text = @"若关闭,如果内圈更新时,不再出现红点提示";
            [HFFooterView addSubview:label];
            
            UIImageView * HFLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(HFFooterView)-0.5, WIDTH(_tableView), 0.5)];
            HFLine.backgroundColor = kColorRGBA(220, 220, 220, 1);
            [HFFooterView addSubview:HFLine];
        }
            break;
        case 3:
        {
            label.text = @"若关闭,如果外圈更新时,不再出现红点提示";
            [HFFooterView addSubview:label];
        }
            break;
            
        default:
            break;
    }
    return HFFooterView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    NSString * newsMessage = [_QCSetUserDe objectForKey:@"设置消息通知"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        UIImageView * HFLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, WIDTH(_tableView)/8-0.5, WIDTH(_tableView), 0.5)];
        HFLine.backgroundColor = kColorRGBA(220, 220, 220, 1);
        
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    [cell.contentView addSubview:HFLine];
                }
            }
                break;
            case 1:
            {
                [cell.contentView addSubview:HFLine];
            }
                break;
            default:
                break;
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[_tableView.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:(WIDTH(_tableView)/8)/3-1];
    
    UISwitch *qcSwtich;
    if (!qcSwtich) {
        qcSwtich = [[UISwitch alloc] init];
    }
    
    qcSwtich.tag = _count;
    
    
    switch (_count) {
        case 0:
        {
            NSString * values = [_QCSetUserDe objectForKey:@"设置消息通知"];
            if (values) {
                [qcSwtich setOn:NO animated:YES];
            }
            else
            {
                [qcSwtich setOn:YES animated:YES];
            }
        }
            break;
        case 1:
        {
            NSString * values = [_QCSetUserDe objectForKey:@"设置通知显示"];
            if (values) {
                [qcSwtich setOn:NO animated:YES];
            }
            else
            {
                [qcSwtich setOn:YES animated:YES];
            }
        }
            break;
        case 2:
        {
            NSString * values = [_QCSetUserDe objectForKey:@"设置声音"];
            if (values) {
                [qcSwtich setOn:NO animated:YES];
            }
            else
            {
                [qcSwtich setOn:YES animated:YES];
            }
        }
            break;
        case 3:
        {
            NSString * values = [_QCSetUserDe objectForKey:@"设置振动"];
            if (values) {
                [qcSwtich setOn:NO animated:YES];
            }
            else
            {
                [qcSwtich setOn:YES animated:YES];
            }
        }
            break;
        case 4:
        {
            NSString * values = [_QCSetUserDe objectForKey:@"设置内圈更新"];
            if (values) {
                [qcSwtich setOn:NO animated:YES];
            }
            else
            {
                [qcSwtich setOn:YES animated:YES];
            }
        }
            break;
        case 5:
        {
            NSString * values = [_QCSetUserDe objectForKey:@"设置外圈消息"];
            if (values) {
                [qcSwtich setOn:NO animated:YES];
            }
            else
            {
                [qcSwtich setOn:YES animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
    _count ++;
    
    
    [qcSwtich addTarget:self action:@selector(qcSwitchChange:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = qcSwtich;
    
    if (newsMessage.length > 0) {
        if (indexPath.section == 1) {
            cell.hidden = YES;
        }
    }
   
    return cell;
}
#pragma mark - qcSwitch
-(void)qcSwitchChange:(UISwitch *)sender{
//    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UISwitch *qcSwitch = (UISwitch *)sender;
    
    switch (sender.tag) {
            //新消息通知
        case 0:
        {
            //打开
            if ([qcSwitch isOn])
            {
                [_QCSetUserDe removeObjectForKey:@"设置消息通知"];
            }
            //关闭
            else
            {
                [_QCSetUserDe setValue:@"0" forKey:@"设置消息通知"];
                [_QCSetUserDe setValue:@"0" forKey:@"设置声音"];
                [_QCSetUserDe setValue:@"0" forKey:@"设置振动"];
            }
            
            _count = 0;
            [_tableView reloadData];
        }
            break;
        case 1:
        {
            //打开
            if ([qcSwitch isOn])
            {
                [_QCSetUserDe removeObjectForKey:@"设置通知显示"];
            }
            //关闭
            else
            {
                [_QCSetUserDe setValue:@"0" forKey:@"设置通知显示"];
            }
        }
            break;
        case 2:
        {
            //打开
            if ([qcSwitch isOn])
            {
                [_QCSetUserDe removeObjectForKey:@"设置声音"];
            }
            //关闭
            else
            {
                [_QCSetUserDe setValue:@"0" forKey:@"设置声音"];
            }
        }
            break;
        case 3:
        {
            //打开
            if ([qcSwitch isOn])
            {
                [_QCSetUserDe removeObjectForKey:@"设置振动"];
            }
            //关闭
            else
            {
                [_QCSetUserDe setValue:@"0" forKey:@"设置振动"];
            }
        }
            break;
        case 4:
        {
            //打开
            if ([qcSwitch isOn])
            {
                [_QCSetUserDe removeObjectForKey:@"设置内圈更新"];
            }
            //关闭
            else
            {
                [_QCSetUserDe setValue:@"0" forKey:@"设置内圈更新"];
            }
        }
            break;
        case 5:
        {
            //打开
            if ([qcSwitch isOn])
            {
                [_QCSetUserDe removeObjectForKey:@"设置外圈消息"];
            }
            //关闭
            else
            {
                [_QCSetUserDe setValue:@"0" forKey:@"设置外圈消息"];
            }
        }
            break;
        default:
            break;
    }
    
    if ([qcSwitch isOn]) {
        CZLog(@"%zd",sender.tag);
    }else {
        
    }
    
}


@end
