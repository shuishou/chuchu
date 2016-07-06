//
//  QCHFASViewController.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFASViewController.h"
#import "HFSearchFriendListVc.h"

#import "QCHFGJASCell.h"
#import "QCHFUserModel.h"
@interface QCHFASViewController ()<UITextViewDelegate,UIAlertViewDelegate>//UITableViewDataSource, UITableViewDelegate,
{
    UITableView * tableViews;
    UIView * markNameV;
    UITextView * textViews;
    UIView * titleView;
    NSString * markNames;
    NSIndexPath * indexs;
    NSString * tags;
    
    NSString * strn1;
    NSString * strn2;
    NSString * strn3;
    BOOL isLongPress;
    NSInteger tempTag;
    UILongPressGestureRecognizer *longPressGesture;
    UIAlertView *alert;
    int times;
}

@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;
@property (weak, nonatomic) IBOutlet UIButton *btnFour;
@property (weak, nonatomic) IBOutlet UIButton *btnFive;
@property (weak, nonatomic) IBOutlet UIButton *btnSix;
@property (weak, nonatomic) IBOutlet UIButton *btnSeven;
@property (weak, nonatomic) IBOutlet UIButton *btnEight;
@property (weak, nonatomic) IBOutlet UIButton *btnNine;

@property (weak, nonatomic) IBOutlet UIButton *highLevelSearchBtn;
- (IBAction)highSearchAction:(UIButton *)sender;

- (IBAction)flagBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@property(nonatomic,strong)NSMutableArray *btnArr;


@property (strong, nonatomic) NSMutableArray * buArr;

@property (strong, nonatomic) NSMutableArray * keyWordArr1;
@property (strong, nonatomic) NSMutableArray * keyWordArr2;
@property (strong, nonatomic) NSMutableArray * keyWordArr3;



@end

@implementation QCHFASViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _buArr = [NSMutableArray array];
    self.keyWordArr1 = [NSMutableArray array];
    self.keyWordArr2 = [NSMutableArray array];
    self.keyWordArr3 = [NSMutableArray array];
    times = 0;
    
    self.btnArr = [NSMutableArray array];
    [self.btnArr addObject:self.btnOne];
    [self.btnArr addObject:self.btnTwo];
    [self.btnArr addObject:self.btnThree];
    [self.btnArr addObject:self.btnFour];
    [self.btnArr addObject:self.btnFive];
    [self.btnArr addObject:self.btnSix];
    [self.btnArr addObject:self.btnSeven];
    [self.btnArr addObject:self.btnEight];
    [self.btnArr addObject:self.btnNine];
    
    self.btnWidth.constant = ([UIScreen mainScreen].bounds.size.width-29*2-12*2)/3;
    
    for (UIButton *btn in self.btnArr) {
        btn.userInteractionEnabled = YES;
        longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPressGesture.minimumPressDuration = 1.0;
        [btn addGestureRecognizer:longPressGesture];
    }
    
    self.highLevelSearchBtn.backgroundColor = kLoginbackgoundColor;
    
//    [self initTabelView];
    [self initGroupName];
    markNameV.hidden = YES;
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationdeds:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveeds:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyBoardWillShowNotificationdeds:(NSNotification *)not
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
-(void)keyBoardRemoveeds:(NSNotification *)not
{
    //调整输入框的位置
    [UIView animateWithDuration:0.5 animations:^{
        titleView.frame = CGRectMake(30, (HEIGHT(markNameV)-HEIGHT(markNameV)/3)/2, WIDTH(markNameV)-60, HEIGHT(markNameV)/3);
    }];
}

