//
//  GraphicsView.m
//  CoreGraphics
//
//  Created by wangzz on 15/9/23.
//  Copyright © 2015年 wangzz. All rights reserved.
//

#import "GraphicsView.h"

@implementation GraphicsView

//typedef CF_ENUM (int32_t, CGPathDrawingMode) {
//    kCGPathFill,
//    kCGPathEOFill,
//    kCGPathStroke,
//    kCGPathFillStroke,
//    kCGPathEOFillStroke
//};

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect1:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 1);
    
//    CGContextTranslateCTM(context, 100, 100);
//    CGContextScaleCTM(context, 0.5, 0.5);
//    CGContextRotateCTM(context, M_PI_2);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 10, 100);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 100, 60);
    CGContextClosePath(context);
    
//    CGContextFillEllipseInRect(context, CGRectMake(10, 10, 30, 30));
//    CGContextFillPath(context);
//    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

//Code-7: drawPath
- (void)drawRect:(CGRect)rect{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // 创建并绘制 path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL, self.frame.size.width, self.frame.origin.y);
    CGPathAddEllipseInRect(path, &CGAffineTransformIdentity, CGRectMake(0, 320, 320, 160));
    CGPathAddLineToPoint(path,NULL, self.frame.origin.x, self.frame.size.height);
    
    // 将 path 添加到绘制 context
    CGContextAddPath(currentContext, path);

    // 绘制 path
    CGContextDrawPath(currentContext, kCGPathStroke);
    CGPathRelease(path);
}


@end
