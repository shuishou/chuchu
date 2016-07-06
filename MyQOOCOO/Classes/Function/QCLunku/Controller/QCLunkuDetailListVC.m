//
//  QCLunkuDetailListVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCLunkuDetailListVC.h"

//#import "QCLunkuReplyCell.h"
//#import "UITableView+Common.h"

#import "OkamiPhotoView.h"


#import "QCLKdetailTopView.h"
#import "QCDoodleCommentCell.h"//共用发泄圈的评论cell
#import "QCDanDiCommentToolBar.h"// 共用点滴的的评论toolBar

#import "QCUserViewController2.h"
#import "QCFriendAccout.h"
@interface QCLunkuDetailListVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,QCDanDiCommentToolBarDelegate,UITextFieldDelegate>
{
    UITableView * tableV;
}

@property(strong, nonatomic) NSMutableArray *commentArr;
@property(assign, nonatomic) long long timestamp;
@property (nonatomic,strong) QCDanDiCommentToolBar * toolBar;
@property (nonatomic,assign) CGFloat distance;
@property (nonatomic,assign) CommentType commentType;//回复类型
@property (nonatomic,strong) Reply * selectReply;//选中评论的数据对象
@property (nonatomic,strong) NSArray * subArr;//记录字评论数组
@property (nonatomic,assign) BOOL rUser;//是否是回复目标

@end

@implementation QCLunkuDetailListVC


-(NSMutableArray *)commentArr{
    if (_commentArr == nil) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"详情";
    
    self.rUser = NO;
    
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == self.lk.user.uid) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"组-9" highlightedImg:nil target:self action:@selector(deleteLunku)];
    }
    
    [self setupForDismissKeyboard];//点击屏幕键盘退下
//    self.timestamp = [[NSDate date]timeIntervalSince1970]*1000;
    self.commentType = CommenTypeTopic;
    
    // UITableView
    tableV = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kUIScreenW, kUIScreenH -49)];
    [self.view addSubview:tableV];
    tableV.delegate = self;
    tableV.dataSource = self;
//    tableV.rowHeight = UITableViewAutomaticDimension;
    tableV.estimatedRowHeight = 2;
    tableV.backgroundColor = kGlobalBackGroundColor;
    tableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableV.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    tableV.layer.masksToBounds = YES;
    tableV.layer.cornerRadius = 8;

    // HeaderView
    QCLKdetailTopView * topV = [QCLKdetailTopView topView];
    topV.icon.userInteractionEnabled = YES;
    [topV.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)]];
    NSDictionary * textAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize maxSize = CGSizeMake(kUIScreenW - 12 * 4, MAXFLOAT);
    CGSize titleSize = [self.lk.title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGSize textSize = [self.lk.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
     if (self.lk.image.length > 0){
         NSArray * tempArr = [self.lk.image componentsSeparatedByString:@","];
         NSMutableArray * Arr = [tempArr mutableCopy];
          CGSize photosSize = [OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];

        topV.frame = CGRectMake(0, 0, kUIScreenW, 94 + textSize.height +titleSize.height+ 24 + photosSize.height+24 + 35);
    }else{
        topV.frame = CGRectMake(0, 0, kUIScreenW, 84 + textSize.height + titleSize.height + 24+12+35);
    }
    
    topV.lk = self.lk;
    topV.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopView)];
    [topV addGestureRecognizer:tap];
    tableV.tableHeaderView = topV;
    
    //    toolBar
    QCDanDiCommentToolBar * toolBar = [QCDanDiCommentToolBar commentToolBar];
    toolBar.frame = CGRectMake(0, kUIScreenH - 49, kUIScreenW, 49);
    [self.view addSubview:toolBar];
    toolBar.isFree=self.isFree;
    toolBar.lk = self.lk;
    toolBar.delegate = self;
    toolBar.tf.delegate = self;
    self.toolBar = toolBar;
    
    [self loadCommentData];
    [tableV addHeaderWithTarget:self action:@selector(loadCommentData)];
    [tableV addFooterWithTarget:self action:@selector(moreData)];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)iconTap{
    NSLog(@"self.isRoot===%d",self.isRoot);
    LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
    if (session.user.uid == self.lk.uid) {
        if (self.isRoot == YES) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            self.tabBarController.selectedIndex = 3;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
             @"3"];
        }
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc]init];
        user.uid = self.lk.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}


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
//    [self sendComment];
    return YES;
}
#pragma mark - QCDanDiCommentToolBarDelegate
-(void)sendBtnClick{
    [self sendComment];
}

