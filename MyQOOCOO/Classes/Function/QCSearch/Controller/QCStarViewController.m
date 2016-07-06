//
//  QCStarViewController.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/12.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCStarViewController.h"
#import "QCHFUserModel.h"
#import "QCHFTheUserCell.h"
#import "QCHFShakeMarksModel.h"

#import "QCUserViewController2.h"
@interface QCStarViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>
{
    UIView * headerView;
    UITableView * TableViews;
    BOOL isFriends;
    BOOL isDelete;
    
    UIView * markNameV;
    UITextView * textViews;
    UIView * titleView;
    
    NSString * markNames;
}
/**标签数组*/
@property (strong, nonatomic) NSMutableArray * marksArray;
/**关注数组*/
@property (strong, nonatomic) NSMutableArray * isfriendArr;
/**用户数组*/
@property (strong, nonatomic) NSMutableArray * usersDataArray;
@end

@implementation QCStarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"潮星";
    self.view.backgroundColor = kGlobalBackGroundColor;
    self.marksArray = [NSMutableArray array];
    self.isfriendArr = [NSMutableArray array];
    self.usersDataArray = [NSMutableArray array];
    isDelete = NO;

    [self initMarkSData];
    [self initTabelView];
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationded:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveed:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma -mark 查询潮星标签
- (void)initMarkSData
{
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETMARKLIST parameter:nil success:^(id response) {
        NSArray * arry = [QCHFShakeMarksModel mj_objectArrayWithKeyValuesArray:response];
        if (arry.count>0) {
            self.marksArray = [NSMutableArray arrayWithArray:arry];
            [headerView removeFromSuperview];
            [self initHeaderView];
            [self loadData];
        }
        else
        {
            [headerView removeFromSuperview];
            [self initHeaderView];
            [self loadData];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 潮星推荐用户
-(void)loadData{
    
    [NetworkManager requestWithURL:FRIEND_STAR_RECOMMEND parameter:nil success:^(id response) {
        NSArray * arr = [QCHFUserModel mj_objectArrayWithKeyValuesArray:response];
        [_isfriendArr removeAllObjects];
        [self.usersDataArray removeAllObjects];
        if (arr.count > 0) {
            self.usersDataArray = [NSMutableArray arrayWithArray:arr];
            for (QCHFUserModel * models in self.usersDataArray) {
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
        //
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

- (void)initHeaderView
{
    UIView * selectMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 45)];
    selectMarkView.backgroundColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, HEIGHT(selectMarkView)*2/5, 60, 15)];
    label.text = @"选择标签";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    [selectMarkView addSubview:label];
    
    int HFHeghts;
        if (self.marksArray.count == 0) {
            HFHeghts = 1;
        }
        else
        {
            HFHeghts = (int)self.marksArray.count/3+1;
        }
        
    UIView * marksView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(selectMarkView), WIDTH(self.view), 35*HFHeghts+10)];
    marksView.layer.masksToBounds = YES;
    marksView.layer.cornerRadius = 5;
    marksView.backgroundColor = [UIColor whiteColor];
    
    if (isDelete) {
        UITapGestureRecognizer * cancelDeleteTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelDeleteMarksTapS:)];
        [headerView addGestureRecognizer:cancelDeleteTap];
        
        for (int i = 1; i < self.marksArray.count+1; i++) {
            
            UILabel * markLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(marksView)/3*((i-1)%3)+10, (HEIGHT(marksView)-10)/HFHeghts*((i-1)/3)+10, WIDTH(marksView)/3-20, 25)];
            
            markLabel.textAlignment = NSTextAlignmentCenter;
            markLabel.font = [UIFont systemFontOfSize:13];
            markLabel.textColor = RandomColor;
            markLabel.layer.borderWidth = 0.5;
            markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
            markLabel.layer.masksToBounds = YES;
            markLabel.layer.cornerRadius = 3;
            markLabel.userInteractionEnabled = YES;
            
            QCHFShakeMarksModel * model = self.marksArray[i-1];
            markLabel.text = model.title;
            markLabel.tag = i-1;
#pragma -mark 轻点删除
            UITapGestureRecognizer * deleteTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteMarksTapS:)];
            [markLabel addGestureRecognizer:deleteTap];
            
            UIImageView * deImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(markLabel)-13, -2, 15, 15)];
            [deImage setImage:[UIImage imageNamed:@"but_deletelatel"]];
            [markLabel addSubview:deImage];
            
            [marksView addSubview:markLabel];
        }

    }
    else
    {
        for (int i = 1; i < self.marksArray.count+1; i++) {
            
            UILabel * markLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(marksView)/3*((i-1)%3)+10, (HEIGHT(marksView)-10)/HFHeghts*((i-1)/3)+10, WIDTH(marksView)/3-20, 25)];
            
            markLabel.textAlignment = NSTextAlignmentCenter;
            markLabel.font = [UIFont systemFontOfSize:13];
            markLabel.textColor = RandomColor;
            markLabel.layer.borderWidth = 0.5;
            markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
            markLabel.layer.masksToBounds = YES;
            markLabel.layer.cornerRadius = 3;
            markLabel.userInteractionEnabled = YES;
            
            QCHFShakeMarksModel * model = self.marksArray[i-1];
            markLabel.text = model.title;
            markLabel.tag = i-1;
