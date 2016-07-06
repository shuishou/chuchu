//
//  QCDrawView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//
#define kBrushWidth 4

#import "QCDrawView.h"

@interface QCDrawView ()
{
    CGPoint previousPoint;
    CGPoint currentPoint;
}
@property (nonatomic, strong) UIImage * viewImage;
@end

@implementation QCDrawView

- (void)awakeFromNib
{
    [self initialize];
}

- (void)drawRect:(CGRect)rect
{
    [self.viewImage drawInRect:self.bounds];
}

#pragma mark - setter methods
- (void)setDrawingMode:(DrawingMode)drawingMode
{
    _drawingMode = drawingMode;
}

#pragma mark - Private methods
- (void)initialize
{
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
    
    _drawingMode = DrawingModeNone;
    
    _selectedColor = [UIColor blackColor];
}

- (void)eraseLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}


- (void)drawLineNew
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), kBrushWidth);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)handleTouches
{
    if (self.drawingMode == DrawingModeNone) {
        // do nothing
    }
    else if (self.drawingMode == DrawingModePaint) {
        [self drawLineNew];
        //正在画
        self.isDraw = YES;
    }
    else
    {
        [self eraseLine];
    }
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
}

/**
 *  把画板的涂鸦View转为Image
 */
-(UIImage *)converViewToImage:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