//发送评论
-(void)sendComment{
    NSString *content = self.toolBar.tf.text;
    if (content.length > 0) {
        NSDictionary *parameters;
        if (self.commentType == CommentTypeTopic) {
            parameters = @{@"forumId":@(self.lk.id),@"content":content,@"toReplyId":@(0),@"replyUid":@(0)};
        }else if (self.commentType == CommentTypeReply){
            //子评论
            parameters = @{@"forumId":@(self.lk.id),@"content":content,@"toReplyId":@(self.selectReply.id),@"replyUid":self.rUser?@(self.selectReply.replyUser.uid):@(self.selectReply.user.uid)};
        }
        NSString*url;
        if (self.isFree) {
            url=FreeManRelpy;
        }else{
            url=FORUM_REPLY;
        }
        [MBProgressHUD showMessage:nil background:NO];
        
        [NetworkManager requestWithURL:url parameter:parameters success:^(id response) {
            [OMGToast showText:@"评论成功"];
            [MBProgressHUD hideHUD];
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
            [MBProgressHUD hideHUD];
        }];
    }
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
    
    NSDictionary *dict = @{@"forumId":@(self.lk.id),@"timestamp":@(0)};
    
    NSString*url;
    if (self.isFree) {
        url = FreeManGetReplyList;
    }else{
        url = FORUM_GETREPLY;
    }

    
    //1461036239379 1461036239379
    [NetworkManager requestWithURL:url parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
        CZLog(@"%@",response);
        NSMutableArray * arrM = [NSMutableArray array];
        NSArray * arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            Reply * comment = [Reply mj_objectWithKeyValues:dic];
            [arrM addObject:comment];
            
            NSArray * sub =dic[@"subReply"];
            if (sub.count > 0) {//有子评论
                self.subArr = sub;
                do {
                    //循环遍历子评论
                    for (NSDictionary * subDic in self.subArr)
                    {
                        Reply * subComment = [Reply mj_objectWithKeyValues:subDic];
                        [arrM addObject:subComment];
                        self.subArr = subDic[@"subReply"];
                    }
                } while (self.subArr.count > 0);
            }
        }
        
        [self.commentArr removeAllObjects];
        self.commentArr = [arrM mutableCopy];
        NSLog(@"self.commentArr====%@",self.commentArr);
        [tableV reloadData];
        [tableV headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [tableV headerEndRefreshing];
    }];
}

#pragma mark - 上拉加载更多数据
-(void)moreData{
    
    NSDictionary *dict = @{@"forumId":@(self.lk.id),@"timestamp":@(self.timestamp)};
    NSString *url;
    if (self.isFree) {
        url = FreeManGetReplyList;
    }else{
        url = FORUM_GETREPLY;
    }
    
    [NetworkManager requestWithURL:url parameter:dict success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
        CZLog(@"%@",response);
        NSMutableArray * moreArrM = [NSMutableArray array];
        NSArray * arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            Reply * comment = [Reply mj_objectWithKeyValues:dic];
            [moreArrM addObject:comment];
            
            NSArray * sub =dic[@"subReply"];
            if (sub.count > 0) {//有子评论
                self.subArr = sub;
                if (self.subArr.count > 0) {
                    for (NSDictionary * subDic in self.subArr) {
                        Reply * subComment = [Reply mj_objectWithKeyValues:subDic];
                        [moreArrM addObject:subComment];
                        self.subArr = subDic[@"subReply"];
                    }
                }
            }
        }
        //1461055901739
        if (moreArrM.count > 0) {
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

#pragma mark 头像点击方法
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
    Reply *um = self.commentArr[gesture.view.tag - 200] ;
    if (session.user.uid == um.uid) {
        if (self.isRoot == YES) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            self.tabBarController.selectedIndex = 3;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
             @"3"];
        }
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc]init];
        user.uid = um.uid;
        user.isFriend = um.user.isFriend;
        [self.navigationController pushViewController:user animated:YES];
    }
}

