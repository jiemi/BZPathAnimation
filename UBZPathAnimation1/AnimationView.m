//
//  AnimationView.m
//  UBZPathAnimation1
//
//  Created by 萧锐杰 on 16/7/31.
//  Copyright © 2016年 萧锐杰. All rights reserved.
//

#import "AnimationView.h"
@interface AnimationView()
@property(nonatomic,strong) CAShapeLayer *topLineLayer;
@property(nonatomic,strong) CAShapeLayer *bottomLineLayer;
@property(nonatomic,strong) CAShapeLayer *changedLayer;

@end
@implementation AnimationView

static const CGFloat Raduis = 50.0f;
static const CGFloat lineWidth = 50.0f;
static const CGFloat lineGapHeight = 10.0f;
static const CGFloat lineHeight = 8.0f;


static const CGFloat kStep1Duration = 0.5;
static const CGFloat kStep2Duration = 0.5;
static const CGFloat kStep3Duration = 5;
static const CGFloat kStep4Duration = 5.0;

#define kTopY Raduis - lineGapHeight
#define KCenterY  kTopY + lineHeight + lineGapHeight
#define kBottomY  KCenterY + lineHeight + lineGapHeight
#define Radians(x)  (M_PI * (x) / 180.0)
-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor orangeColor];
        
        //[self initLayers];
    }
    
    return self;
}

-(void)initLayers {
    
    _topLineLayer = [CAShapeLayer layer];
    _bottomLineLayer = [CAShapeLayer layer];
    _changedLayer = [CAShapeLayer layer];;
    
    CALayer *TopLayer = [CALayer layer];
    TopLayer.frame = CGRectMake((self.bounds.size.width+lineWidth)/2, kTopY, lineWidth, lineHeight);
    [self.layer addSublayer:TopLayer];
    
    CALayer *BottomLayer = [CALayer layer];
    BottomLayer.frame = CGRectMake((self.bounds.size.width+lineWidth)/2, kBottomY, lineWidth, lineHeight);
    [self.layer addSublayer:BottomLayer];
    
    
    CGFloat startOriginX = self.center.x - lineWidth / 2.0;
    CGFloat endOriginX = self.center.x + lineWidth / 2.0;
    
    [_topLineLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    _topLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _topLineLayer.lineWidth = lineHeight;
    _topLineLayer.lineCap = kCALineCapRound;
    _topLineLayer.position = CGPointMake(0, 0);
    
    [_bottomLineLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    _bottomLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _bottomLineLayer.lineWidth = lineHeight;
    _bottomLineLayer.lineCap = kCALineCapRound;
    
    [_changedLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    _changedLayer.fillColor = [[UIColor clearColor] CGColor];
    _changedLayer.contentsScale = [UIScreen mainScreen].scale;
    _changedLayer.lineWidth = lineHeight;
    _changedLayer.lineCap = kCALineCapRound;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(-lineWidth, 0)];
    _topLineLayer.path = path.CGPath;
    _bottomLineLayer.path = path.CGPath;
    
    CGMutablePathRef solidChangedLinePath = CGPathCreateMutable();
    CGPathMoveToPoint(solidChangedLinePath, NULL, startOriginX, KCenterY);
    CGPathAddLineToPoint(solidChangedLinePath, NULL, endOriginX, KCenterY);
    _changedLayer.path = solidChangedLinePath;
    CGPathRelease(solidChangedLinePath);
    
    [TopLayer addSublayer:_topLineLayer];
    [BottomLayer addSublayer:_bottomLineLayer];
    [self.layer addSublayer:_changedLayer];
    
    
}

- (void)startAnimation {
    [_changedLayer removeAllAnimations];
    [_changedLayer removeFromSuperlayer];
    [_topLineLayer removeFromSuperlayer];
    [_bottomLineLayer removeFromSuperlayer];
    
    [self initLayers];
    [self animationStep1];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep1"]) {
        [self animationStep2];
    } else  if([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep2"]) {
        [self animationStep3];
    }
}

- (void)animationStep1 {
    
    _changedLayer.strokeEnd = 0.4;
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokenEnd"];
    strokeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    strokeAnimation.toValue = [NSNumber numberWithFloat:0.4f];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    pathAnimation.toValue = [NSNumber numberWithFloat:-10.0];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeAnimation,pathAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationGroup.duration = kStep1Duration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:@"animationStep1" forKey:@"animationName"];
    [_changedLayer addAnimation:animationGroup forKey:nil];
}

- (void)animationStep2 {
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation.fromValue = [NSNumber numberWithFloat:-10.0f];
    translationAnimation.toValue = [NSNumber numberWithFloat:0.2 * lineWidth];
    
    _changedLayer.strokeEnd = 0.8;
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = [NSNumber numberWithFloat:0.4f];
    strokeAnimation.toValue = [NSNumber numberWithFloat:0.8f];
    
    
   /* CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = [NSNumber numberWithFloat:0];
    strokeStartAnimation.toValue = [NSNumber numberWithFloat:0.5];*/
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[translationAnimation,strokeAnimation];
    group.duration = kStep2Duration;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    group.removedOnCompletion = true;
    [group setValue:@"animationStep2" forKey:@"animationName"];
    [_changedLayer addAnimation:group forKey:nil];
}


- (void)animationStep3 {
    [self.changedLayer removeFromSuperlayer];
    self.changedLayer = [CAShapeLayer layer];
    _changedLayer.strokeColor = [[UIColor whiteColor] CGColor];
    _changedLayer.fillColor = [UIColor clearColor].CGColor;
    _changedLayer.lineWidth = lineHeight;
    _changedLayer.contentsScale = [UIScreen mainScreen].scale;
    _changedLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_changedLayer];
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.center.x , KCenterY)];
    
    CGFloat angle = Radians(30);
    CGFloat endPointX = self.center.x+Raduis * cos(angle);
    CGFloat endPointY = KCenterY - Raduis * sin(angle);
    
    CGFloat startPointX = self.center.x + lineWidth/2.0;
    CGFloat startPointY = KCenterY ;
    
    CGFloat controlPointX = self.center.x + Raduis * 1/cos(angle);
    CGFloat controlPointY = KCenterY;
    
    [path addCurveToPoint:CGPointMake(endPointX, endPointY) controlPoint1:CGPointMake(startPointX, startPointY) controlPoint2:CGPointMake(controlPointX, controlPointY)];
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x, KCenterY) radius:Raduis startAngle:2*M_PI-Radians(30) endAngle:M_PI+Radians(30) clockwise:NO];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x, KCenterY) radius:Raduis startAngle:M_PI+Radians(30) endAngle:-M_PI/2-Radians(60) clockwise:NO ];
    
    
   /* //组合path 路径
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,KCenterY)
                                                         radius:Raduis
                                                     startAngle:2 * M_PI - angle
                                                       endAngle:M_PI + angle
                                                      clockwise:NO];
   // [path appendPath:path1];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,KCenterY)
                                                         radius:Raduis
                                                     startAngle:M_PI *3/2 - (M_PI_2 -angle)
                                                       endAngle:-M_PI_2 - (M_PI_2 -angle)
                                                     clockwise:NO];*/
    
    [path appendPath:path1];
    [path appendPath:path2];
    
    _changedLayer.path = path.CGPath;
 
    
    CGFloat strokeStartEndPercent = (Radians(120) * Raduis + [self calculateCurveLength]) / [self calculateTotalLength];
    CGFloat strokeEndStartPercent = [self calculateCurveLength] / 2 / [self calculateTotalLength];
    
    NSLog(@"%f",strokeStartEndPercent);
    NSLog(@"%f",strokeEndStartPercent);
    
    _changedLayer.strokeStart = strokeStartEndPercent;
    
    CAKeyframeAnimation *startAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.values = @[@0.0,@(strokeStartEndPercent)];
    
    CAKeyframeAnimation *endAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.values = @[@(strokeEndStartPercent),@1];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[startAnimation,endAnimation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.duration = kStep3Duration;
    group.delegate = self ;
    group.removedOnCompletion = true;
    [group setValue:@"animationStep3" forKey:@"animationName"];
    [_changedLayer addAnimation:group forKey:nil];
    
}

