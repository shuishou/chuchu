//
//  QCEncounterViewController.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/11.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCEncounterViewController.h"
#import "QCHFUserModel.h"
#import "QCHFTheUserCell.h"

#import "SRRefreshView.h"
#import "QCUserViewController2.h"
@interface QCEncounterViewController ()<SRRefreshDelegate>
{
    BOOL isFriends;
}
@property (strong, nonatomic) NSMutableArray * isfriendArr;

@property (nonatomic, strong) SRRefreshView * slimeView;
@end

@implementation QCEncounterViewController
@dynamic tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"偶遇";
    self.view.backgroundColor = kGlobalBackGroundColor;
    self.isfriendArr = [NSMutableArray array];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.slimeView];
    
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:FRIEND_OUYU parameter:nil success:^(id response) {
        NSArray * array = [QCHFUserModel mj_objectArrayWithKeyValuesArray:response];
        [_isfriendArr removeAllObjects];
        if (array.count > 0) {
            self.tableView.data = [array mutableCopy];
            for (QCHFUserModel * models in self.tableView.data) {
                [_isfriendArr addObject:models.isFriends];
            }
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        //
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 懒加载
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

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGRect rect = self.view.bounds;
    rect.origin.y += 64;
    rect.size.height -= 64;
    self.tableView.frame = rect;
    [_slimeView scrollViewDidEndDraging];
}

//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self loadData];
    [_slimeView endRefresh];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableView.data.count > 0) {
        return self.tableView.data.count;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:self.tableView];
    cell.searchLine.hidden = YES;
    if (self.tableView.data.count > 0) {
        QCHFUserModel * models = self.tableView.data[indexPath.row];
        [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:models.avatarUrl] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
        if (models.sex==0) {
            cell.theSexIge.image=[UIImage imageNamed:@"found_icon_man"];

        }else if(models.sex==1){
                        cell.theSexIge.image=[UIImage imageNamed:@"LJ_con_woman"];

                    
        }
        if (models.age==nil) {
            cell.age.text=@"0岁";
            
        }else{
            cell.age.text=[NSString stringWithFormat:@"%@岁",models.age];
        }


        cell.nicknameLabel.text = models.nickname;
        if ([_isfriendArr[indexPath.row] boolValue]) {
            cell.isFriendBu.selected = YES;
        }
        else
        {
            cell.isFriendBu.selected = NO;
        }
        cell.isFriendBu.tag = indexPath.row;
        
        if (models.marks.length > 0) {
            NSArray * markArr = [models.marks componentsSeparatedByString:@","];
            
            if (markArr.count > 2) {
                cell.marksLabel1.text = markArr[markArr.count-1];
                cell.marksLabel2.text = markArr[markArr.count-2];
                if (models.distance!=nil) {
                    cell.marksLabel3.text =   models.distance;
                }else{
                cell.marksLabel3.text = markArr[markArr.count-3];
                }
            }
            else if (markArr.count > 1)
            {
                cell.marksLabel1.text = markArr[markArr.count-1];
                if (models.distance!=nil) {
                    cell.marksLabel2.text =   models.distance;
                }else{

                cell.marksLabel2.text = markArr[markArr.count-2];
                }
            }
            else
            {
                if (models.distance!=nil) {
                    cell.marksLabel1.text =   models.distance;
                }else{
                    cell.marksLabel1.text = markArr[0];
                }

            }
            
            if (cell.marksLabel1.text.length < 1) {
                cell.markView1.hidden = YES;
            }
            if (cell.marksLabel2.text.length < 1) {
                cell.markView2.hidden = YES;
            }
            if (cell.marksLabel3.text.length < 1) {
                cell.markView3.hidden = YES;
            }
        }
        else
        {
            cell.markView1.hidden = YES;
            cell.markView2.hidden = YES;
            cell.markView3.hidden = YES;
        }
        
        [cell.isFriendBu actionButton:^(UIButton *sender){
#pragma -mark 根据判断数组,获取对应的 BOOL 值
            isFriends = [_isfriendArr[cell.isFriendBu.tag] boolValue];
            
            if (isFriends)
            {
                [self isfriendRemoveAction:models button:cell.isFriendBu];
            }
            else
            {
                [self isfriendAddAction:models button:cell.isFriendBu];
            }
            
        }];
    }
    
    return cell;
}

#pragma -mark 关注
- (void)isfriendAddAction:(QCHFUserModel *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
    bu.selected = YES;
    isFriends = YES;
#pragma -mark 一旦 BOOL 值有改变,通过 button的 tag标记数组里对应的下标进行替换数组的元素
    [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
    
    [NetworkManager requestWithURL:FRIEND_ADD parameter:dics success:^(id response) {
        //        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
    }];
}

#pragma -mark 取消关注
- (void)isfriendRemoveAction:(QCHFUserModel *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
    bu.selected = NO;
    isFriends = NO;
    [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
    [NetworkManager requestWithURL:FRIEND_REMOVEFOCUS parameter:dics success:^(id response) {
        //        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCUserViewController2*user=[[QCUserViewController2 alloc]init];
    QCHFUserModel*um=self.tableView.data[indexPath.row] ;
    user.uid =[um.uid longLongValue];
    user.isFriend=[_isfriendArr[indexPath.row] boolValue];
    [self.navigationController pushViewController:user animated:YES];
}


@end
