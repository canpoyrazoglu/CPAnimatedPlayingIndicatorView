//
//  CPAnimatedPlayingIndicatorView.m
//  CPAnimatedPlayingIndicatorView
//
//  Created by Can Poyrazoğlu on 11.02.2018.
//  Copyright © 2018 Can Poyrazoğlu. All rights reserved.
//

#import "CPAnimatedPlayingIndicatorView.h"
@import QuartzCore;

static inline CGPathRef zeroAmplitudeBarPath(CGRect bounds, float barSpacing, float barWidth, float cornerRadius, int index, int total){
    float xPosition = index / (float)total * bounds.size.width //normal position
    + ( //adjustment for bar spacing
       barSpacing * ((float)index / total)
       );
    float height = cornerRadius * 2; //we can't go below 2xradius
    CGRect rect = CGRectMake(xPosition, bounds.size.height - height, barWidth, height);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius].CGPath;
    return path;
}

static inline CGPathRef fullAmplitudeBarPath(CGRect bounds, float barSpacing, float barWidth, float cornerRadius, int index, int total){
    float xPosition = index / (float)total * bounds.size.width //normal position
    + ( //adjustment for bar spacing
       barSpacing * ((float)index / total)
       );
    CGRect rect = CGRectMake(xPosition, 0, barWidth, bounds.size.height);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius].CGPath;
    return path;
}

@implementation CPAnimatedPlayingIndicatorView{
    CGColorRef colorRef;
    BOOL didAwake;
    int animationStartCounter;
    BOOL animating;
}

-(void)drawRect:(CGRect)rect{
    [self createLayersIfNeeded];
}

-(void)invalidateLayers{
    NSArray *sublayers = self.layer.sublayers.copy;
    for (CALayer *layer in sublayers) {
        [layer removeFromSuperlayer];
    }
}

-(void)createLayersIfNeeded{
    if(!self.layer.sublayers.count){
        [self createLayers];
    }
}

-(void)createLayers{
    CGRect bounds = self.bounds;
    float barWidth = ((bounds.size.width - (_barSpacing * (_barCount - 1))) / _barCount);
    for (int i = 0; i < _barCount; i++) {
        CGPathRef path = zeroAmplitudeBarPath(bounds, _barSpacing, barWidth, _cornerRadius, i, _barCount);
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = path;
        [self.layer addSublayer:shapeLayer];
    }
}

-(void)setNeedsDisplay{
    [self invalidateLayers];
    [super setNeedsDisplay];
    [self performLayout];
}

-(void)setBarCount:(int)barCount{
    _barCount = barCount;
    [self setNeedsDisplay];
}

-(void)setColor:(UIColor *)color{
    _color = color;
    colorRef = color.CGColor;
    [self setNeedsDisplay];
}

-(void)setBarSpacing:(float)barSpacing{
    _barSpacing = barSpacing;
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(float)cornerRadius{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

-(void)setDivergence:(double)divergence{
    _divergence = divergence;
    [self setNeedsDisplay];
}

-(void)setAnimationSpeed:(double)animationSpeed{
    _animationSpeed = animationSpeed;
    [self invalidateLayers];
    [self setNeedsDisplay];
}

-(void)prepareForInterfaceBuilder{
    [super prepareForInterfaceBuilder];
    [self awakeFromNib];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    if(!_barCount){
        _barCount = 5;
    }
    if(!_color){
        self.color = [UIColor colorWithWhite:0.15 alpha:1];
    }
    if(!_animationSpeed){
        _animationSpeed = 10;
    }
    if(!_divergence){
        _divergence = 5;
    }
    didAwake = YES;
}

-(float)barWidth{
    return ((self.bounds.size.width - (_barSpacing * (_barCount - 1))) / _barCount);
}

-(void)beginAnimatingBarAtIndex:(int)index{
    if(!animating || self.layer.sublayers.count <= index){
        return;
    }
    CAShapeLayer *layer = (CAShapeLayer*)self.layer.sublayers[index];
    [layer removeAnimationForKey:@"pathAnimation"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration  = 3.0 / _animationSpeed;
    animation.fillMode = kCAFillModeBoth;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    CGPathRef startPath = zeroAmplitudeBarPath(self.bounds, _barSpacing, [self barWidth], _cornerRadius, index, _barCount);
    CGPathRef endPath = fullAmplitudeBarPath(self.bounds, _barSpacing, [self barWidth], _cornerRadius, index, _barCount);
    animation.fromValue = (__bridge id _Nullable)(startPath);
    animation.toValue = (__bridge id _Nullable)(endPath);
    [layer addAnimation:animation forKey:@"pathAnimation"];
}

-(void)beginAnimatingLayers{
    __block int capturedCounter = ++animationStartCounter;
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        CAShapeLayer *layer = (CAShapeLayer*)self.layer.sublayers[i];
        [layer removeAnimationForKey:@"pathAnimation"];
        layer.path = zeroAmplitudeBarPath(self.bounds, _barSpacing, [self barWidth], _cornerRadius, i, _barCount);
        float delay = _divergence / 5 * i / _animationSpeed;
        __block int index = i;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(capturedCounter == animationStartCounter){
                [self beginAnimatingBarAtIndex:index];
            }
        });
    }
}

-(void)endAnimatingLayers{
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        CAShapeLayer *layer = (CAShapeLayer*)self.layer.sublayers[i];
        id currentValue = [layer.presentationLayer valueForKey:@"path"];
        [layer removeAnimationForKey:@"pathAnimation"];
        layer.path = (__bridge CGPathRef _Nullable)(currentValue);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration  = 0.15;
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = NO;
        CGPathRef endPath = zeroAmplitudeBarPath(self.bounds, _barSpacing, [self barWidth], _cornerRadius, i, _barCount);
        animation.toValue = (__bridge id _Nullable)(endPath);
        [layer addAnimation:animation forKey:@"pathAnimation"];
    }
}

-(void)performLayout{
    if(!didAwake){
        return;
    }
    [self createLayersIfNeeded];
    if(animating){
        [self beginAnimatingLayers];
    }else{
        [self endAnimatingLayers];
    }
}

-(BOOL)isAnimating{
    return animating;
}

-(void)beginAnimating{
    animating = YES;
    [self performLayout];
}

-(void)endAnimating{
    animating = NO;
    [self performLayout];
}

@end