//求贝塞尔曲线长度
- (CGFloat) bezierCurveLengthFromStartPoint:(CGPoint)start toEndPoint:(CGPoint) end withControlPoint:(CGPoint) control
{
    const int kSubdivisions = 50;
    const float step = 1.0f/(float)kSubdivisions;
    
    float totalLength = 0.0f;
    CGPoint prevPoint = start;
    
    // starting from i = 1, since for i = 0 calulated point is equal to start point
    for (int i = 1; i <= kSubdivisions; i++)
    {
        float t = i*step;
        
        float x = (1.0 - t)*(1.0 - t)*start.x + 2.0*(1.0 - t)*t*control.x + t*t*end.x;
        float y = (1.0 - t)*(1.0 - t)*start.y + 2.0*(1.0 - t)*t*control.y + t*t*end.y;
        
        CGPoint diff = CGPointMake(x - prevPoint.x, y - prevPoint.y);
        
        totalLength += sqrtf(diff.x*diff.x + diff.y*diff.y); // Pythagorean
        
        prevPoint = CGPointMake(x, y);
    }
    
    return totalLength;
}

- (CGFloat)calculateCurveLength
{
    CGFloat angle = Radians(30);
    CGFloat endPointX = self.center.x+Raduis * cos(angle);
    CGFloat endPointY = KCenterY - Raduis * sin(angle);
    
    CGFloat startPointX = self.center.x;
    CGFloat startPointY = KCenterY ;
    
    CGFloat controlPointX = self.center.x + Raduis * 1/cos(angle);
    CGFloat controlPointY = KCenterY;
    
    CGFloat length = [self bezierCurveLengthFromStartPoint:CGPointMake(startPointX, startPointY) toEndPoint:CGPointMake(endPointX, endPointY) withControlPoint:CGPointMake(controlPointX, controlPointY)];
    return length;
}

-(CGFloat)calculateTotalLength
{
    
    CGFloat curveLength = [self calculateCurveLength];
    
    //一个圆 + 120度弧长的 总长度
    CGFloat length = (Radians(120) + 2 * M_PI) * Raduis;
    CGFloat totalLength = curveLength + length;
    
    return totalLength;
}


@end























