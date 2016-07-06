//
//  EMChatBusinessCardBubbleView.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/24.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "EMChatBusinessCardBubbleView.h"

@interface EMChatBusinessCardBubbleView ()

@end

@implementation EMChatBusinessCardBubbleView


//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        //       [self creatreMyCell ];
        _bgImageV=[[UIImageView alloc]init];
        _bgImageV.userInteractionEnabled=YES;
        _bgImageV.multipleTouchEnabled = YES;

        _imageV=[[UIImageView alloc]init];
        _lb=[[UILabel alloc]init];
        self.userInteractionEnabled=YES;
        self.multipleTouchEnabled = YES;
//        UITapGestureRecognizer * bgVtap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bubbleViewPressed:)];
//        bgVtap.numberOfTapsRequired =1;
//        //        bgVtap.cancelsTouchesInView = NO;
//        [_bgImageV addGestureRecognizer:bgVtap];

    }
    return self;
}

-(void)setModel:(MessageModel *)model
{
    
    if (!_model) {
        
    _model = model;
    

    
    BOOL isReceiver = !_model.isSender;
    NSString *imageName = isReceiver ? BUBBLE_LEFT_IMAGE_NAME : BUBBLE_RIGHT_IMAGE_NAME;
    NSInteger leftCapWidth = isReceiver?BUBBLE_LEFT_LEFT_CAP_WIDTH:BUBBLE_RIGHT_LEFT_CAP_WIDTH;
    NSInteger topCapHeight =  isReceiver?BUBBLE_LEFT_TOP_CAP_HEIGHT:BUBBLE_RIGHT_TOP_CAP_HEIGHT;
    _bgImageV.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
  [self creatreMyCell ];
    }
}


-(void)creatreMyCell
{
//    _bgImageV=[[UIImageView alloc]init];
        [self addSubview:_bgImageV];
    
   
    

    if ([_model.content containsString:@"send_content_from_card_to_show"]) {
     NSArray *arr = [_model.content componentsSeparatedByString:@","];
    

        
        
        _imageV.backgroundColor=[UIColor clearColor];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:arr[1]] placeholderImage:[UIImage imageNamed:@"ios-template-1024"]];
    [_bgImageV addSubview:_imageV];
    

    _lb.backgroundColor=[UIColor grayColor];
    _lb.text=[NSString stringWithFormat:@"名片：%@",arr[2]];
    _lb.font=[UIFont systemFontOfSize:15];
    _lb.numberOfLines=0;
    _lb.textColor=[UIColor whiteColor];
    _lb.adjustsFontSizeToFitWidth = YES;
    _lb.minimumFontSize = 6;
    [_bgImageV addSubview:_lb];
    
    }
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    if (self.model.isSender) {
        
        _bgImageV.frame=CGRectMake(-25, 0,125, 160);
        _imageV.frame=CGRectMake(10, 10,100, 100);
        _lb.frame=CGRectMake(10, 110,100, 40);
        
    }else{
        _bgImageV.frame=CGRectMake(0, 0,125, 160);
        _imageV.frame=CGRectMake(15, 10,100, 100);
        _lb.frame=CGRectMake(15, 110,100, 40);

        }
    

    

    
    
}


+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object{
    return 160;

}


- (void)bubbleViewPressed:(id)sender
{

    
    [self routerEventWithName:@"pushtoUser" userInfo:@{KMESSAGEKEY:self.model}];

    

}

@end
