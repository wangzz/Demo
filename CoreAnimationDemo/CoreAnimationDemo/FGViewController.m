//
//  FGViewController.m
//  CoreAnimationDemo
//
//  Created by wangzz on 14-8-21.
//  Copyright (c) 2014年 wangzz. All rights reserved.
//

#import "FGViewController.h"

@interface FGViewController ()
{
    CALayer *systemLayer;   //显示系统计算结果的图层
    CALayer *customLayer;   //显示自定义计算结果的图层
}
@end

@implementation FGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self createAxisForContainer:self.view.layer];
 
    [self singlePlane];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (IBAction)onTranslateButtonAction:(id)sender
{
    //Translate
    
    //随意的原始矩阵
    CATransform3D matrixOrigin = CATransform3DMakeRotation(1, 4, 3, 6);
    
    CGFloat x = 2, y = 3, z = 4; //位移向量（2,3,4）
    
    //系统方法计算变换矩阵
    CATransform3D matrixSystem = CATransform3DTranslate(matrixOrigin, x, y, z);
    systemLayer.transform = matrixSystem;
    [self logTransform:matrixSystem];
    
    //自定义方法计算变换矩阵
    CATransform3D matrixCalculate = [self translateWithMatrix:matrixOrigin x:x y:y z:z];
    customLayer.transform = matrixCalculate;
    [self logTransform:matrixCalculate];
}

- (IBAction)onScaleButtonAction:(id)sender
{
    //Scale
    
    //随意的原始矩阵
    CATransform3D matrixOrigin = CATransform3DMakeRotation(1, 4, 3, 6);
    
    CGFloat x = 2, y = 3, z = 4; //缩放倍数（2,3,4）
    
    //系统方法计算变换矩阵
    CATransform3D matrixSystem = CATransform3DScale(matrixOrigin, x, y, z);
    systemLayer.transform = matrixSystem;
    [self logTransform:matrixSystem];
    
    //自定义方法计算变换矩阵
    CATransform3D matrixCalculate = [self scaleWithMatrix:matrixOrigin x:x y:y z:z];
    customLayer.transform = matrixCalculate;
    [self logTransform:matrixCalculate];
}

- (IBAction)onRotateButtonAction:(id)sender
{
    //Rotate
    
    //随意的原始矩阵
    CATransform3D matrixOrigin = CATransform3DMakeRotation(1, 4, 3, 6);
    
    CGFloat x = 2, y = 3, z = 4; //旋转向量（2,3,4）
    CGFloat angle = 30.0f * M_PI / 180.0f; //旋转角度30°，计算对应的弧度
    
    //通过系统函数计算变换矩阵
    CATransform3D matrixSystem = CATransform3DRotate(matrixOrigin, angle, x, y, z);
    systemLayer.transform = matrixSystem;
    [self logTransform:matrixSystem];
    
    //自定义方法计算3D旋转矩阵
    CATransform3D matrixCalculate = [self rotateWithMatrix:matrixOrigin angle:angle x:x y:y z:z];
    customLayer.transform = matrixCalculate;
    [self logTransform:matrixCalculate];
}

#pragma mark - Matrix Calculate
- (CATransform3D)translateWithMatrix:(CATransform3D)t x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    CATransform3D matrixTransform = CATransform3DIdentity;
    matrixTransform.m41 = x;
    matrixTransform.m42 = y;
    matrixTransform.m43 = z;
    
    return CATransform3DConcat(matrixTransform, t);
}

- (CATransform3D)scaleWithMatrix:(CATransform3D)t x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    CATransform3D matrixTransform = CATransform3DIdentity;
    matrixTransform.m11 = x;
    matrixTransform.m22 = y;
    matrixTransform.m33 = z;
    
    return CATransform3DConcat(matrixTransform, t);
}

