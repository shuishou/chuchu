//
//  QCPersonInfo.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/7.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCPersonInfoVC.h"
#import "QCLoginVC.h"
#import "QCTabBarController.h"
#import "QCPersonInfoCell.h"
#import "MMPickerView.h"
//弹出菜单
#import "DownSheet.h"
#import "DownSheetModel.h"
//城市选择器
#import "CityListViewController.h"
//标签
#import "QCTag.h"
#import "QCAddTagsVC.h"

@interface QCPersonInfoVC()<UITableViewDataSource,UITableViewDelegate,DownSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    QCBaseTableView *_tableView;
    UIButton *_iconBtn;
    
    UITextField *_sexText;
    UITextField *_cityText;
    

    
}
@property (nonatomic , strong)NSMutableArray  *friendTagsArray;
@end

@implementation QCPersonInfoVC
#pragma mark - 懒加载
-(NSMutableArray *)friendTagsArray{
    if (!_friendTagsArray) {
        //查找路径
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
        NSString *path = [array objectAtIndex:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"customTags.plist"];
        _friendTagsArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    return _friendTagsArray;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //导航栏
    [self setupNav];
    //内容
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    _tableView.scrollEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //监听标签变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(referenceTags) name:kTagsHavedChange object:nil];
    
    //交友标签
//    _friendTagsArray = [[NSMutableArray alloc]initWithObjects:@"身高175cm",@"身高175",@"身高175cm",@"高大上有内涵",@"月光族",@"身高175",@"身高175cm",@"身高175cm",@"身高175cm",@"身高1",nil];
    
    
}
#pragma mark - 完善个人资料
-(void)setupNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePersonInfo)];
    self.navigationItem.rightBarButtonItem.tintColor = normalItemColor;
    
    
    UIImage *image = [UIImage imageNamed:@"Arrow"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
    
    self.navigationItem.title = @"完善个人资料";
}


#pragma mark - 刷新标签
-(void)referenceTags{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    //查找路径
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
    NSString *path = [array objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"customTags.plist"];
    _friendTagsArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }

}
//每个cell里面的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Infocell";
    QCPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
                    cell = [[QCPersonInfoCell alloc]initWithname:@"昵称" placeHolder:@"必填"];
                    

                }
                    break;
                case 1:{
                    
                    cell =[[QCPersonInfoCell alloc]initWithname:@"性别" placeHolder:@"必填"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.inputTextField.userInteractionEnabled = NO;
                    
                }
                    break;
                case 2:{
                    
                    cell = [[QCPersonInfoCell alloc]initWithname:@"地址" placeHolder:@"请选择"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.inputTextField.userInteractionEnabled = NO;
                }
                    break;
                default:
                    break;
            }
        }
        
        
        if (indexPath.section == 1) {
            UIView *FriendTagsview = [self makeFriendTagsView];
            cell = (QCPersonInfoCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanDeleteStatus:)]];
            for (UIView * subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
            [cell.contentView addSubview:FriendTagsview];
        }
       
    }
    
    return cell;
}
#pragma mark - 交友标签
-(UIView *)makeFriendTagsView{
    CGFloat bgViewH = [self getFriendTagsHight];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, bgViewH)];
    bgView.backgroundColor = kGlobalBackGroundColor;
    CGFloat maxX = 12;
    CGFloat startY = 12;
    for (int i = 0; i<_friendTagsArray.count; i++) {
        NSString * tag = _friendTagsArray[i];
        QCTag * tagView = [[QCTag alloc]initWithFrame:CGRectMake(maxX, startY, 0, 0) qcTag:tag];
        tagView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        tagView.tag = i;
        tagView.delegate = self;
        [bgView addSubview:tagView];
        maxX += CGRectGetWidth(tagView.frame)+12;
        if (maxX>SCREEN_W-12) {
            maxX = 12;
            startY += (CGRectGetHeight(tagView.frame)+12);
            tagView.frame = CGRectMake(maxX, startY, CGRectGetWidth(tagView.frame), CGRectGetHeight(tagView.frame));
            maxX += CGRectGetWidth(tagView.frame)+12;
            startY = CGRectGetMinY(tagView.frame);
        }
    }
    //添加标签按钮
    if (maxX + 90 +12 > SCREEN_W -12) {
        maxX = 12;
        startY += 42;
    }
    UIButton *addTagBtn = [[UIButton alloc]initWithFrame:CGRectMake(maxX, startY, 90, 30)];
    [addTagBtn setImage:[UIImage imageNamed:@"Add_tags"] forState:UIControlStateNormal];
    [addTagBtn addTarget:self action:@selector(addTagsClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addTagBtn];

    
    return bgView;
}

-(float)getFriendTagsHight{
    CGFloat startY = 12;
    CGFloat maxX = 12;
    for (int i = 0; i<_friendTagsArray.count; i++) {
        NSString * tag = _friendTagsArray[i];
        QCTag * tagView = [[QCTag alloc]initWithFrame:CGRectMake(maxX, startY, 0, 0) qcTag:tag];
        tagView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        maxX += CGRectGetWidth(tagView.frame)+12;
        if (maxX>SCREEN_W-12) {
            maxX = 12;
            startY += (CGRectGetHeight(tagView.frame)+12);
            tagView.frame = CGRectMake(maxX, startY, CGRectGetWidth(tagView.frame), CGRectGetHeight(tagView.frame));
            maxX += CGRectGetWidth(tagView.frame)+12;
            startY = CGRectGetMinY(tagView.frame);
        }
    }
    if (maxX + 90 +12 > SCREEN_W -12) {
        maxX = 12;
        startY += 42;
    }

    return startY + 42;
}
-(void)tagView:(QCTag *)tagView longPressIndex:(NSInteger)index{
    
}

