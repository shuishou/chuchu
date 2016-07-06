//
//  QCShakeViewController.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/9.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCShakeViewController.h"
#import "QCHFTheUserCell.h"

#import "QCHFShakeMarksModel.h"
#import "QCHFUserModel.h"
#import "QCUserViewController2.h"
#import <AVFoundation/AVFoundation.h>
#define SOUNDID  1109  //1012 -iphone   1152 ipad  1109 ipad
@interface QCShakeViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    UIView * headerView;
    UITableView * TableViews;
    BOOL isFriends;
    BOOL isDelete;
    
    

}
/**标签*/
@property (strong, nonatomic) NSMutableArray * marksArray;
/**数据*/
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * isfriendArr;
@end

@implementation QCShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"摇一摇";
    self.marksArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.isfriendArr = [NSMutableArray array];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    // Do any additional setup after loading the view.
    [self initMarksData];
}

#pragma mark yaoyiyao
- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [_marksArray removeAllObjects];
    [headerView removeFromSuperview];
    [TableViews removeFromSuperview];
    
    
    
    [self initMarksData];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //播放声音
  
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shake.ogg" withExtension:nil];
//    SystemSoundID soundID = 0;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(SOUNDID);
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSLog(@"stop");
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    NSLog(@"取消");
}

#pragma -mark 获取摇一摇标签数据
- (void)initMarksData
{
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETMARKS parameter:nil success:^(id response) {
        NSArray * arr = [QCHFShakeMarksModel mj_objectArrayWithKeyValuesArray:response];
        if (arr.count > 0) {
            self.marksArray = [NSMutableArray arrayWithArray:arr];
            [self initHeaderView];
            [self initTabelView];
            [MBProgressHUD hideHUD];
        }
        else
        {
            [MBProgressHUD hideHUD];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 通过标签搜索好友
- (void)searchByMarksUsers:(NSString *)mark
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"marks"] = mark;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:SEARCHBYSHAKE parameter:dic success:^(id response) {
        NSArray * arr = [QCHFUserModel mj_objectArrayWithKeyValuesArray:response];
        [_isfriendArr removeAllObjects];
        if (arr.count > 0) {
            self.dataArray = [NSMutableArray arrayWithArray:arr];
            for (QCHFUserModel * models in self.dataArray) {
                [_isfriendArr addObject:models.isFriends];
            }
            [MBProgressHUD hideHUD];
            [TableViews reloadData];
        }
        else
        {
            [MBProgressHUD hideHUD];
            [TableViews reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

- (void)initHeaderView
{
    int HFHeghts;
    
    if (self.marksArray.count%3 == 0) {
        HFHeghts = (int)self.marksArray.count/3;
    }
    else
    {
        HFHeghts = (int)self.marksArray.count/3+1;
    }
    headerView = [[UIView alloc] initWithFrame:CGRectMake(8, 72, WIDTH(self.view)-16, (WIDTH(self.view)/13+16)*HFHeghts)];
    headerView.layer.masksToBounds = YES;
    headerView.layer.cornerRadius = 5;
    headerView.backgroundColor = [UIColor whiteColor];
    
    if (isDelete) {
        for (int i = 1; i < self.marksArray.count+1; i++) {
            UITapGestureRecognizer * cancelDeleteTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelDeleteMarksTapS:)];
            [headerView addGestureRecognizer:cancelDeleteTap];
            
            
            UILabel * markLabel = [[UILabel alloc] init];
            markLabel.frame = CGRectMake(WIDTH(headerView)/3*((i-1)%3)+7, HEIGHT(headerView)/HFHeghts*((i-1)/3)+8, WIDTH(headerView)/3-14, WIDTH(self.view)/13);
            markLabel.font = [UIFont systemFontOfSize:13];
            markLabel.textColor = RandomColor;
            markLabel.textAlignment = NSTextAlignmentCenter;
            markLabel.layer.borderWidth = 0.5;
            markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
            markLabel.layer.masksToBounds = YES;
            markLabel.layer.cornerRadius = 3;
            
            QCHFShakeMarksModel * model = self.marksArray[i-1];
            markLabel.text = model.title;
            markLabel.userInteractionEnabled = YES;
            markLabel.tag = i-1;
            
            UITapGestureRecognizer * HFCityTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MarksTap:)];
            [markLabel addGestureRecognizer:HFCityTap];
            
#pragma -mark 轻点删除
            UITapGestureRecognizer * deleteTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteMarksTapS:)];
            [markLabel addGestureRecognizer:deleteTap];
            
            UIImageView * deImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(markLabel)-13, -2, 15, 15)];
            [deImage setImage:[UIImage imageNamed:@"but_deletelatel"]];
            [markLabel addSubview:deImage];
            
            
            [headerView addSubview:markLabel];
        }

    }
    else
    {
        for (int i = 1; i < self.marksArray.count+1; i++) {
            
            UILabel * markLabel = [[UILabel alloc] init];
            markLabel.frame = CGRectMake(WIDTH(headerView)/3*((i-1)%3)+7, (HEIGHT(headerView))/HFHeghts*((i-1)/3)+8, WIDTH(headerView)/3-14, WIDTH(self.view)/13);
            markLabel.font = [UIFont systemFontOfSize:13];
            markLabel.textColor = RandomColor;
            markLabel.textAlignment = NSTextAlignmentCenter;
            markLabel.layer.borderWidth = 0.5;
            markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
            markLabel.layer.masksToBounds = YES;
            markLabel.layer.cornerRadius = 3;
            
            QCHFShakeMarksModel * model = self.marksArray[i-1];
            markLabel.text = model.title;
            markLabel.userInteractionEnabled = YES;
            markLabel.tag = i-1;
            
            UITapGestureRecognizer * HFCityTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MarksTap:)];
            [markLabel addGestureRecognizer:HFCityTap];
            
