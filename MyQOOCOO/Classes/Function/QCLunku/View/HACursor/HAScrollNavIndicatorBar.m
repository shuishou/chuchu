//
//  HAScrollNavIndicatorBar.m
//  MyQOOCOO
//
//  Created by Zhou Shaolin on 16/7/8.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "HAScrollNavIndicatorBar.h"
#import "UIView+Extension.h"
#import "UIColor+RGBA.h"
#import "HAItemManager.h"
#import "QCCursorButton.h"

#define ItemWidth                 75
#define FontMinSize               10
#define FontDetLeSize             7
#define FontDefSize               15
#define StaticItemIndex           3
#define scrollNavBarUpdate        @"scrollNavBarUpdate"
#define rootScrollUpdateAfterSort @"updateAfterSort"
#define moveToSelectedItem        @"moveToSelectedItem"
#define moveToTop                 @"moveToTop"

@interface HAScrollNavIndicatorBar()<UIScrollViewDelegate>

@property (nonatomic, weak) QCCursorButton *firstButton;
@property (nonatomic, weak) QCCursorButton *secButton;

@property (nonatomic, strong) NSMutableDictionary *tmpPageViewDic;

@property (nonatomic, strong) NSMutableDictionary *itemsDic;
@property (nonatomic, strong) NSMutableArray      *tmpKeys;

@property (nonatomic, assign) BOOL                isLayoutitems;
@property (nonatomic, assign) BOOL                isHiddenAllItem;

@property (nonatomic, assign) NSInteger           currctIndex;

@end

@implementation HAScrollNavIndicatorBar

#pragma mark - 懒加载

- (NSMutableArray *)tmpKeys{
    if (!_tmpKeys) {
        _tmpKeys = [NSMutableArray array];
    }
    return _tmpKeys;
}

- (NSMutableDictionary *)itemsDic{
    if (!_itemsDic) {
        _itemsDic = [NSMutableDictionary dictionary];
    }
    return _itemsDic;
}

- (NSMutableDictionary *)tmpPageViewDic{
    if (!_tmpPageViewDic) {
        _tmpPageViewDic = [NSMutableDictionary dictionary];
    }
    return _tmpPageViewDic;
}

#pragma mark - 属性配置
- (void)setItemKeys:(NSMutableArray *)itemKeys{
    _itemKeys = itemKeys;
    self.tmpKeys = itemKeys;
    if(self.itemsDic.count == 0){
        [self setupItems];
    }
}

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
}

- (void)setupTmpPageViewDic{
    for (int i = 0; i < self.tmpKeys.count; i++) {
        [self.tmpPageViewDic setObject:self.pageViews[i] forKey:self.tmpKeys[i]];
    }
}

- (void)setOffsetX:(CGFloat)offsetX{
    _offsetX = self.contentOffset.x;
}

- (void)setRootScrollView:(HARootScrollView *)rootScrollView{
    _rootScrollView = rootScrollView;
    _rootScrollView.delegate = self;
    _rootScrollView.pageViews = self.pageViews;
}

- (void)setItemsFontWithFontSize:(NSInteger)size{
    [self.itemsDic enumerateKeysAndObjectsUsingBlock:^(id key, QCCursorButton * obj, BOOL *stop) {
        obj.titleLabel.font = [UIFont systemFontOfSize:size];
    }];
}

#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)initNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitles:) name:scrollNavBarUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToSelectedItemAfterDelet:) name:moveToSelectedItem object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToTopAfterDelet:) name:moveToTop object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup{
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    [self initNotificationCenter];
}

- (void)setupItems{
    NSInteger itensCount = self.tmpKeys.count;
    for (NSInteger i = 0; i < itensCount; i++) {
        QCCursorButton *button = [self createItemWithTitle:self.tmpKeys[i]];
        button.normalColor = self.titleNormalColor;
        button.selectedColor = self.titleSelectedColor;
        [self.itemsDic setObject:button forKey:self.tmpKeys[i]];
        button.tag = i;
        if (i == 0) {
            button.selected = YES;
            
            _currectItem = button;
        }
    }
}

//对item进行布局处理
- (void)layoutButtons{
    self.contentSize = CGSizeMake(self.tmpKeys.count * ItemWidth, 0);
    CGFloat buttonW = ItemWidth;
    NSInteger itemsCount = self.tmpKeys.count;
    if (itemsCount * ItemWidth < self.width) {
        CGFloat width = self.isShowSortButton ? (self.width - self.height) : self.width;
        buttonW = width / itemsCount;
    }
    CGFloat buttonH = self.height;
    CGFloat buttonY = self.isItemHiddenAfterDelet ? self.height : 0;
    
    for (NSInteger i = 0; i < itemsCount; i++) {
        NSString *key = self.tmpKeys[i];
        QCCursorButton *button = [self.itemsDic objectForKey:key];
        button.tag = i;
        CGFloat buttonX = i * buttonW;
        CGRect frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        if(i == 0) {
            [button adjustFrame:frame mode:0];
        }
        else if(i == itemsCount - 1) {
            [button adjustFrame:frame mode:1];
        }
        else {
            [button adjustFrame:frame mode:2];
        }
        self.itemW = buttonW;
    }
    
    if (!self.isLayoutitems) {
        self.isLayoutitems = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutButtons];
}

#pragma mark - 业务逻辑
- (NSInteger)getIndexWithKey:(NSString *)key{
    return [self.itemKeys indexOfObject:key];
}

- (UIButton *)getItemWithIndex:(NSInteger)index{
    return [self.itemsDic objectForKey:self.tmpKeys[index]];
}

