//
//  LunKuViewController.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/22.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//



//论库类型（1明星名人，2动漫，3游戏，4文学艺术，5体育，6教育人文，7娱乐，8时尚生活，9军事科学，10数码科技，11情感）
typedef NS_ENUM(NSInteger , kLunkuType){
    kLunkuTypeStar = 1,kLunkuTypeAnime = 2,kLunkuTypeGame = 3,kLunkuTypeArt = 4,kLunkuTypeSport = 5,kLunkuTypeTeach = 6,kLunkuTypeAmusement = 7,kLunkuTypeFashionlife = 8,kLunkuTypeWar = 9,kLunkuTypeIT = 10,kLunkuTypeEmotion = 11
};

#import "QCLKCommentTableView.h"

@interface QCLunKuViewController : UIViewController{
     /** 明星名人*/
    QCLKCommentTableView *_starTV;
     /** 动漫*/
    QCLKCommentTableView *_animeTV;
     /** 游戏*/
    QCLKCommentTableView *_gameTV;
     /** 文学艺术*/
    QCLKCommentTableView *_artTV;
     /** 体育*/
    QCLKCommentTableView *_sportTV;
     /** 教育*/
    QCLKCommentTableView *_teachTV;
     /** 娱乐*/
    QCLKCommentTableView *_amusementTV;
     /** 时尚生活*/
    QCLKCommentTableView *_lifeTV;
     /** 军事*/
    QCLKCommentTableView *_warTV;
     /** 数码科技*/
    QCLKCommentTableView *_itTV;
     /** 情感*/
    QCLKCommentTableView *_emotionTV;
}

@property(nonatomic,strong)NSString*uid;


@end
