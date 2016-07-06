//
//  PopViewController.m
//  PopView
//
//  Created by wzp on 15/10/14.
//  Copyright © 2015年 wzp. All rights reserved.
//

#import "PopViewController.h"
#import "Masonry.h"

@implementation PopViewController{
    UITableView * _tableView;
    NSArray * _items;
    void(^_selevtedBlock)(NSInteger);
}
-(instancetype)initWithItems:(NSArray *)items{
    if (self = [super initWithFrame:CGRectZero]) {
        _items = items;
        
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        [self addSubview:_tableView];
        _tableView.layer.cornerRadius = 4;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.borderColor = [UIColor colorWithHexString:@"E0E0E0"].CGColor;
    }
    return self;
}
-(void)showInView:(UIView *)view selectedIndex:(void (^)(NSInteger))selectedBlock{
    _show = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _selevtedBlock = selectedBlock;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];

    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(@(44*_items.count));
        make.left.equalTo(self.mas_right).offset(-150);
    }];
   
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _items[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
        _selevtedBlock(indexPath.row);
    });
}

-(void)dismiss{
    _show = NO;
    [self removeFromSuperview];

}


@end
