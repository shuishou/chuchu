//
//  XSBaseTableView.m
//  XSTeachEDU
//
//  Created by xsteach on 14/12/4.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import "QCBaseTableView.h"

@implementation QCBaseTableView  

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorColor = kSeparatorColor;//设置分割线的颜色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//xib创建
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"SpaceCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)addFooterNoMoreDataWithTitle:(NSString *)hine{
    [self removeFooter];
    self.tableFooterView = nil;
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)];
    label.text = hine;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    self.tableFooterView = label;
}




-(void)removeNoMoreDataFooter{
    self.tableFooterView = nil;
}
-(void)addFooterNoData{
    self.tableFooterView = nil;
    UIView * nodataView = [[UIView alloc]initWithFrame:self.bounds];
    UIImage * image = [UIImage imageNamed:@"noData_img"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.center = CGPointMake(CGRectGetCenter(nodataView.bounds).x, CGRectGetCenter(nodataView.bounds).y-75);
    imageView.image = image;
    [nodataView addSubview:imageView];
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, CGRectGetWidth(self.bounds), 13)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor colorWithHex:0xacacac];
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = @"空空如也,再去逛逛吧!";
    lable.textAlignment = NSTextAlignmentCenter;
    [nodataView addSubview:lable];
    self.tableFooterView = nodataView;
}

-(void)addFooterNoDataWithTitle:(NSString *)hine withImageName:(NSString *)imageName{
    self.tableFooterView = nil;
    UIView * nodataView = [[UIView alloc]initWithFrame:self.bounds];
    UIImage * image = [UIImage imageNamed:imageName];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.center = CGPointMake(CGRectGetCenter(nodataView.bounds).x, CGRectGetCenter(nodataView.bounds).y-75);
    imageView.image = image;
    [nodataView addSubview:imageView];
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, CGRectGetWidth(self.bounds), 13)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor colorWithHex:0xacacac];
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = hine;
    lable.textAlignment = NSTextAlignmentCenter;
    [nodataView addSubview:lable];
    self.tableFooterView = nodataView;
}
-(void)addFooterNoDataWithTitle:(NSString *)hine withSubTitle:(NSString *)subHine withImage:(NSString *)imageName{
    self.tableFooterView = nil;
    UIView * nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    nodataView.backgroundColor = [UIColor colorWithHex:0xf4fbff];
    UIImage * image;
    CGFloat  labelStart = 0;
    
    if ([imageName isEqualToString:@"default"]) {
         image = [UIImage imageNamed:@"default_nodata"];
    }else if(imageName.length==0){
        image = nil;//这里是为iPhone4 准备的 因为屏幕太小显示不下  所以直接暴力不要提示图片 只要文字
        labelStart = (SCREEN_H - 250-64)/2-40;
    }else{
        image = [UIImage imageNamed:imageName];
    }
    
    
    UIImageView * imageView;
    
    if (image!=nil) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.center = CGPointMake(CGRectGetCenter(nodataView.bounds).x, CGRectGetCenter(nodataView.bounds).y-40);
        imageView.image = image;
        [nodataView addSubview:imageView];
        labelStart = CGRectGetMaxY(imageView.frame);
    }
    
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, labelStart+20, CGRectGetWidth(self.bounds), 16)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor colorWithHex:0x1d1d1d];
    lable.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16.0f];
    lable.text = hine;
    lable.textAlignment = NSTextAlignmentCenter;
    [nodataView addSubview:lable];
    self.tableFooterView = nodataView;
    
    
    UILabel * subLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame)+10, CGRectGetWidth(self.bounds), 12)];
    subLable.backgroundColor = [UIColor clearColor];
    subLable.textColor = [UIColor colorWithHex:0x797979];
    subLable.font = [UIFont systemFontOfSize:12];
    subLable.text = subHine;
    subLable.textAlignment = NSTextAlignmentCenter;
    [nodataView addSubview:subLable];
}
-(void)removeNoDataFooter{
    self.tableFooterView = nil;
}

@end
