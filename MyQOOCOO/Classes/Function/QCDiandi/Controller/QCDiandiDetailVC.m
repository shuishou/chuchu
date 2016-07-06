//
//  QCDiandiDetailVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDiandiDetailVC.h"
#import "QCDDDeatailTopView.h"
#import "QCDoodleCommentCell.h"
#import "QCDanDiCommentToolBar.h"
#import "Reply.h"

#import "OkamiPhotoView.h"
#import "QCUserViewController2.h"

@interface QCDiandiDetailVC ()<UITableViewDataSource,UITableViewDelegate,QCDanDiCommentToolBarDelegate,UITextFieldDelegate>
{
    UITableView * tableV;
}

@property(strong, nonatomic)NSMutableArray * commentArr;
@property(assign, nonatomic)long long timestamp;

@property (nonatomic,strong) QCDanDiCommentToolBar * toolBar;

@property (nonatomic,assign)CommentType commentType;//回复类型

@property (nonatomic,assign)  CGFloat distance;

@property (nonatomic,strong) Reply * selectReply;//选中评论的数据对象

@property (nonatomic,strong) NSArray * subArr;//记录字评论数组

@end

@implementation QCDiandiDetailVC

-(NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}


-(void)iconTap:(UITapGestureRecognizer *)gesture{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (self.dianDi.author == sessions.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = self.dianDi.author;
        [self.navigationController pushViewController:user animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点滴详情";
    
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == self.dianDi.user.uid) {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"组-9" highlightedImg:nil target:self action:@selector(deleteDianDi)];
    }
    [self setupForDismissKeyboard];//点击屏幕键盘退下
    self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    self.commentType = CommentTypeTopic;
    
    tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenW, kUIScreenH-49)];
    tableV.backgroundColor = kGlobalBackGroundColor;
//    tableV.rowHeight = UITableViewAutomaticDimension;
//    tableV.estimatedRowHeight = 100;
    
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 44;
    tableV.estimatedRowHeight = 2;

    tableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.showsHorizontalScrollIndicator = NO;
    tableV.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
    [self.view addSubview:tableV];
    
    QCDDDeatailTopView * topV = [QCDDDeatailTopView topView];
    
    NSDictionary * textAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize maxSize = CGSizeMake(kUIScreenW - 12 * 4, MAXFLOAT);
    CGSize textSize = [self.dianDi.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    if (self.dianDi.type==2) {
        topV.frame = CGRectMake(0, 0, kUIScreenW, 192);
    }else if (self.dianDi.coverUrl.length > 0){
        NSArray * tempArr = [self.dianDi.coverUrl componentsSeparatedByString:@","];
        NSMutableArray * Arr = [tempArr mutableCopy];
        CGSize photosSize = [OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
        if (self.dianDi.address) {
           topV.frame = CGRectMake(0, 0, kUIScreenW, 74 + textSize.height + 24 + 20+48+photosSize.height+ 30);
        }else{
           topV.frame = CGRectMake(0, 0, kUIScreenW, 74 + textSize.height + 24 + 48+photosSize.height+30);
        }
    }else{
        if (self.dianDi.address) {
           topV.frame = CGRectMake(0, 0, kUIScreenW, 74 + textSize.height + 24 + 20);
        }else{
           topV.frame = CGRectMake(0, 0, kUIScreenW, 74 + textSize.height + 24);
        }
    }
    
    topV.dianDi = self.dianDi;
    tableV.tableHeaderView = topV;
    topV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopView)];
    [topV addGestureRecognizer:tap];
    
    
    topV.icon.userInteractionEnabled = YES;
    [topV.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap:)]];
    
//    toolBar
    QCDanDiCommentToolBar * toolBar = [QCDanDiCommentToolBar commentToolBar];
    toolBar.frame = CGRectMake(0, kUIScreenH - 49, kUIScreenW, 49);
    [self.view addSubview:toolBar];
    toolBar.dianDi = self.dianDi;
    toolBar.delegate = self;
    toolBar.tf.delegate = self;
    self.toolBar = toolBar;
    
    [self loadCommentData];
    [tableV addHeaderWithTarget:self action:@selector(loadCommentData)];
    [tableV addFooterWithTarget:self action:@selector(moreData)];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [tableV reloadData];
//}