- (QCCursorButton *)createItemWithTitle:(NSString *)title{
    QCCursorButton *cursorButton = [[QCCursorButton alloc] initWithTitle:title];
//    NSInteger fontSize = FontMinSize;
//    cursorButton.mainButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [cursorButton.mainButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cursorButton];
    return cursorButton;
}

- (void)moveToTopAfterDelet:(NSNotification *)notificion{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton * button2 = [self getItemWithIndex:0];
        [self buttonClick:button2];
    });
}

- (void)moveToSelectedItemAfterDelet:(NSNotification *)notificion{
    UIButton * button = [self.itemsDic objectForKey:notificion.object];
    [self buttonClick:button];
}

- (void)updatePageView:(NSNotification *)notifition{
    if (notifition.object) {
        UIView *deletPageView = [self.tmpPageViewDic objectForKey:notifition.object];
        deletPageView.hidden = YES;
        [self.tmpPageViewDic removeObjectForKey:notifition.object];
    }
    int i = 0;
    NSMutableArray *tmpArray = [NSMutableArray array];
    self.rootScrollView.contentSize = CGSizeMake(self.tmpKeys.count * self.rootScrollView.width, 0);
    for (NSString *key in self.tmpKeys) {
        NSLog(@"key ---> %@  count ---> %ld",key,self.tmpKeys.count);
        UIView *pageView = [self.tmpPageViewDic objectForKey:key];
        [tmpArray addObject:pageView];
        i++;
    }
    self.rootScrollView.pageViews = tmpArray;
    [self.rootScrollView reloadPageViews];
}

- (void)updateTitles:(NSNotification *)notifition{
    [self updatePageView:notifition];
    [self layoutButtons];
}

- (void)addOffset{
    [self.rootScrollView setContentOffset:CGPointMake(1, 0)];
    [self.rootScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)clickButtonWhenNotGraduallyChangFont:(QCCursorButton *)button{
    _oldItem = _currectItem;
    
    _currectItem.selected = NO;
    button.selected = YES;
    _currectItem = button;
}

- (void)buttonClick:(UIButton *)button{
    QCCursorButton* cursorButton = (QCCursorButton*)button.superview;
    [self clickButtonWhenNotGraduallyChangFont:cursorButton];
    
    CGFloat offX = cursorButton.tag * self.rootScrollView.width;
    //    NSLog(@"off ---> %f",offX);
    [self buttonMoveAnimationWithIndex:cursorButton.tag];
    [self.rootScrollView setContentOffset:CGPointMake(offX, 0) animated:YES];
}

- (void)selectItemWhenNotGraduallyChangFont:(QCCursorButton *)button{
    _oldItem = _currectItem;
    
    _currectItem.selected = NO;
    button.selected = YES;
    _currectItem = button;

}

- (void)setSelectItemWithIndex:(NSInteger)index{
    QCCursorButton *button = [self.itemsDic objectForKey:self.tmpKeys[index]];
    [self selectItemWhenNotGraduallyChangFont:button];
    [self buttonMoveAnimationWithIndex:index];
}

- (void)buttonMoveAnimationWithIndex:(NSInteger)index{
    UIButton *selectButton = [self.itemsDic objectForKey:self.tmpKeys[index]];
    if (self.tmpKeys.count * self.itemW > self.width) {
        if (index < StaticItemIndex) {
            //x < 2 :前两个
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if(index > self.tmpKeys.count - StaticItemIndex - 1) {
            // x >= 8 - 3 - 1;
            [self setContentOffset:CGPointMake(self.contentSize.width - self.width, 0) animated:YES];
        }else{
            [self setContentOffset:CGPointMake(selectButton.center.x - self.center.x, 0) animated:YES];
        }
    }else{
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)setupNormalFontSizeItem{
//    self.firstButton.titleLabel.font = [UIFont systemFontOfSize:FontDefSize];
//    self.secButton.titleLabel.font = [UIFont systemFontOfSize:FontDefSize];
}

- (void)changeButtonFontWithOffset:(CGFloat)offset andWidth:(CGFloat)width{
    
    [self setupNormalFontSizeItem];
    
    CGFloat p = fmod(offset, width) /width;
    NSInteger index = offset / width;
    self.currctIndex = index;
    
    //    wo xie de -------------------------------
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kurrentTitleBtnTagNotification" object:nil userInfo:@{@"btnTag":@(index)}];
    if (self.isfree) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kurrentTitleBtnTagNotification2" object:nil userInfo:@{@"btnTag":@(index)}];
    }
    
    self.firstButton = [self.itemsDic objectForKey:self.tmpKeys[index]];
    self.secButton   = (index + 1 < self.tmpKeys.count) ? [self.itemsDic objectForKey:self.tmpKeys[index + 1]] : nil;
}

- (void)hiddenAllItems{
    if (!self.isHiddenAllItem) {
        [self setupTmpPageViewDic];
        self.isHiddenAllItem = YES;
    }
    for (int i = 0; i < self.tmpKeys.count; i++) {
        UIButton *button = [self getItemWithIndex:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.y = 2 * self.height;
            } completion:nil];
        });
    }
}

- (void)showAllItems{
    for (int i = 0; i < self.tmpKeys.count; i++) {
        UIButton *button = [self getItemWithIndex:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.y = 0;
            } completion:nil];
        });
    }
}

#pragma mark - scrollView代理方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self changeButtonFontWithOffset:scrollView.contentOffset.x andWidth:self.rootScrollView.width];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self changeButtonFontWithOffset:scrollView.contentOffset.x andWidth:self.rootScrollView.width];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger num = targetContentOffset->x / _rootScrollView.frame.size.width;
    [self setSelectItemWithIndex:num];
}
@end