//- (void)initTabelView
//{
//    tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
//    tableViews.delegate = self;
//    tableViews.dataSource = self;
//    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableViews.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    
//    [self.view addSubview:tableViews];
//    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/5)];
//    view.backgroundColor = tableViews.backgroundColor;
//    UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
//    bu.frame = CGRectMake(30, HEIGHT(view)/2, WIDTH(view)-60, HEIGHT(view)/2);
//    [bu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [bu setTitle:@"高级搜索" forState:UIControlStateNormal];
//    bu.backgroundColor = kLoginbackgoundColor;
//    bu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(bu)/2];
//    [bu actionButton:^(UIButton *sender) {
//        if (_keyWordArr1.count > 0 || _keyWordArr2.count > 0 || _keyWordArr3.count > 0) {
//            [self initGaoJiSearh];
//        }else{
//            [OMGToast showText:@"请填写关键字"];
//        }
//    }];
//    [view addSubview:bu];
//    
//    tableViews.tableFooterView = view;
//}

#pragma mark - 搜索
- (void)initGaoJiSearh
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if (_keyWordArr1.count > 0) {
        NSString * keyword1  = [_keyWordArr1 componentsJoinedByString:@","];
        dic[@"keyWords1"] = keyword1;
    }
    
    
    if (_keyWordArr2.count > 0) {
        NSString * keyword2  = [_keyWordArr2 componentsJoinedByString:@","];
        dic[@"keyWords2"] = keyword2;
    }
    
    
    if (_keyWordArr3.count > 0) {
        NSString * keyword3  = [_keyWordArr3 componentsJoinedByString:@","];
        dic[@"keyWords3"] = keyword3;
    }
   
    
    
    
    
