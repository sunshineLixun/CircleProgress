//
//  CircleProgressView.m
//  CircleProgress
//
//  Created by lixun on 16/9/11.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import "CircleProgressView.h"
#import <pop/POP.h>
@interface CircleProgressView ()

@property (nonatomic, assign) double percent;
@property (nonatomic, assign) double initialProgress;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self drawCircle];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self==[super initWithCoder:aDecoder])
    {
        [self drawCircle];
    }
    return self;
}

- (void)drawCircle
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:60 startAngle:(3 * M_PI/2)  endAngle:(- M_PI / 2) clockwise:NO];
    
    self.shapeLayer.path = path1.CGPath;
    
    [self drawGradientLayer];
    
    [self.layer setMask:self.shapeLayer];
}


- (void)drawGradientLayer
{
    //左半边的颜色渐变
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame =  CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height);
    [colorLayer setColors :@[
                             (__bridge id)[UIColor colorWithRed:0.36 green:0.75 blue:0.46 alpha:1.00].CGColor,
                             (__bridge id)[[UIColor colorWithRed:0.33 green:0.76 blue:0.50 alpha:1.00] CGColor],
                             (__bridge id)[[UIColor colorWithRed:0.36 green:0.75 blue:0.47 alpha:1.00] CGColor]
                             ]];
    [colorLayer setLocations: @[@0.5, @0.9, @1]];
    [colorLayer setStartPoint :CGPointMake (0.5 , 0)];
    [colorLayer setEndPoint: CGPointMake(0.5, 1)];
    [self.layer addSublayer:colorLayer];
    
    //右半边的颜色渐变
    CAGradientLayer *colorLayer1 = [CAGradientLayer layer];
    colorLayer1.frame =  CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height);
    [colorLayer1 setColors :@[
                              (__bridge id)[[UIColor colorWithRed:0.13 green:0.76 blue:0.80 alpha:1.00] CGColor],
                              (__bridge id)[UIColor colorWithRed:0.13 green:0.80 blue:0.86 alpha:1.00].CGColor,
                              (__bridge id)[UIColor colorWithRed:0.13 green:0.75 blue:0.78 alpha:1.00].CGColor
                              ]];
    [colorLayer1 setLocations: @[@0.5, @0.9, @1]];
    [colorLayer1 setStartPoint :CGPointMake (0.5,0)];
    [colorLayer1 setEndPoint: CGPointMake(0.5,1)];
    
    [self.layer addSublayer:colorLayer1];

}

#pragma mark - 
#pragma mark - setter
- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _elapsedTime = elapsedTime;
    _initialProgress = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    self.shapeLayer.strokeStart = self.percent;
    [self drawLineAnimation:self.shapeLayer];
}

#pragma mark -
#pragma mark - get
- (double)percent {
    _percent = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    return _percent;
}


- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {
    
    if ((toTime > 0) && (fromTime > 0)) {
        CGFloat progress = 0;
        progress = fromTime / toTime;
        
        if ((progress * 100) > 100) {
            progress = 1.0f;
        }
        return progress;
    }
    else{
        return 0.0f;
    }
}


-(void)drawLineAnimation:(CALayer *)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeStart"];
    bas.duration= 1;
    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bas.fromValue = @(self.initialProgress);
    bas.toValue = @(self.percent);
    [layer addAnimation:bas forKey:nil];
    
//    POPSpringAnimation *springAn = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeStart];
//    springAn.toValue = @(self.percent);
//    springAn.fromValue = @(_initialProgress);
//    springAn.springBounciness = 20.f;
//    springAn.springSpeed = 20.f;
//    [layer pop_addAnimation:springAn forKey:nil];
}


#pragma mark - lazy
- (CAShapeLayer *)shapeLayer
{
    if(!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = 5.f;
        [self.layer addSublayer:_shapeLayer];

    }
    return _shapeLayer;
}

@end
