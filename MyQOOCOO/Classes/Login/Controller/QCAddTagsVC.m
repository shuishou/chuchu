//
//  QCAddTagsVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/12.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCAddTagsVC.h"
#import "QCTagBtn.h"
#import "QCTag.h"


@interface QCAddTagsVC ()<UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGFloat _maxTitleHeight;
}
 /** 自定义的标签*/
@property (nonatomic , strong)NSMutableArray *customTagsArray;
 /** 标签标题*/
@property (nonatomic , strong)NSMutableArray *tagTitles;
@property (nonatomic , strong)UIImageView *avatarView;
@property (nonatomic , strong)UIPickerView *pickerView;
@property (nonatomic , strong)NSMutableArray *defaultTagsArray;


@end

@implementation QCAddTagsVC
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"添加标签";
    [self setupTitles];//默认标签
    
    //人物头像
    [self setupAvatar];
    //右键保存
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"完成" target:self action:@selector(saveToPath)];
    //左键放回,通知保存
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(backTo)];
    
    //展示标签
    [self setupCustomTags];
}
#pragma mark - 懒加载
-(NSMutableArray *)tagsArray{
    if (!_tagsArray) {
        _tagsArray = [[NSMutableArray alloc]initWithObjects:@"身高",@"年龄",@"星座",@"爱好",@"特长",@"性格",@"职业",@"文化程度", nil];
    }
    return _tagsArray;
}
-(NSMutableArray *)customTagsArray{
    if (!_customTagsArray) {
        //从本地数据plist文件去读取
//        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
//        NSString *path = [array objectAtIndex:0];
//        NSString *filePath = [path stringByAppendingPathComponent:@"customTags.plist"];
//        _customTagsArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        _customTagsArray = [[NSMutableArray alloc]init];
    }
    return _customTagsArray;
}
-(NSMutableArray *)tagTitles{
    if (!_tagTitles) {
        _tagTitles = [[NSMutableArray alloc]init];;
    }return _tagTitles;
}
-(NSMutableArray *)defaultTagsArray{
    if (!_defaultTagsArray) {
        NSString *arrayPath = [[NSBundle mainBundle]pathForResource:@"infoList.plist" ofType:nil];
        _defaultTagsArray = [[NSMutableArray alloc] initWithContentsOfFile:arrayPath];
        
    }
    return _defaultTagsArray;
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请保存标签" message:nil delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
//    alertView.tag = 0;
//    [alertView show];
}

/** 数据保存到本地plist *** */
-(void)saveToPath{
//    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
//    NSString *path = [array objectAtIndex:0];
//    NSString *filePath = [path stringByAppendingPathComponent:@"customTags.plist"];
//    CZLog(@"%@",filePath);
//    [self.customTagsArray writeToFile:filePath atomically:YES];
//    CZLog(@"%@",self.customTagsArray);
//    //定义一个刷新的通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:kTagsHavedChange object:nil];
    if (self.tagsBlock) {
        self.tagsBlock(self.customTagsArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 自定义标题 *** */
-(void)setupTitles{
    CGFloat startX = 12;
    CGFloat startY = 64 + 12;
    for (int i = 0; i < self.tagsArray.count; i++) {
        NSString *tagString = self.tagsArray[i];
        QCTagBtn *tagBtn = [[QCTagBtn alloc]initWithFrame:CGRectMake(startX, startY, 0, 0) btnString:tagString];
        tagBtn.tag = i;
        [tagBtn addTarget:self action:@selector(SelectedTags:) forControlEvents:UIControlEventTouchUpInside];
        
        //        [self.view addSubview:tagBtn];
        //判断是否超出屏幕
        startX += (CGRectGetWidth(tagBtn.frame) + 12);
        if (startX > SCREEN_W - 12) {
            startX = 12;
            startY += (CGRectGetHeight(tagBtn.frame) + 12);
            tagBtn.frame = CGRectMake(startX, startY, CGRectGetWidth(tagBtn.frame), CGRectGetHeight(tagBtn.frame));
            startX += (CGRectGetMaxX(tagBtn.frame) + 12);
            startY = CGRectGetMinY(tagBtn.frame);
        }
        [self.view addSubview:tagBtn];
    }
    if (startX + 30 > SCREEN_W -12) {
        startX = 12;
        startY += 42;
    }
    _maxTitleHeight = startY;
    CZLog(@"%lf",_maxTitleHeight);
    
    UIButton *addTagBtn = [[UIButton alloc]initWithFrame:CGRectMake(startX, startY + 2, 27, 27)];
    [addTagBtn setImage:[UIImage imageNamed:@"add1"] forState:UIControlStateNormal];
    [addTagBtn addTarget:self action:@selector(addCustomTag) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addTagBtn];
}

//弹出标签选择器
-(void)SelectedTags:(QCTagBtn *)tagBtn{
    self.avatarView.hidden = YES;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIPickerView class]]) {
            [view removeFromSuperview];
        }
    }

    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_H - 162, SCREEN_W, 162)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.tag = tagBtn.tag;
    
    [self.view addSubview:pickerView];
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *currentArray = self.defaultTagsArray[pickerView.tag];
    
    return currentArray.count;
}
//每行没列显示什么内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *name = self.defaultTagsArray[pickerView.tag][row];
    return name;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSArray *frms;
