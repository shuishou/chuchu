//
//  QCDetailYellVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDetailYellVC.h"
#import "QCYellDetailHeaderView.h"
#import "QCDoodleCommentCell.h"
#import "QCCommentToolBar.h"
#import "QCUserViewController2.h"
@interface QCDetailYellVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong)QCCommentToolBar *toolbar;
@property (nonatomic,assign)CommentType commentType;//回复类型

@property (nonatomic,strong) NSMutableArray * commentArr;

@property (nonatomic,assign) long long timestamp;

@property (nonatomic,assign) CGFloat distance;

@property (nonatomic,strong) Reply * selectReply;//被选评论模型

@property (nonatomic,strong) NSArray * subArr;//记录字评论数组

@end

@implementation QCDetailYellVC

-(NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}

-(void)iconTouch:(UITapGestureRecognizer *)gesture{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == self.yellModel.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = self.yellModel.user.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self setupForDismissKeyboard];//点击屏幕键盘退下
     self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == self.yellModel.user.uid) {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"组-9" highlightedImg:nil target:self action:@selector(deleteYell)];
    }
    //     头部View
    QCYellDetailHeaderView * headerV = [QCYellDetailHeaderView headerView];
    headerV.yellModel = self.yellModel;
    headerV.icon.userInteractionEnabled = YES;
    [headerV.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTouch:)]];
    
    
    
    headerV.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopView)];
    [headerV addGestureRecognizer:tap];
  
    //    评论tableView
    self.tableView = [[UITableView alloc]init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kGlobalBackGroundColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.frame = CGRectMake(0, 0, kUIScreenW, kUIScreenH-49);
    [self.view addSubview:self.tableView];
  
    self.tableView.tableHeaderView = headerV;

    //工具条
    self.commentType = CommentTypeTopic;//默认设置
    _toolbar = [[QCCommentToolBar alloc]initWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    _toolbar.backgroundColor = normalTabbarColor;
    [self.view addSubview:_toolbar];
    _toolbar.yellModel = self.yellModel;
    _toolbar.textField.enablesReturnKeyAutomatically = YES;
    [_toolbar.textField setReturnKeyType:UIReturnKeySend];
    _toolbar.textField.delegate = self;
    
//    默认评论列表数据
    [self loadCommentData];
   
    //     下拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadCommentData)];
    [self.tableView addFooterWithTarget:self action:@selector(moreData)];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 键盘通知回调
-(void)keyboardWillChangeFrame:(NSNotification *)n {
    //    拿到键盘弹出后的frame
    CGRect endFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat distance  = endFrame.origin.y  - kUIScreenH;
    self.distance = distance;
    _toolbar.transform = CGAffineTransformMakeTranslation(0,distance);
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_toolbar.textField resignFirstResponder];
    _toolbar.transform = CGAffineTransformMakeTranslation(0,-self.distance);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_toolbar.textField resignFirstResponder];
    [self sendContent];
    return YES;
}