//    NSLog(@"_keyWordArr1===%@,_keyWordArr1===%@,_keyWordArr1====%@",_keyWordArr1,_keyWordArr2,_keyWordArr3);
//    if (_keyWordArr1.count > 0) {
//         NSString * keyword1  = [_keyWordArr1 componentsJoinedByString:@","];
//        dic[@"keyWords1"] = keyword1;
//        
//        if (_keyWordArr2.count > 0) {
//            NSString * keyword2  = [_keyWordArr2 componentsJoinedByString:@","];
//            dic[@"keyWords2"] = keyword2;
//        }
//        
//        if (_keyWordArr3.count > 0) {
//            NSString * keyword3  = [_keyWordArr3 componentsJoinedByString:@","];
//            dic[@"keyWords3"] = keyword3;
//        }
//        
//    }else if (_keyWordArr2.count > 0){
//        NSString * keyword2  = [_keyWordArr2 componentsJoinedByString:@","];
//        dic[@"keyWords1"] = keyword2;
//        
//        if (_keyWordArr3.count > 0) {
//            NSString * keyword3  = [_keyWordArr3 componentsJoinedByString:@","];
//            dic[@"keyWords3"] = keyword3;
//        }
//    }else{
//        NSString * keyword3  = [_keyWordArr3 componentsJoinedByString:@","];
//        dic[@"keyWords1"] = keyword3;
//    }
//    
    [NetworkManager requestWithURL:SEARCHBYCONDITIONS parameter:dic success:^(id response) {
        NSArray * arr = response;
        NSMutableArray * dataArrs = [NSMutableArray array];
        NSMutableArray * isfriendArr = [NSMutableArray array];
        if (arr.count > 0) {
            if (arr.count > 0) {
                for (NSDictionary * dic in arr) {
                    NSNumber * isF = [dic objectForKey:@"isFriends"];
                    QCHFUserModel * model = [[QCHFUserModel alloc] init];
                    model = [QCHFUserModel objectWithKeyValues:dic];
                    model.isFriends = [NSString stringWithFormat:@"%@", isF];
                    [dataArrs addObject:model];
                    [isfriendArr addObject:isF];
                }
            }
            HFSearchFriendListVc * vc = [[HFSearchFriendListVc alloc] init];
            vc.isAn = @1;
            vc.dataArray = dataArrs;
            vc.isfriendArr = isfriendArr;
            vc.title = @"搜素结果";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [OMGToast showText:@"没有找到相同标签的人"];
        }
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

- (IBAction)highSearchAction:(UIButton *)sender {
    for (int i = 0; i < 3; i++) {
        UIButton *btn = (UIButton *)self.btnArr[i];
        if (btn.titleLabel.text && btn.titleLabel.text.length > 0) {
            [_keyWordArr1 addObject:btn.titleLabel.text];
        }
    }
    
    for (int i = 3; i < 6; i++) {
        UIButton *btn = (UIButton *)self.btnArr[i];
        if (btn.titleLabel.text && btn.titleLabel.text.length > 0) {
            [_keyWordArr2 addObject:btn.titleLabel.text];
        }
    }
    
    for (int i = 6; i < 9; i++) {
        UIButton *btn = (UIButton *)self.btnArr[i];
        if (btn.titleLabel.text && btn.titleLabel.text.length > 0) {
            [_keyWordArr3 addObject:btn.titleLabel.text];
        }
    }
    
    if (_keyWordArr1.count > 0 || _keyWordArr2.count > 0 || _keyWordArr3.count > 0) {
        [self initGaoJiSearh];
    }else{
        [OMGToast showText:@"请填写关键字"];
    }
}

- (IBAction)flagBtnAction:(UIButton *)sender {
    markNameV.hidden = NO;
    textViews.text = nil;
    tempTag = sender.tag;
}

-(void)addTitleForBtnwithText:(NSString *)text{
    NSLog(@"text====%@",text);
    UIButton *btn = (UIButton *)self.btnArr[tempTag-100];
    [btn setImage:nil forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1].CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)longPress:(UILongPressGestureRecognizer *)gesture{
    UIButton *btn = (UIButton *)self.btnArr[gesture.view.tag-100];
//    [btn removeGestureRecognizer:longPressGesture];
    times++;
    if (times < 2) {
        if (btn.titleLabel.text && btn.titleLabel.text.length > 0) {
            alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = gesture.view.tag;
            alert.delegate = self;
            [alert show];
        }
    }
}

#pragma mark - AlertVieWDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIButton *btn = (UIButton *)self.btnArr[alertView.tag-100];
    if (buttonIndex == 1) {
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        [btn setImage:[UIImage imageNamed:@"Add_tags"] forState:UIControlStateNormal];
    }
    times = 0;
}

#pragma mark - 添加关键字
- (void)initGroupName
{
    markNameV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    markNameV.backgroundColor = kColorRGBA(52,52,52,0.3);
    markNameV.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:markNameV];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(30, (HEIGHT(markNameV)-HEIGHT(markNameV)/3)/2, WIDTH(markNameV)-60, HEIGHT(markNameV)/3)];
    titleView.backgroundColor = [UIColor whiteColor];
    [markNameV addSubview:titleView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(titleView), HEIGHT(titleView)/5)];
    label.text = @"请输入标签";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:HEIGHT(label)/2];
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
    placeHolderLabel.text = @"(请输入标签)";
    
    [textViews addSubview:placeHolderLabel];
    if ([[textViews text] length] == 0) {
        [[textViews viewWithTag:999] setAlpha:1];
    }else{
        [[textViews viewWithTag:999] setAlpha:0];
    }
    [titleView addSubview:textViews];
    
    UIButton * cancelBu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBu.frame = CGRectMake(0, HEIGHT(titleView)-HEIGHT(titleView)/5, WIDTH(titleView)/2, HEIGHT(titleView)/5);
    [cancelBu setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [markNameV endEditing:YES];
        markNames = nil;
        markNameV.hidden = YES;
        textViews.text = @"";
        [[textViews viewWithTag:999] setAlpha:1];
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender){
        [markNameV endEditing:YES];
        if (markNames.length > 0 && ![markNames isEqualToString:@" "]) {
            if (textViews.text.length > 10) {
                [OMGToast showText:@"内容不得多于10字"];
            }else{
//                markNameV.hidden = YES;
//                NSLog(@"indexs.section====%ld,indexs.row===%ld",indexs.section,indexs.row);
//                [tableViews reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexs,nil] withRowAnimation:UITableViewRowAnimationNone];
//                textViews.text = @"";
//                [[textViews viewWithTag:999] setAlpha:1];
//                markNames = nil;
                
                //修改:
                markNameV.hidden = YES;
                [[textViews viewWithTag:999] setAlpha:1];
                [self addTitleForBtnwithText:textViews.text];
            }
        }else{
            [OMGToast showText:@"请输入内容"];
        }
    }];
    [titleView addSubview:doneBu];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)-HEIGHT(cancelBu)-0.5, WIDTH(titleView), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line];
    
    //轻点消失
    UITapGestureRecognizer * dismissTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    [markNameV addGestureRecognizer:dismissTap];
}

