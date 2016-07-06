//
//  QCAboutQOOCOO.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/2.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCAboutQOOCOOVC.h"
#import "QCAboutUsVC.h"
#import "QCSuggestionFeedBackVC.h"

@interface QCAboutQOOCOOVC ()<UITableViewDataSource,UITableViewDelegate>
{
    QCBaseTableView *_tableView;
}
@property ( nonatomic , assign) int count;
@property (nonatomic , strong)UILabel *updateLabel;

@end

@implementation QCAboutQOOCOOVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.navigationItem.title = @"关于库牌";
    self.navigationItem.rightBarButtonItem = nil;
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.data = [[NSMutableArray alloc]initWithArray:@[@"意见反馈",@"关于我们"]];
    [self.view addSubview:_tableView];
    
    [self initGetLastNewly];
    
    _updateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ((WIDTH(_tableView)/8)/3-1)*2, WIDTH(self.view)/8)];
    _updateLabel.textColor = [UIColor redColor];
    _updateLabel.font = [UIFont systemFontOfSize:(WIDTH(_tableView)/8)/3-1];
    
}
#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH(self.view)/8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            QCSuggestionFeedBackVC *suggestioinFeedBackVC = [[QCSuggestionFeedBackVC alloc]init];
            suggestioinFeedBackVC.title = @"意见反馈";
            [self.navigationController pushViewController:suggestioinFeedBackVC animated:YES];
        }
            break;
        case 1:
        {
            QCAboutUsVC *aboutUsVC = [[QCAboutUsVC alloc]init];
            aboutUsVC.title = @"关于出处";
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
        case 2:
        {
//            [self Postpath ];
//            [OMGToast showText:@"已经是最新版"];
        }
            break;
        default:
            break;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return nil;
    }else{
        return nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:(WIDTH(_tableView)/8)/3-1];
    
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _count++;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = _updateLabel;
        
    }else{
        cell.textLabel.text = [_tableView.data objectAtIndex:indexPath.row];
    }
    
    return cell;
}
#pragma mark - qcSwitch
-(void)qcSwitchChange:(UISwitch *)sender{
    UISwitch *qcSwitch = (UISwitch *)sender;
    if ([qcSwitch isOn]) {
        CZLog(@"%zd",sender.tag);
    }else {
        
    }
    
}

- (void)initGetLastNewly
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"version"] = @"1.0";
    dic[@"device"] = @"2";
    
    [NetworkManager requestWithURL:GETLASTNEWLY parameter:dic success:^(id response) {
        
        CZLog(@"%@", response);
        NSDictionary * dic = response;
        
        if (dic) {
            _updateLabel.text = dic[@"version"];

        }
        else
        {
//            [OMGToast showText:@"数据加载错误"];
        }
        [_tableView reloadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma mark -- 获取版本号
-(void)Postpath
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"version"] = @"1.0";
    dic[@"device"] = @"2";
    
    [NetworkManager requestWithURL:GETLASTNEWLY parameter:dic success:^(id response) {
        
        CZLog(@"%@", response);
        NSDictionary * dic = response;
        
        if (dic) {
            NSString*str=  dic[@"version"];
            downloadUrl=dic[@"url"];
            if (![str isEqualToString:[NSUserDefaults versionFromInfoPlist]]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil] ;
                [alert show];
                
            }
        }
        else
        {
            [OMGToast showText:@"已经是最新版"];

        }
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"更新");
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downloadUrl]];
    }else{
        NSLog(@"取消");
    }
    
}


@end
