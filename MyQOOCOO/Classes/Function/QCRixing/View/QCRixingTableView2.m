//
//  QCRixingTableView2.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/1.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#define kCellHeight 44;

#import "QCRixingTableView2.h"

@interface QCRixingTableView2()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView *dateLabelView;
@property (nonatomic , strong)UIView *titleLabelView;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *contentArray;
@property (nonatomic , strong)UITableViewCell *addContentCell;

@end

@implementation QCRixingTableView2

-(NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithObjects:@"心情",@"学习",@"帮人",@"为人处事",@"工作",@"陪伴家人", nil];
    }
    return _contentArray;
}

//- (id)initWithData:(NSArray *)dArray trDictionary:(NSDictionary *)trDict size:(CGSize)size scrollMethod:(ScrollMethod)sm leftDataKeys:(NSArray *)leftDataKeys rightDataKeys:(NSArray *)rightDataKeys{
//    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height) ]) {
//        
//        
//    }
//    
//    return self;
//}



-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        _contentArray = [NSMutableArray arrayWithObjects:@"心情",@"学习",@"帮人",@"为人处事",@"工作",@"陪伴家人",@"心情",@"学习",@"帮人",@"为人处事",@"工作",@"陪伴家人", nil];
        self.height  = (_contentArray.count + 2) * kCellHeight;
        
    }
    
    return self;
}


#pragma mark - tableViewDataSourceAndDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count + 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"RixingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"你好";
    }
    if (indexPath.row == _contentArray.count + 1) {
        cell.imageView.image = [UIImage imageNamed:@"addshi"];
        cell.textLabel.text = @"添加日省项";
    }
    
    return cell;
}


@end