//    // 1
//    CGRectContainsPoint(<#CGRect rect#>, <#CGPoint point#>)
    NSString *name = self.defaultTagsArray[pickerView.tag][row];
    [self.tagTitles addObject:name];
    self.avatarView.hidden = NO;
    [self setupCustomTags];
    [pickerView setHidden:YES];
    
}
/** 自定义标签 *** */

-(void)setupCustomTags{
    [self.customTagsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.customTagsArray removeAllObjects];
    
    for (int i = 0; i < self.tagTitles.count; i++) {
        NSString *tagString = self.tagTitles[i];
        QCTag *customTag = [[QCTag alloc]initWithFrame:CGRectZero qcTag:tagString];
        //为了让标签不重叠
//        do {
//           customTag.frame = [self randomFrameForTag:customTag];
//        } while ([self frameIntersects:customTag.frame]);
        
        customTag.frame = [self randomFrameForTag:customTag];
        
        [self.customTagsArray addObject:customTag];
        [self.view addSubview:customTag];
    }
}
-(CGRect)randomFrameForTag:(QCTag *)customTag{
    [customTag sizeToFit];
    CGFloat minX = 12;
    CGFloat minY = _maxTitleHeight + 24;
    CGFloat maxX = self.view.width - customTag.width -minX ;
    CGFloat maxY = self.view.height - customTag.height -minY;
    
    //位置的随机范围
    
    return CGRectMake((rand()%(NSInteger)maxX + minX), (rand()%(NSInteger)maxY + minY ), CGRectGetWidth(customTag.frame), CGRectGetHeight(customTag.frame));
}
//- (BOOL)frameIntersects:(CGRect)frame {
//    
//    for (QCTag *customTag in self.customTagsArray) {
//        if (CGRectIntersectsRect(frame, customTag.frame)) {
//            return YES;
//        }
//    }
//    return NO;
//}

/** 任务头像 **** */
-(void)setupAvatar{
    UIImageView *avatarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"man"]];
    avatarView.size = CGSizeMake(89, 229);
    avatarView.center = CGPointMake(SCREEN_W / 2, SCREEN_H - avatarView.height / 2);
    self.avatarView = avatarView;
    
    [self.view addSubview:avatarView];
}
/** 自定义标签 **** */
-(void)addCustomTag{
    UIAlertView *customTagView = [[UIAlertView alloc]initWithTitle:@"自定义标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    customTagView.alertViewStyle = UIAlertViewStylePlainTextInput;//alertView的输入形式
    customTagView.tag = 1;
    [customTagView show];
}


#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {//自定义标签
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];//去除alertView里面的数据
            if (textField.text != nil) {
                [self.tagTitles addObject:textField.text];
            }
            [self setupCustomTags];
        }
    }else if( alertView.tag == 0){//放回上一层
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1){
            [self saveToPath];
        }
    }
}



@end