#pragma -mark 轻点添加
            UITapGestureRecognizer * addTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MarksTapS:)];
            [markLabel addGestureRecognizer:addTap];
            
#pragma -mark 长按删除
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtn:)];
            [longPressGesture setDelegate:self];
            //允许15秒中运动
            longPressGesture.allowableMovement=NO;
            //所需触摸1次
            longPressGesture.numberOfTouchesRequired=1;
            longPressGesture.minimumPressDuration=0.5;//默认0.5秒
            [markLabel addGestureRecognizer:longPressGesture];
            
            [marksView addSubview:markLabel];
        }

    }
    
    //添加标签按钮
    UIButton * addmarkBu = [UIButton buttonWithType:UIButtonTypeCustom];
    addmarkBu.frame = CGRectMake(WIDTH(marksView)/3*(((self.marksArray.count+1)-1)%3)+10, (HEIGHT(marksView)-10)/HFHeghts*(((self.marksArray.count+1)-1)/3)+10, WIDTH(marksView)/3-20, 25);
    [addmarkBu setImage:[UIImage imageNamed:@"Add_tags"] forState:UIControlStateNormal];
    [addmarkBu actionButton:^(UIButton *sender) {
        [self addmarkBu:addmarkBu];
    }];
    [marksView addSubview:addmarkBu];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(selectMarkView) + HEIGHT(marksView))];
    [headerView addSubview:selectMarkView];
    [headerView addSubview:marksView];

    TableViews.tableHeaderView = headerView;
}

- (void)initTabelView
{
    TableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    TableViews.delegate = self;
    TableViews.dataSource = self;
    TableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    TableViews.backgroundColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];
    
    [self.view addSubview:TableViews];
}

#pragma -mark 标签搜索
- (void)MarksTapS:(UITapGestureRecognizer *)tap
{
    QCHFShakeMarksModel * model = self.marksArray[tap.view.tag];
    [self searchByStar:model.title];
}