#pragma -mark 长按删除
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtn:)];
            [longPressGesture setDelegate:self];
            //允许15秒中运动
            longPressGesture.allowableMovement=NO;
            //所需触摸1次
            longPressGesture.numberOfTouchesRequired=1;
            longPressGesture.minimumPressDuration=0.5;//默认0.5秒
            [markLabel addGestureRecognizer:longPressGesture];
            
            [headerView addSubview:markLabel];
        }

    }
    
    [self.view addSubview:headerView];
}

- (void)MarksTap:(UITapGestureRecognizer *)tap
{
    QCHFShakeMarksModel * model = self.marksArray[tap.view.tag];
    [self searchByMarksUsers:model.title];
}

#pragma -mark 长按触发删除
-(void)longPressBtn:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        //长按事件开始"
        //do something
        
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //长按事件结束
        //do something
        isDelete = YES;
        [headerView removeFromSuperview];
        [self initHeaderView];
    }
}

#pragma -mark 轻点删除
- (void)deleteMarksTapS:(UITapGestureRecognizer *)taps
{
//    QCHFShakeMarksModel * modeld = self.marksArray[taps.view.tag];
    [self.marksArray removeObjectAtIndex:taps.view.tag];
    [headerView removeFromSuperview];
    [self initHeaderView];
    TableViews.frame = CGRectMake(0, MaxY(headerView)+12, WIDTH(self.view), HEIGHT(self.view)-(MaxY(headerView)+16));
}

#pragma -mark 点击空白处取消删除状态
- (void)cancelDeleteMarksTapS:(UITapGestureRecognizer *)taps
{
    isDelete = NO;
    [headerView removeFromSuperview];
    [self initHeaderView];
}

- (void)initTabelView
{
    TableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(headerView)+12, WIDTH(self.view), HEIGHT(self.view)-(MaxY(headerView)+16)) style:UITableViewStylePlain];
    TableViews.delegate = self;
    TableViews.dataSource = self;
    TableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    TableViews.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    [self.view addSubview:TableViews];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count>0) {
        return self.dataArray.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:TableViews];
    cell.searchLine.hidden = YES;
    if (self.dataArray.count > 0) {
        QCHFUserModel * models = self.dataArray[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCUserViewController2*user=[[QCUserViewController2 alloc]init];
    QCHFUserModel*um=self.dataArray[indexPath.row] ;
    user.uid =[um.uid longLongValue];
    user.isFriend=[_isfriendArr[indexPath.row] boolValue];
    [self.navigationController pushViewController:user animated:YES];
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
//        [self searchByMarksUsers:];
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
