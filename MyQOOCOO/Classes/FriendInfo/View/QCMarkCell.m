//
//  QCMarkCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/5.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCMarkCell.h"

@interface QCMarkCell(){
    
}
@property (nonatomic , strong)NSMutableArray *bigMarks;//大标签数组
@property (nonatomic , strong)NSMutableArray *smallMarks;//小标签数组
@property (nonatomic , strong)UIButton *addMarksBtn;//添加标签按钮
@end

@implementation QCMarkCell

//假数据
-(NSMutableArray *)smallMarks{
    if (!_smallMarks) {
        _smallMarks = [NSMutableArray arrayWithObjects:@"11",@"222222",@"33",@"44444444",@"55555555555",@"6",@"77", nil];
    }
    return _smallMarks;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//创建内容


@end
