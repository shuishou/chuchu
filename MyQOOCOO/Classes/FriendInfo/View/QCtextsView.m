//
//  QCtextsView.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCtextsView.h"

//设置最多
#define kPictureMaxCount 30
//  都显示成几列
#define kMaxCol 4
#define kPicW ([UIScreen mainScreen].bounds.size.width - 20*2 - 5*4)/4  //图片宽度
#define kPicH 30 //高度
#define kPicMagin 5  // 间距

@implementation QCtextsView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        for (NSInteger i = 0; i < kPictureMaxCount ; i++) {
            QCtextV *lb =[[QCtextV alloc]init];
            
            
            lb.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textClick:)];
            [lb addGestureRecognizer:tap];
            lb.tag = i;
        
            
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
            [longPressGestureRecognizer addTarget:self action:@selector(longTouchItem:)];
            [longPressGestureRecognizer setMinimumPressDuration:1];
            [longPressGestureRecognizer setAllowableMovement:50.0];
            [lb addGestureRecognizer:longPressGestureRecognizer];

        
            [self addSubview:lb];
        }

        
    }
    
     return self;

}

+(CGSize)textViewSizeWithArrCount:(NSInteger)count
{
    

    if (count==0) { //没
        return CGSizeMake(0, 0);
    }
    
    //    最大显示列数
    NSInteger maxCol = kMaxCol;
    //    最大显示行数
    NSInteger row = count / maxCol;
    if (count % maxCol !=0) {
        row++;
    }
    CGFloat textW = (kPicW + kPicMagin) * maxCol - kPicMagin;
    CGFloat textH = (kPicH + kPicMagin) * row - kPicMagin;
    
    CGSize textSize = CGSizeMake(textW, textH);
    
    return textSize;

}

-(void)textClick:(UITapGestureRecognizer*)recognizer{
    
    NSLog(@"123");
    QCGetUserMarkModel *model=self.codeArr[recognizer.view.tag];
    
    if (isDelete) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"delete" object:nil userInfo:@{@"model":model}];
         isDelete = NO;
    }else{
        if (model.type==5) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpush" object:nil userInfo:@{@"groupId":@(model.groupId),@"groupType":@(self.indexpath.section)}];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVpushToText" object:nil userInfo:@{@"data":self.codeArr[recognizer.view.tag]}];
        }
    }
}

-(void)setCodeArr:(NSMutableArray *)codeArr
{
    _codeArr = codeArr;
    
    //    最大显示图片列数
    NSInteger maxCol = kMaxCol;
    
    for (NSInteger i = 0; i < kPictureMaxCount; i++) {
        QCtextV *lb = self.subviews[i];
        
        if (i < codeArr.count) {//有图片的显示
            lb.hidden = NO;
            //            计算真实存在的图片占用列数和行数
            CGFloat col = i % maxCol;
            CGFloat row = i / maxCol;
            //            计算子控件frame
            CGFloat pictureX = (kPicW + kPicMagin) * col;
            CGFloat pictureY = (kPicH + kPicMagin) * row;
            lb.frame = CGRectMake(pictureX, pictureY, kPicW, kPicH);
            
            //            给子控件的属性赋值（传数据）
            QCGetUserMarkModel*model= codeArr[i];
            lb.model = model;
            
            
        }else{//无图片的要隐藏起来
            lb.hidden = YES;
        }
    }
}


-(void)longTouchItem:(UILongPressGestureRecognizer*)longResture
{
    
    if (self.flag != 100) {
        if (longResture.state==UIGestureRecognizerStateBegan) {
            isDelete=YES;
            for (NSInteger i = 0; i < kPictureMaxCount; i++) {
                QCtextV*lb = self.subviews[i];
                
                if (i < self.codeArr.count) {//有图片的显示
                    
                    if (lb.model.type!=5) {
                        lb.deleteImage.hidden=NO;
                    }
                }
            }
        }else if(longResture.state==UIGestureRecognizerStateEnded){
            
        }

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