#pragma mark - 键盘通知回调
-(void)keyboardWillChangeFrame:(NSNotification *)n {
    //    拿到键盘弹出后的frame
    CGRect endFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat distance  = endFrame.origin.y  - kUIScreenH;
    self.distance = distance;
    self.toolBar.transform = CGAffineTransformMakeTranslation(0,distance);
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.toolBar.tf resignFirstResponder];
    self.toolBar.transform = CGAffineTransformMakeTranslation(0,-self.distance);
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self sendComment];
    return YES;
}
#pragma mark - QCDanDiCommentToolBarDelegate
-(void)sendBtnClick{
    [self sendComment];
}
//发送评论
-(void)sendComment{
    NSString *content = self.toolBar.tf.text;
    NSDictionary *parameters;
    if (self.commentType == CommentTypeTopic) {
        parameters = @{@"recordId":@(self.dianDi.id),@"content":content,@"toReplyId":@(0),@"replyUid":@(0)};
    }else if (self.commentType == CommentTypeReply){
        ;
        parameters = @{@"recordId":@(self.dianDi.id),@"content":content,@"toReplyId":@(self.selectReply.id),@"replyUid":@(self.selectReply.uid)};
    }
    
    [NetworkManager requestWithURL:RECORD_REPLY parameter:parameters success:^(id response) {
        [OMGToast showText:@"评论成功"];
        //        刷新评论列表数据
        [self loadCommentData];
        self.toolBar.tf.text =nil;
        [self.toolBar.tf resignFirstResponder];
        
        //  滚到最后一行可见
        if (self.commentArr.count>4 && self.commentType == CommentTypeTopic) {
            [self scrollToTop];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@",error);
    }];
}

//    滚到最后一行可见
-(void)scrollToTop{
    //   拿到最后一行
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:self.commentArr.count - 1 inSection:0];
    //    让tableView向上滚到最后一行可见
    [tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}




#pragma mark - 加载最新评论数据
-(void)loadCommentData{
    
    NSDictionary *dict = @{@"recordId":@(self.dianDi.id),@"timestamp":@(0)};
    [NetworkManager requestWithURL:RECORD_GETREPLYLIST parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
//        CZLog(@"%@",response);
        NSMutableArray * arrM = [NSMutableArray array];
        NSArray * arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            Reply * comment = [Reply mj_objectWithKeyValues:dic];
            [arrM addObject:comment];
            
            NSArray * sub =dic[@"subReply"];
            if (sub.count>0) {//有子评论
                self.subArr = sub;
                do {//循环遍历子评论
                    for (NSDictionary * subDic in self.subArr) {
                        Reply * subComment = [Reply mj_objectWithKeyValues:subDic];
                        [arrM addObject:subComment];
                        self.subArr = subDic[@"subReply"];
                    }
                } while (self.subArr.count>0);
                
            }
        }
        self.commentArr =arrM;
        [tableV reloadData];
        [tableV headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
         [tableV headerEndRefreshing];
    }];
}

#pragma mark - 上拉加载更多数据
-(void)moreData{
    
    NSDictionary *dict = @{@"recordId":@(self.dianDi.id),@"timestamp":@(self.timestamp)};
    [NetworkManager requestWithURL:RECORD_GETREPLYLIST parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
        CZLog(@"%@",response);
        NSMutableArray * moreArrM = [NSMutableArray array];
        NSArray * arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            Reply * comment = [Reply mj_objectWithKeyValues:dic];
            [moreArrM addObject:comment];
            
            NSArray * sub =dic[@"subReply"];
            if (sub.count>0) {//有子评论
                self.subArr = sub;
                do {//循环遍历子评论
                    for (NSDictionary * subDic in self.subArr) {
                        Reply * subComment = [Reply mj_objectWithKeyValues:subDic];
                        [moreArrM addObject:subComment];
                        self.subArr = subDic[@"subReply"];
                    }
                } while (self.subArr.count>0);
                
            }
        }
        if (moreArrM.count>0) {
            [self.commentArr addObjectsFromArray:moreArrM];
            [tableV reloadData];
        }else{
            [OMGToast showText:@"已无更多数据"];
        }
        [tableV footerEndRefreshing];

    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [tableV footerEndRefreshing];
    }];
}

-(void)iconTouch:(UITapGestureRecognizer *)gesture{
    Reply *reply = self.commentArr[gesture.view.tag];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == reply.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = reply.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCDoodleCommentCell * cell = [QCDoodleCommentCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.reply = self.commentArr[indexPath.row];
    cell.icon.userInteractionEnabled = YES;
    cell.icon.tag = indexPath.row;
    [cell.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTouch:)]];
    NSLog(@"cell height %f",cell.frame.size.height);
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.commentType = CommentTypeReply;
    self.selectReply = self.commentArr[indexPath.row];
    self.toolBar.tf.text =nil;
    self.toolBar.tf.placeholder = [NSString stringWithFormat:@"回复:%@",self.selectReply.user.nickname];
}

// 删除评论
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
     Reply * reply= self.commentArr[indexPath.row];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == reply.user.uid ||sessions.user.uid ==self.dianDi.user.uid){
        //        删除评论
        NSDictionary * dic = @{@"replyId":@(reply.id)};
        [NetworkManager requestWithURL:RECORD_DELETEREPLY_RRL parameter:dic success:^(id response) {
            
            //    1、删除数组中对应的模型
            [self.commentArr removeObject:self.commentArr[indexPath.row]];
            
            //    2、刷新编辑的行（局部刷新）
            [tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            [OMGToast showText:@"删除失败"];
        }];
    }else{
        [OMGToast showText:@"只能删除自己创建的评论"];
    }
}

/**
 *  自定义删除按钮的标题文字
 */
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    
    return UITableViewAutomaticDimension;
}
#pragma mark - 删除文章帖子
-(void)deleteDianDi{
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"确定删除本帖?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self deleteData];
    }];
    [alertCtr addAction:sure];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertCtr addAction:cancelAction];
    
    [self presentViewController:alertCtr animated:YES completion:^{
        
    }];
}

-(void)deleteData{
    
    NSDictionary *dict = @{@"recordId":@(self.dianDi.id)};
    [NetworkManager requestWithURL:RECORD_DELETERECORD parameter:dict success:^(id response) {
        CZLog(@"%@",response);
        
        [self showHint:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } error:nil];
}



#pragma mark - 其他
-(void)tapTopView{
    [self.toolBar.tf resignFirstResponder];
     self.commentType = CommenTypeTopic;
    self.toolBar.tf.placeholder =nil;
     self.toolBar.tf.text =nil;
}

@end