#pragma mark - tableViewDataSore
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCDoodleCommentCell *cell = [QCDoodleCommentCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.commentArr.count > 0) {
        cell.reply = self.commentArr[indexPath.row];
    }
    
    cell.icon.tag = indexPath.row + 200;
    cell.icon.userInteractionEnabled = YES;
    [cell.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    //评论者
    cell.name.userInteractionEnabled = YES;
    cell.name.tag = indexPath.row + 500;
    [cell.name addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hfAction:)]];
    
    //回复对象
    cell.rUser.userInteractionEnabled = YES;
    cell.rUser.tag = indexPath.row + 600;
    [cell.rUser addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rUserAction:)]];
    
    return cell;
}

#pragma mark 评论者名称点击方法
-(void)hfAction:(UITapGestureRecognizer *)gesture{
    self.commentType = CommentTypeReply;
    self.selectReply = self.commentArr[gesture.view.tag - 500];
    self.toolBar.tf.text = nil;
    self.toolBar.tf.placeholder = [NSString stringWithFormat:@"回复:%@",self.selectReply.user.nickname];
    self.rUser = NO;
}

#pragma mark 回复对象名称点击方法
-(void)rUserAction:(UITapGestureRecognizer *)gesture{
    self.commentType = CommentTypeReply;
    self.selectReply = self.commentArr[gesture.view.tag - 600];
    self.toolBar.tf.text = nil;
    self.toolBar.tf.placeholder = [NSString stringWithFormat:@"回复:%@",self.selectReply.replyUser.nickname];
    self.rUser = YES;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - tabelView代理方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
     Reply * reply= self.commentArr[indexPath.row];
    NSLog(@"reply.user.uid===%ld,sessions.user.uid===%ld",reply.user.uid,sessions.user.uid);
    if (sessions.user.uid == reply.user.uid || sessions.user.uid == self.lk.user.uid ){
        //删除评论
        NSString *url;
        if (self.isFree) {
            url = FeeManDeleteReply;
        }else{
             url = FORUM_DELETEREPLY_URL;
        }
        
        NSDictionary * dic = @{@"replyId":@(reply.id)};
        
        [NetworkManager requestWithURL:url parameter:dic success:^(id response) {
            //    1、删除数组中对应的模型
            [self.commentArr removeObject:self.commentArr[indexPath.row]];
            
            //    2、刷新编辑的行（局部刷新）
            [tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
//            [OMGToast showText:@"删除失败"];
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


#pragma mark - 删除文章帖子
-(void)deleteLunku{
  
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
    NSDictionary *dict = @{@"forumId":@(self.lk.id)};
    NSString*url;
    if (self.isFree) {
        url=FeeManDeleteWork;
    }else{
    
        url=FORUM_DELETEFORUM;
    }
    [NetworkManager requestWithURL:url parameter:dict success:^(id response) {
        CZLog(@"%@",response);
        
        [self showHint:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } error:nil];
}




#pragma mark - 其它
-(void)tapTopView{
   [self.toolBar.tf resignFirstResponder];
    self.commentType = CommenTypeTopic;
    self.toolBar.tf.placeholder =nil;
    self.toolBar.tf.text =nil;
}

@end
