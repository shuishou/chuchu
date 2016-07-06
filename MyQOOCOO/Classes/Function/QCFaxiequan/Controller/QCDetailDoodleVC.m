//
//  QCDetailVCViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDetailDoodleVC.h"
#import "QCBaseTableView.h"
#import "QCDoodleStatus.h"
#import "Reply.h"
#import "QCDoodleCommentCell.h"
#import "QCCommentToolBar.h"
#import "DoodleDetailHeadView.h"
#import "QCUserViewController2.h"
@interface QCDetailDoodleVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,assign) long long timestamp;//时间戳
@property (nonatomic,strong)NSMutableArray *replyArray;//评论模型数组
@property (nonatomic,assign)CommentType commentType;//回复类型
@property (nonatomic,strong) Reply * selectReply;//被选评论模型

@property (nonatomic,strong) NSArray * subArr;//记录字评论数组

@end

@implementation QCDetailDoodleVC


-(void)iconTouch:(UITapGestureRecognizer *)gesture{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == self.qcStatus.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = self.qcStatus.user.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详情";
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == self.qcStatus.user.uid) {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"组-9" highlightedImg:nil target:self action:@selector(deleteDoodle:)];
    }
//     头部View
    DoodleDetailHeadView * headerV = [[DoodleDetailHeadView alloc]init];
    headerV.qcStatus = self.qcStatus;
    
    headerV.iconV.userInteractionEnabled = YES;
    [headerV.iconV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTouch:)]];
    
    headerV.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopView)];
    [headerV addGestureRecognizer:tap];
    self.tableView.tableHeaderView = headerV;
    
//    评论tableView
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 2;
    self.tableView.delegate = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.frame = CGRectMake(0, 0, kUIScreenW, kUIScreenH-49);

    //工具条
    self.commentType = CommentTypeTopic;//默认设置
    _toolbar = [[QCCommentToolBar alloc]initWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    _toolbar.backgroundColor = normalTabbarColor;
    [self.view addSubview:_toolbar];
    _toolbar.qcStatus = self.qcStatus;
    _toolbar.textField.enablesReturnKeyAutomatically = YES;
    [_toolbar.textField setReturnKeyType:UIReturnKeySend];
    _toolbar.textField.delegate = self;
    
    //键盘
    [self setupNotification];//改变toolbar的frame
    [self.toolbar.textField becomeFirstResponder];//进去就弹出键盘
    [self setupForDismissKeyboard];//点击屏幕键盘退下

    //参数
    self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    self.replyArray = [[NSMutableArray alloc]init];
    
//     下拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(refresh)];
    [self.tableView addFooterWithTarget:self action:@selector(moreData)];

}
-(void)viewWillAppear:(BOOL)animated{
    [self refresh];
}

#pragma mark - 键盘弹出通知
-(void)setupNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notifi{
    double duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardRect = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    
    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight);
        _toolbar.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight);
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)notifi{
    double duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformIdentity;
        _toolbar.transform = CGAffineTransformIdentity;
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_toolbar.textField resignFirstResponder];
    [self sendContent];
    
    return YES;
}

//#pragma mark - 发送评论消息
-(void)sendContent{
    NSString *content = _toolbar.textField.text;
    NSDictionary *parameters;
    if (self.commentType == CommentTypeTopic) {
        parameters = @{@"topicId":@(self.qcStatus.id),@"content":content,@"toReplyId":@(0),@"replyUid":@(0)};
    }else if (self.commentType == CommentTypeReply){
       parameters = @{@"topicId":@(self.qcStatus.id),@"content":content,@"toReplyId":@(self.selectReply.id),@"replyUid":@(self.selectReply.uid)};
    }

    [NetworkManager requestWithURL:TOPIC_REPLY_URL parameter:parameters success:^(id response) {
        
        [OMGToast showText:@"评论成功"];
//        刷新评论列表数据
        [self refresh];
        _toolbar.textField.text =nil;
        
        //  滚到最后一行可见
        if (self.replyArray.count>4 &&self.commentType == CommentTypeTopic) {
            [self scrollToTop];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@",error);
    }];
}

//    滚到最后一行可见
-(void)scrollToTop{
    //   拿到最后一行
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:self.replyArray.count - 1 inSection:0];
    //    让tableView向上滚到最后一行可见
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 加载发泄圈评论列表
-(void)refresh{

    NSDictionary *dict = @{@"topicId":@(self.qcStatus.id),@"timestamp":@(0)};
    [NetworkManager requestWithURL:TOPIC_GETREPLYLIST_URL parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
        
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
        self.replyArray  = arrM;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self.tableView headerEndRefreshing];
    }];
}

#pragma mark - 上拉加载更多数据
-(void)moreData{

    NSDictionary *dict = @{@"topicId":@(self.qcStatus.id),@"timestamp":@(self.timestamp)};
    [NetworkManager requestWithURL:TOPIC_GETREPLYLIST_URL parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
        
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
            [self.replyArray addObjectsFromArray:moreArrM];
//            CZLog(@"moreArr %@",moreArrM);
            [self.tableView reloadData];
        }else{
             [OMGToast showText:@"已无更多数据"];
        }
        [self.tableView footerEndRefreshing];
       
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self.tableView footerEndRefreshing];
    }];
}

-(void)iconTpa:(UITapGestureRecognizer *)gesture{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    QCYellModel *model = self.replyArray[gesture.view.tag];
    if (model.user.uid == sessions.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = model.user.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.replyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    QCDoodleCommentCell *cell = [QCDoodleCommentCell cellWithTableView:tableView];
    cell.reply = self.replyArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.icon.userInteractionEnabled = YES;
    cell.icon.tag = indexPath.row;
    [cell.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTpa:)]];
    return cell;
}

#pragma mark - tabelView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.commentType = CommentTypeReply;
    self.selectReply = self.replyArray[indexPath.row];
    _toolbar.textField.text =nil;
      _toolbar.textField.placeholder = [NSString stringWithFormat:@"回复:%@",self.selectReply.user.nickname];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
     Reply * reply= self.replyArray[indexPath.row];
     LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid==reply.user.uid ||sessions.user.uid ==self.qcStatus.user.uid ){
        //        删除评论
        Reply * reply= self.replyArray[indexPath.row];
        NSDictionary * dic = @{@"replyId":@(reply.id)};
        [NetworkManager requestWithURL:TOPIC_DELETEREPLY_URL parameter:dic success:^(id response) {
            
            //    1、删除数组中对应的模型
            [self.replyArray removeObject:self.replyArray[indexPath.row]];
            
            //    2、刷新编辑的行（局部刷新）
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
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



#pragma mark - 删除涂鸦
-(void)deleteDoodle:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定删除本帖?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    [alertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
              CZLog(@"%zd",self.qcStatus.id);
            NSDictionary *dict = @{@"topicId":@(self.qcStatus.id)};
            [NetworkManager requestWithURL:TOPIC_DELETETOPIC_URL parameter:dict success:^(id response) {
                
                [self showHint:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
                CZLog(@"%@",error);
            }];
        }
    }
}

#pragma mark - 其它
// 点击顶部View，改为评论帖子
-(void)tapTopView{
    _toolbar.textField.placeholder = nil;
    self.commentType = CommentTypeTopic;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_toolbar.textField resignFirstResponder];
}


@end
