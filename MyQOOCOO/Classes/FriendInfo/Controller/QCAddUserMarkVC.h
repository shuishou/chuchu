//
//  QCAddUserMarkVC.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCSeniorModel.h"
#import "CaptureViewController.h"

@interface QCAddUserMarkVC : QCBaseVC<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,captureViewControllerDelegate>
{

    NSMutableArray *seniorArr;//存高级标签
    NSMutableArray *codeArr;//普通标签总数组
    NSMutableArray *hotArr;//普通推荐
    NSMutableArray *commonArr;//存普通标签
    
    UIImage *photoige;
    
    NSMutableArray *qiniuUrlArr;//高级标签的七牛url
}

@property(nonatomic,assign)NSInteger groupId;

@property(nonatomic,assign)NSInteger uid;

@property(nonatomic,strong)NSString *describeStr;

@property(nonatomic,strong)NSString *boxTitle;

@property(nonatomic,assign)BOOL isADD;

@property(nonatomic,strong)QCSeniorModel *mod;

@property(nonatomic,assign)BOOL istype;//照片或视频

@property(nonatomic,assign)NSInteger groupType;

@end