- (void)searchByStar:(NSString *)MarkName
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"marks"] = MarkName;
    
    [NetworkManager requestWithURL:FRIEND_STAR parameter:dic success:^(id response) {
        NSArray * arr = [QCHFUserModel mj_objectArrayWithKeyValuesArray:response];
        if (arr.count > 0) {
            [_isfriendArr removeAllObjects];
            [self.usersDataArray removeAllObjects];
            self.usersDataArray = [NSMutableArray arrayWithArray:arr];
            for (QCHFUserModel * models in self.usersDataArray) {
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
    }];
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

- (void)deleteMarksTapS:(UITapGestureRecognizer *)taps
{
    QCHFShakeMarksModel * modeld = self.marksArray[taps.view.tag];
    [self deleteStarMark:modeld.id];
    [self.marksArray removeObjectAtIndex:taps.view.tag];
    [headerView removeFromSuperview];
    isDelete=NO;
    [self initHeaderView];
}

- (void)deleteStarMark:(NSString *)MarkId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"markId"] = MarkId;
    
    [NetworkManager requestWithURL:DELETESTARMARK parameter:dic success:^(id response) {
        CZLog(@"删除成功");
        isDelete = NO;
        [TableViews reloadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma -mark 点击空白处取消删除状态
- (void)cancelDeleteMarksTapS:(UITapGestureRecognizer *)taps
{
    isDelete = NO;
    [headerView removeFromSuperview];
    [self initHeaderView];
}

#pragma -mark 添加标签
- (void)addmarkBu:(UIButton *)bu
{
    [self initMarkName];
}

- (void)keyBoardWillShowNotificationded:(NSNotification *)not
{
    //获取键盘高度
    NSDictionary *dic = not.userInfo;
    //获取坐标
    CGRect rc = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    
    //调整输入框的位置
    [UIView animateWithDuration:0.5 animations:^{
        titleView.frame = CGRectMake(X(titleView), HEIGHT(markNameV)-f-HEIGHT(titleView), WIDTH(titleView), HEIGHT(titleView));
    }];
}
//键盘消失的方法
-(void)keyBoardRemoveed:(NSNotification *)not
{
    //调整输入框的位置
    [UIView animateWithDuration:0.5 animations:^{
        titleView.frame = CGRectMake(30, (HEIGHT(markNameV)-HEIGHT(markNameV)/3)/2, WIDTH(markNameV)-60, HEIGHT(markNameV)/3);
    }];
}

- (void)addStarMark:(NSString *)markName
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"title"] = markName;
    
    QCHFShakeMarksModel * model = [[QCHFShakeMarksModel alloc] init];
    model.title = markName;
    [NetworkManager requestWithURL:ADDSTARMARK parameter:dic success:^(id response) {
        [self initMarkSData];
        [markNameV removeFromSuperview];
        CZLog(@"添加成功");
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma -mark 填写标签名
- (void)initMarkName
{
    markNameV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    markNameV.backgroundColor = kColorRGBA(52,52,52,0.3);
    markNameV.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:markNameV];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(30, (HEIGHT(markNameV)-HEIGHT(markNameV)/3)/2, WIDTH(markNameV)-60, HEIGHT(markNameV)/3)];
    titleView.backgroundColor = [UIColor whiteColor];
    [markNameV addSubview:titleView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(titleView), HEIGHT(titleView)/5)];
    label.text = @"请输入标签内容";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/5];
    [titleView addSubview:label];
    
    textViews = [[UITextView alloc] initWithFrame:CGRectMake(25, HEIGHT(titleView)/2-HEIGHT(titleView)/8, WIDTH(titleView)-50, HEIGHT(titleView)/4)];
    //    textView.backgroundColor = [UIColor greenColor];
    textViews.font = [UIFont systemFontOfSize:HEIGHT(textViews)/3];
    textViews.textColor = [UIColor colorWithHexString:@"333333"];
    textViews.delegate = self;
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    UILabel * placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH(textViews)-10, HEIGHT(textViews)/3)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:HEIGHT(placeHolderLabel)];
    placeHolderLabel.textColor = [UIColor colorWithHexString:@"999999"];
    placeHolderLabel.backgroundColor = [UIColor whiteColor];
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"(请输入名称)";
    [textViews addSubview:placeHolderLabel];
    if ([[textViews text] length] == 0) {
        [[textViews viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[textViews viewWithTag:999] setAlpha:0];
    }
    [titleView addSubview:textViews];
    
    UIButton * cancelBu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBu.frame = CGRectMake(0, HEIGHT(titleView)-HEIGHT(titleView)/5, WIDTH(titleView)/2, HEIGHT(titleView)/5);
    [cancelBu setTitle:@"取消" forState:UIControlStateNormal];
    cancelBu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(cancelBu)*2/5];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [markNameV endEditing:YES];
        markNames = nil;
        [markNameV removeFromSuperview];
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    doneBu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(doneBu)*2/5];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        [markNameV endEditing:YES];
        //得到输入框
        if (markNames.length > 0 && ![markNames isEqualToString:@" "]) {
            [self.view endEditing:YES];
            
            for (QCHFShakeMarksModel * models in self.marksArray) {
                if ([markNames isEqualToString:models.title]) {
                    [OMGToast showText:@"标签名已存在,请换一个试试"];
                    return;
                }
            }
            
           [self addStarMark:markNames];
            
        }
        else
        {
            [OMGToast showText:@"标签名字不能为空"];
        }
        
    }];
    [titleView addSubview:doneBu];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)-HEIGHT(cancelBu)-0.5, WIDTH(titleView), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line];
    
    
#pragma -mark 轻点消失
    UITapGestureRecognizer * dismissTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    [markNameV addGestureRecognizer:dismissTap];
}

//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[textViews text] length] == 0) {
        [[textViews viewWithTag:999] setAlpha:1];
    }
    else {
        [[textViews viewWithTag:999] setAlpha:0];
    }
    
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == textViews) {
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen = 10 - comcatstr.length;
        if (caninputlen >= 0){
            
        }else{
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            if (rg.length > 0)
            {
                NSString *s = [text substringWithRange:rg];
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == textViews) {
        NSString  *nsTextContent = textView.text;
        NSInteger existTextNum = nsTextContent.length;
        
        if (existTextNum > 10)
        {
            //截取到最大位置的字符
            NSString *s = [nsTextContent substringToIndex:10];
            [textView setText:s];
        }
        markNames = textView.text;
    }
}

- (void)dismissTap:(UITapGestureRecognizer *)tap
{
    //    markNameV.hidden = YES;
    [markNameV endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.usersDataArray.count == 0) {
        return 0;
    }else{
        return self.usersDataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * selectMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 45)];
    selectMarkView.backgroundColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, HEIGHT(selectMarkView)*2/5, 60, 15)];
    label.text = @"热门推荐";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    [selectMarkView addSubview:label];
    return selectMarkView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:TableViews];
    cell.searchLine.hidden = YES;
    if (self.usersDataArray.count > 0) {
        QCHFUserModel * models = self.usersDataArray[indexPath.row];
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
                cell.marksLabel3.text = markArr[markArr.count-3];
            }
            else if (markArr.count > 1)
            {
                cell.marksLabel1.text = markArr[markArr.count-1];
                cell.marksLabel2.text = markArr[markArr.count-2];
            }
            else
            {
                cell.marksLabel1.text = markArr[0];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCUserViewController2*user=[[QCUserViewController2 alloc]init];
    QCHFUserModel*um=self.usersDataArray[indexPath.row] ;
    user.uid =[um.uid longLongValue];
    user.isFriend=[_isfriendArr[indexPath.row] boolValue];
    [self.navigationController pushViewController:user animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
@end
