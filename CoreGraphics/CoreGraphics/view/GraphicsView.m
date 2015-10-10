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
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 1);
    
//    CGContextTranslateCTM(context, 100, 100);
//    CGContextScaleCTM(context, 0.5, 0.5);
//    CGContextRotateCTM(context, M_PI_2);
    

    CGContextBeginPath(context);
    
//    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 50, 50));
    CGContextMoveToPoint(context, 5, 5);
    CGContextAddLineToPoint(context, 5, 30);
    CGContextAddLineToPoint(context, 30, 30);
    CGContextAddLineToPoint(context, 30, 5);
//    CGContextClosePath(context);
    
//    CGContextStrokePath(context);
    CGContextClip(context);
//    CGContextClipToRect(context, CGRectMake(5, 5, 25, 25));
    
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 10, 100);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 100, 60);
    CGContextClosePath(context);
    
//    CGContextFillEllipseInRect(context, CGRectMake(10, 10, 30, 30));
//    CGContextFillPath(context);

//    CGContextClipToRect(context, CGRectMake(0, 0, 50, 50));
//    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    CGContextSaveGState(<#CGContextRef  _Nullable c#>)
}

//Code-7: drawPath
- (void)drawRect1:(CGRect)rect{
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

- (void)drawRect3:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        1,1,1, 1.00,
        1,1,0, 1.00,
        1,0,0, 1.00,
        1,0,1, 1.00,
        0,1,1, 1.00,
        0,1,0, 1.00,
        0,0,1, 1.00,
        0,0,0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//形成梯形，渐变的效果
    CGColorSpaceRelease(rgb);
    
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 20, 90);
    CGContextAddLineToPoint(context, 40, 90);
    CGContextAddLineToPoint(context, 40, 110);
    CGContextAddLineToPoint(context, 20, 110);
    CGContextClip(context);//context裁剪路径,后续操作的路径
    //CGContextDrawLinearGradient(CGContextRef context,CGGradientRef gradient, CGPoint startPoint, CGPoint endPoint,CGGradientDrawingOptions options)
    //gradient渐变颜色,startPoint开始渐变的起始位置,endPoint结束坐标,options开始坐标之前or开始之后开始渐变
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (20,90) ,CGPointMake(40,110),
                                kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);// 恢复到之前的context
}
@end