#pragma mark - 发送评论消息
-(void)sendContent{
    NSString *content = _toolbar.textField.text;
    NSDictionary *parameters;
    if (self.commentType == CommentTypeTopic) {
        parameters = @{@"topicId":@(self.yellModel.id),@"content":content,@"toReplyId":@(0),@"replyUid":@(0)};
    }else if (self.commentType == CommentTypeReply){
        parameters = @{@"topicId":@(self.yellModel.id),@"content":content,@"toReplyId":@(self.selectReply.id),@"replyUid":@(self.selectReply.uid)};
    }
    
    [NetworkManager requestWithURL:TOPIC_REPLY_URL parameter:parameters success:^(id response) {
        [OMGToast showText:@"评论成功"];
        //        刷新评论列表数据
        [self loadCommentData];
        _toolbar.textField.text =nil;
  
        //  滚到最后一行可见
        if (self.commentArr.count>4 &&self.commentType == CommentTypeTopic) {
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
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - 加载最新评论数据
-(void)loadCommentData{
    
    NSDictionary *dict = @{@"topicId":@(self.yellModel.id),@"timestamp":@(0)};
    [NetworkManager requestWithURL:TOPIC_GETREPLYLIST_URL parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
    
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
        self.commentArr = [arrM mutableCopy];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self.tableView headerEndRefreshing];
    }];
}

#pragma mark - 上拉加载更过
-(void)moreData{
    
    NSDictionary *dict = @{@"topicId":@(self.yellModel.id),@"timestamp":@(self.timestamp)};
    [NetworkManager requestWithURL:TOPIC_GETREPLYLIST_URL parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
        
        NSMutableArray * moreArrM = [NSMutableArray array];
        NSArray * arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            Reply * comment = [Reply objectWithKeyValues:dic];
            [moreArrM addObject:comment];
            
            NSArray * sub =dic[@"subReply"];
            if (sub.count>0) {
                //有子评论
                self.subArr = sub;
                do {
                    //循环遍历子评论
                    for (NSDictionary * subDic in self.subArr) {
                        Reply * subComment = [Reply mj_objectWithKeyValues:subDic];
                        [moreArrM addObject:subComment];
                        self.subArr = subDic[@"subReply"];
                    }
                } while (self.subArr.count>0);
            }
        }

        if (moreArrM.count>0) {
            CZLog(@"%@",moreArrM);
            [self.commentArr addObjectsFromArray:moreArrM];
            [self.tableView reloadData];
        }else{
             [OMGToast showText:@"已无更多数据"];
        }
         [self.tableView footerEndRefreshing];

    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self.tableView footerEndRefreshing];
    }];
}

-(void)iconTap:(UITapGestureRecognizer *)gesture{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    Reply *model = self.commentArr[gesture.view.tag];
    if (model.user.uid == sessions.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = model.user.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCDoodleCommentCell *cell = [QCDoodleCommentCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.reply = self.commentArr[indexPath.row];
    cell.icon.userInteractionEnabled = YES;
    cell.icon.tag = indexPath.row;
    [cell.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap:)]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.commentType = CommentTypeReply;
    self.selectReply = self.commentArr[indexPath.row];
    _toolbar.textField.text =nil;
    _toolbar.textField.placeholder = [NSString stringWithFormat:@"回复:%@",self.selectReply.user.nickname];
}

#pragma mark - tabelView代理方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
      Reply * reply= self.commentArr[indexPath.row];
     LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == sessions.user.uid ||sessions.user.uid == self.yellModel.user.uid ){
        //        删除评论
        NSDictionary * dic = @{@"replyId":@(reply.id)};
        [NetworkManager requestWithURL:TOPIC_DELETEREPLY_URL parameter:dic success:^(id response) {
            
            //    1、删除数组中对应的模型
            [self.commentArr removeObject:self.commentArr[indexPath.row]];
            
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

#pragma mark - 删除文章帖子
-(void)deleteYell{
    
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
    
    CZLog(@"%d",self.yellModel.id);
//
//        NSURLSessionTaskManager *manager = [NSURLSessionTaskManager manager];
////        manager.requestSerializer = [AFJSONRequestSerializer serializer];
// 
//         NSDictionary *dic = @{@"topicId":@(self.yellModel.id)};
//    NSString * url = @"http://203.195.168.151:9063/api/topic/deleteTopic";
//        [manager POST:url parameters:dic success:^(NSURLSessionTask *operation, id responseObject) {
//            
//            CZLog(@"%@",responseObject);
//   
//        } failure:^(NSURLSessionTask *operation, NSError *error) {
//            CZLog(@"%@",error);
//        }];

    
    NSDictionary *dict = @{@"topicId":@(self.yellModel.id)};
    [NetworkManager requestWithURL:TOPIC_DELETETOPIC_URL parameter:dict success:^(id response) {
        CZLog(@"%@",response);
        
        [self showHint:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } error:nil];
}


#pragma mark - 其它
// 点击顶部View，改为评论帖子
-(void)tapTopView{
    _toolbar.textField.placeholder = nil;
    self.commentType = CommentTypeTopic;
    [_toolbar.textField resignFirstResponder];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







@end