-(void)addTagsClick{
    QCAddTagsVC *addTagsVC = [[QCAddTagsVC alloc]init];
    addTagsVC.tagsBlock = ^(NSArray *tags){
        //处理
    };
    [self.navigationController pushViewController:addTagsVC animated:YES];
    
}
/* ** 删除标签代理 ** */
-(void)tagView:(QCTag *)tagView deleteTagView:(NSInteger)index{
    //先从数组删除,在删除刷新
    [_friendTagsArray removeObjectAtIndex:index];
//    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                              
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}
/** 清除所有标签删除模式 */
-(void)cleanDeleteStatus:(UITapGestureRecognizer *)sender{
    UIView * contentView = sender.view;
    for (QCTag * subView in [contentView.subviews[0] subviews]) {
        if ([subView isKindOfClass:[QCTag class]]) {
            [subView showDelegateButton:NO];
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //
        }else if (indexPath.row == 1) {//性别选择
            UIActionSheet *sexSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            sexSheet.tintColor = normalItemColor;

            
            [sexSheet showInView:self.view];
            
            //城市选择
        }else if (indexPath.row == 2){
            CityListViewController *cityViewCtrl = [[CityListViewController alloc] initWithChoose:^(NSString *cityName) {
                QCPersonInfoCell * cell = (QCPersonInfoCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                cell.inputTextField.text = cityName;
            }];
            
            [self.navigationController pushViewController:cityViewCtrl animated:YES];

        }
    }
    
}
#pragma mark - 性别选择
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //
        QCPersonInfoCell *cell = (QCPersonInfoCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.inputTextField.text = @"男";
    }else if (buttonIndex == 1){
        //
        QCPersonInfoCell *cell = (QCPersonInfoCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.inputTextField.text = @"女";
    }
}

#pragma mark - tableViewDataSourceAndDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 152;
    }else {
        return 30;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *customHeaderView;
    
    if (section == 0) {
        
        customHeaderView = [[UIView alloc] init];
        _iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W / 2 -42, 34, 84, 84)];
        _iconBtn.backgroundColor = [UIColor whiteColor];
        //设置为圆形
        _iconBtn.layer.cornerRadius = _iconBtn.frame.size.width / 2;
        _iconBtn.clipsToBounds = YES;
        
        //占位图
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"user_black"] forState:UIControlStateNormal];
        [_iconBtn setContentMode:UIViewContentModeScaleAspectFit];
        [_iconBtn addTarget:self action:@selector(changeUserImage) forControlEvents:UIControlEventTouchUpInside];
        
        [customHeaderView addSubview:_iconBtn];
        
    }else if (section == 1){
        
        customHeaderView = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_W, 30)];
        
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = @"交友标签";
        
        [customHeaderView addSubview:titleLabel];
    }

    return customHeaderView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 44.0;
    if (indexPath.section == 0) {
        height = 44.0;
    }else if (indexPath.section == 1){
        height = [self getFriendTagsHight];
    }
    return height;
}

#pragma mark - 换头像
-(void)changeUserImage{
    
    DownSheetModel *model_1 = [[DownSheetModel alloc] init];
    model_1.icon = @"photo";
    model_1.title = @"从相册选择";
    
    DownSheetModel *model_2 = [[DownSheetModel alloc] init];
    model_2.icon = @"camera";
    model_2.title = @"拍照";
//    DownSheetModel *model_3 = [[DownSheetModel alloc] init];
//    model_3.icon = nil;
//    model_3.title = @"取消";

    NSArray *model = @[model_1, model_2];
    DownSheet *sheet = [[DownSheet alloc]initWithlist:model height:0];
    sheet.delegate = self;
    [sheet showInView:self];
}

//弹出菜单代理
-(void)didSelectSection:(NSInteger)section index:(NSInteger)index{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    if (index == 0) {
       imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else if(index == 1){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
//完成选择后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //1,获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //
    [_iconBtn setImage:image forState:UIControlStateNormal];
   
    
    //退出图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - textFieldDelegate
-(void)didSelectedTextFieldRow:(NSInteger)index{
    
    if (index == 2) {
        CityListViewController *cityViewCtrl = [[CityListViewController alloc] initWithChoose:^(NSString *cityName) {
            QCPersonInfoCell * cell = (QCPersonInfoCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.inputTextField.text = cityName;
        }];
        
        [self.navigationController pushViewController:cityViewCtrl animated:YES];
    }else if (index == 1){
        CZLog(@"%ld",(long)index);
    }else if (index == 0){
        CZLog(@"%ld",(long)index);
    }
    

}


//返回
-(void)backTo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)savePersonInfo{
    //1,保存个人信息
    
//    2回到登陆界面(直接跳到主页)
    QCTabBarController *mainVC = [[QCTabBarController alloc]init];
    [self presentViewController:mainVC animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