//根据角度（弧度）、旋转向量计算3D旋转矩阵
- (CATransform3D)rotateWithMatrix:(CATransform3D)t angle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    CGFloat unitValue = sqrtf(powf(x, 2)+powf(y, 2)+powf(z, 2));
    CGFloat x0 = x/unitValue;
    CGFloat y0 = y/unitValue;
    CGFloat z0 = z/unitValue;
    
    CATransform3D matrixTransform = CATransform3DIdentity;
    matrixTransform.m11 = powf(x0, 2)*(1-cosf(angle))+cosf(angle);
    matrixTransform.m12 = x0*y0*(1-cosf(angle))+z0*sinf(angle);
    matrixTransform.m13 = x0*z0*(1-cosf(angle))-y0*sinf(angle);
    
    matrixTransform.m21 = x0*y0*(1-cosf(angle))-z0*sinf(angle);
    matrixTransform.m22 = powf(y0, 2)*(1-cosf(angle))+cosf(angle);
    matrixTransform.m23 = y0*z0*(1-cosf(angle))+x0*sinf(angle);
    
    matrixTransform.m31 = x0*z0*(1-cosf(angle))+y0*sinf(angle);
    matrixTransform.m32 = y0*z0*(1-cosf(angle))-x0*sinf(angle);
    matrixTransform.m33 = powf(z0, 2)*(1-cosf(angle))+cosf(angle);
    
    return CATransform3DConcat(matrixTransform, t);
}

- (void)singlePlane{
    
    CALayer *container = [CALayer layer];
    container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:container];
    
    systemLayer = [self addPlaneToLayer:container
                                   size:CGSizeMake(50, 50)
                               position:CGPointMake(self.view.frame.size.width/3, self.view.frame.size.height/2)
                                  color:[UIColor purpleColor]];
    
    customLayer = [self addPlaneToLayer:container
                                   size:CGSizeMake(50, 50)
                               position:CGPointMake(self.view.frame.size.width*2/3, self.view.frame.size.height/2)
                                  color:[UIColor purpleColor]];
}

- (void)logTransform:(CATransform3D)t
{
    NSLog(@"***************************");
    NSLog(@"%f,%f,%f,%f",t.m11,t.m12,t.m13,t.m14);
    NSLog(@"%f,%f,%f,%f",t.m21,t.m22,t.m23,t.m24);
    NSLog(@"%f,%f,%f,%f",t.m31,t.m32,t.m33,t.m34);
    NSLog(@"%f,%f,%f,%f",t.m41,t.m42,t.m43,t.m44);
}

-(void)createAxisForContainer:(CALayer*)container{
    UIBezierPath *graphPath = [UIBezierPath bezierPath];
    //水平线
    [graphPath moveToPoint:CGPointMake(0, (self.view.frame.size.height/2))];
    [graphPath addLineToPoint:CGPointMake(self.view.frame.size.width, (self.view.frame.size.height/2))];
    
    //第一条竖线
    [graphPath moveToPoint:CGPointMake(self.view.frame.size.width/3, 0)];
    [graphPath addLineToPoint:CGPointMake(self.view.frame.size.width/3, self.view.frame.size.height)];
    
    //第二条竖线
    [graphPath moveToPoint:CGPointMake(self.view.frame.size.width*2/3, 0)];
    [graphPath addLineToPoint:CGPointMake(self.view.frame.size.width*2/3, self.view.frame.size.height)];
    
    [graphPath closePath];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer setPath: [graphPath CGPath]];
    [shapeLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [shapeLayer setMasksToBounds:NO];
    [shapeLayer setLineWidth:0.5];
    
    [container addSublayer:shapeLayer];
}

-(CALayer*)addPlaneToLayer:(CALayer*)container size:(CGSize)size position:(CGPoint)point color:(UIColor*)color{
    CALayer *plane = [CALayer layer];
    
    plane.backgroundColor = [color CGColor];
    plane.opacity = 0.6;
    plane.frame = CGRectMake(0, 0, size.width, size.height);
    plane.position = point;
    plane.anchorPoint = CGPointMake(0.5, 0.5);
    plane.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5]CGColor];
    plane.borderWidth = 3;
    plane.cornerRadius = 10;

    [container addSublayer:plane];
    
    return plane;
}

@end
