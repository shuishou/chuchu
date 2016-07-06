//
//  VideoCollectionViewCell.h
//  MyQOOCOO
//
//  Created by Devin on 15/12/31.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *preImage;
@property (weak, nonatomic) IBOutlet UILabel *videoSize;
@property (weak, nonatomic) IBOutlet UILabel *videoDuration;

@end