//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[textViews text] length] == 0) {
        [[textViews viewWithTag:999] setAlpha:1];
    }else {
        [[textViews viewWithTag:999] setAlpha:0];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    markNames = textView.text;
}

- (void)dismissTap:(UITapGestureRecognizer *)tap
{
    //    markNameV.hidden = YES;
    [markNameV endEditing:YES];
}


//#pragma mark - UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    QCHFGJASCell * cell = [QCHFGJASCell QCHFGJASCell:tableViews];
//    NSString * str1 = [NSString stringWithFormat:@"1%ld", indexPath.section];
//    cell.addButton1.tag = [str1 floatValue];
//    [cell.addButton1 actionButton:^(UIButton *sender) {
//        NSString * str = [NSString stringWithFormat:@"1%ld", indexPath.section];
//        indexs = indexPath;
//        tags = str;
//        for (int i = 0; i < _buArr.count; i++) {
//            if ([_buArr[i] isEqualToString:str]) {
//                [_buArr removeObjectAtIndex:i];
//                break;
//            }
//        }
//        [_buArr addObject:str];
//        markNameV.hidden = NO;
//        cell.addButton1.userInteractionEnabled = YES;
//        [cell.addButton1 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
//    }];
//    
//    NSString * str2 = [NSString stringWithFormat:@"2%ld", indexPath.section];
//    cell.addButton2.tag = [str2 floatValue];
//    [cell.addButton2 actionButton:^(UIButton *sender) {
//        NSString * str = [NSString stringWithFormat:@"2%ld", indexPath.section];
//        indexs = indexPath;
//        tags = str;
//        for (int i = 0; i < _buArr.count; i++) {
//            if ([_buArr[i] isEqualToString:str]) {
//                [_buArr removeObjectAtIndex:i];
//                break;
//            }
//        }
//        [_buArr addObject:str];
//        markNameV.hidden = NO;
//        cell.addButton2.userInteractionEnabled = YES;
//        [cell.addButton2 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
//    }];
//    
//    NSString * str3 = [NSString stringWithFormat:@"3%ld", indexPath.section];
//    cell.addButton3.tag = [str3 floatValue];
//    [cell.addButton3 actionButton:^(UIButton *sender) {
//        NSString * str = [NSString stringWithFormat:@"3%ld", indexPath.section];
//        indexs = indexPath;
//        tags = str;
//        for (int i = 0; i < _buArr.count; i++) {
//            if ([_buArr[i] isEqualToString:str]) {
//                [_buArr removeObjectAtIndex:i];
//                break;
//            }
//        }
//        [_buArr addObject:str];
//        markNameV.hidden = NO;
//        cell.addButton3.userInteractionEnabled = YES;
//        [cell.addButton3 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
//    }];
//    
//    
//    
//    
//    CZLog(@"bu1!!%ld,bu!!%ld,bu3!!%ld", cell.addButton1.tag, cell.addButton2.tag, cell.addButton3.tag);
//    if (isLongPress) {
//        NSLog(@"tempTag===%ld",tempTag);
//        if (tempTag == cell.addButton1.tag) {
//            [cell.addButton1 setTitle:@"" forState:UIControlStateNormal];
//            [cell.addButton1 setImage:[UIImage imageNamed:@"Add_tags"] forState:UIControlStateNormal];
//            for (int i = 0; i < _keyWordArr1.count; i++) {
//                NSString *str = _keyWordArr1[i];
//                if ([str isEqualToString:cell.addButton1.titleLabel.text]) {
//                    [_keyWordArr1 removeObjectAtIndex:i];
//                }
//            }
//        }else if (tempTag == cell.addButton2.tag){
//            [cell.addButton2 setTitle:@"" forState:UIControlStateNormal];
//            [cell.addButton2 setImage:[UIImage imageNamed:@"Add_tags"] forState:UIControlStateNormal];
//            for (int i = 0; i < _keyWordArr2.count; i++) {
//                NSString *str = _keyWordArr2[i];
//                if ([str isEqualToString:cell.addButton2.titleLabel.text]) {
//                    [_keyWordArr2 removeObjectAtIndex:i];
//                }
//            }
//        }else if (tempTag == cell.addButton3.tag){
//            [cell.addButton3 setTitle:@"" forState:UIControlStateNormal];
//            [cell.addButton3 setImage:[UIImage imageNamed:@"Add_tags"] forState:UIControlStateNormal];
//            for (int i = 0; i < _keyWordArr3.count; i++) {
//                NSString *str = _keyWordArr3[i];
//                if ([str isEqualToString:cell.addButton3.titleLabel.text]) {
//                    [_keyWordArr3 removeObjectAtIndex:i];
//                }
//            }
//        }
//    }else{
//        if (markNames.length > 0) {
//            for (NSString * strs in _buArr) {
//                if ([strs floatValue] == cell.addButton1.tag) {
//                    [cell.addButton1 setImage:nil forState:UIControlStateNormal];
//                    cell.addButton1.layer.borderWidth = 1;
//                    cell.addButton1.layer.borderColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1].CGColor;
//                    cell.addButton1.layer.masksToBounds = YES;
//                    cell.addButton1.layer.cornerRadius = 5;
//                    cell.addButton1.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(cell.addButton1)/3];
//                    
//                    if ([strs floatValue] == [tags floatValue]) {
//                        if (indexPath.section == 0) {
//                            if (_keyWordArr1.count > 0) {
//                                for (int i = 0; i < _keyWordArr1.count; i++) {
//                                    if ([_keyWordArr1[i] isEqualToString:strn1]) {
//                                        [_keyWordArr1 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr1 addObject:markNames];
//                            }
//                            else
//                            {
//                                [_keyWordArr1 addObject:markNames];
//                            }
//                        }else if (indexPath.section == 1){
//                            if (_keyWordArr2.count > 0) {
//                                for (int i = 0; i < _keyWordArr2.count; i++) {
//                                    if ([_keyWordArr2[i] isEqualToString:strn1]) {
//                                        [_keyWordArr2 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr2 addObject:markNames];
//                            }else{
//                                [_keyWordArr2 addObject:markNames];
//                            }
//                        }else{
//                            if (_keyWordArr3.count > 0) {
//                                for (int i = 0; i < _keyWordArr3.count; i++) {
//                                    if ([_keyWordArr3[i] isEqualToString:strn1]) {
//                                        [_keyWordArr3 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr3 addObject:markNames];
//                            }
//                            else
//                            {
//                                [_keyWordArr3 addObject:markNames];
//                            }
//                        }
//                        strn1 = markNames;
//                        [cell.addButton1 setTitle:markNames forState:UIControlStateNormal];
//                    }else{
//                        [cell.addButton1 setTitle:strn1 forState:UIControlStateNormal];
//                    }
//                }else if ([strs floatValue] == cell.addButton2.tag) {
//                    [cell.addButton2 setImage:nil forState:UIControlStateNormal];
//                    cell.addButton2.layer.borderWidth = 1;
//                    cell.addButton2.layer.borderColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1].CGColor;
//                    cell.addButton2.layer.masksToBounds = YES;
//                    cell.addButton2.layer.cornerRadius = 5;
//                    cell.addButton2.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(cell.addButton2)/3];
//                    if ([strs floatValue] == [tags floatValue]) {
//                        if (indexPath.section == 0) {
//                            if (_keyWordArr1.count > 0) {
//                                for (int i = 0; i < _keyWordArr1.count; i++) {
//                                    if ([_keyWordArr1[i] isEqualToString:strn2]) {
//                                        [_keyWordArr1 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr1 addObject:markNames];
//                            }
//                            else
//                            {
//                                [_keyWordArr1 addObject:markNames];
//                            }
//                        }
//                        else if (indexPath.section == 1)
//                        {
//                            if (_keyWordArr2.count > 0) {
//                                for (int i = 0; i < _keyWordArr2.count; i++) {
//                                    if ([_keyWordArr2[i] isEqualToString:strn2]) {
//                                        [_keyWordArr2 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr2 addObject:markNames];
//                            }
//                            else
//                            {
//                                [_keyWordArr2 addObject:markNames];
//                            }
//                        }else{
//                            if (_keyWordArr3.count > 0) {
//                                for (int i = 0; i < _keyWordArr3.count; i++) {
//                                    if ([_keyWordArr3[i] isEqualToString:strn2]) {
//                                        [_keyWordArr3 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr3 addObject:markNames];
//                            }
//                            else
//                            {
//                                [_keyWordArr3 addObject:markNames];
//                            }
//                        }
//                        strn2 = markNames;
//                        [cell.addButton2 setTitle:markNames forState:UIControlStateNormal];
//                    }else{
//                        [cell.addButton2 setTitle:strn2 forState:UIControlStateNormal];
//                    }
//                }else if ([strs floatValue] == cell.addButton3.tag){
//                    [cell.addButton3 setImage:nil forState:UIControlStateNormal];
//                    cell.addButton3.layer.borderWidth = 1;
//                    cell.addButton3.layer.borderColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1].CGColor;
//                    cell.addButton3.layer.masksToBounds = YES;
//                    cell.addButton3.layer.cornerRadius = 5;
//                    cell.addButton3.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(cell.addButton3)/3];
//                    
//                    if ([strs floatValue] == [tags floatValue]) {
//                        if (indexPath.section == 0) {
//                            if (_keyWordArr1.count > 0) {
//                                for (int i = 0; i < _keyWordArr1.count; i++) {
//                                    if ([_keyWordArr1[i] isEqualToString:strn3]) {
//                                        [_keyWordArr1 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr1 addObject:markNames];
//                            }else{
//                                [_keyWordArr1 addObject:markNames];
//                            }
//                        }else if (indexPath.section == 1){
//                            if (_keyWordArr2.count > 0) {
//                                for (int i = 0; i < _keyWordArr2.count; i++) {
//                                    if ([_keyWordArr2[i] isEqualToString:strn3]) {
//                                        [_keyWordArr2 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr2 addObject:markNames];
//                            }else{
//                                [_keyWordArr2 addObject:markNames];
//                            }
//                        }else{
//                            if (_keyWordArr3.count > 0) {
//                                for (int i = 0; i < _keyWordArr3.count; i++) {
//                                    if ([_keyWordArr3[i] isEqualToString:strn3]) {
//                                        [_keyWordArr3 removeObjectAtIndex:i];
//                                    }
//                                }
//                                [_keyWordArr3 addObject:markNames];
//                            }else{
//                                [_keyWordArr3 addObject:markNames];
//                            }
//                        }
//                        
//                        strn3 = markNames;
//                        [cell.addButton3 setTitle:markNames forState:UIControlStateNormal];
//                        
//                    }else{
//                        [cell.addButton3 setTitle:strn3 forState:UIControlStateNormal];
//                    }
//                }
//            }
//        }
//    }
//    
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return WIDTH(self.view)/9;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return WIDTH(self.view)/8;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/5)];
//    headerV.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(12, HEIGHT(headerV)*2/5-(HEIGHT(headerV)/5)/2, (HEIGHT(headerV)/5)*4, HEIGHT(headerV)/5)];
//    label.font = [UIFont systemFontOfSize:HEIGHT(label)];
//    label.textColor = [UIColor colorWithHexString:@"666666"];
//    label.text = @"必须条件";
//    [headerV addSubview:label];
//    return headerV;
//}

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
