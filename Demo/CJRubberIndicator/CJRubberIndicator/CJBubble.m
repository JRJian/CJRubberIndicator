//
//  CJBubble.m
//  CJRubberIndicator
//
//  Created by chenjiantao on 15/11/2.
//  Copyright © 2015年 chenjiantao. All rights reserved.
//

#import "CJBubble.h"
#import "CALayer+CJAnimations.h"

@interface CJBubble()

@property (nonatomic, strong) CAShapeLayer *innerLayer;

@end

@implementation CJBubble

#pragma mark -
#pragma mark - Lifecycle

+ (instancetype)layerWithBubbleFillColor:(UIColor *)bubbleFillColor {
    CJBubble *layer = [CJBubble layer];
    layer.bubbleFillColor = bubbleFillColor;
    layer.main = NO;
    layer.innerLayer.backgroundColor = bubbleFillColor.CGColor;
    layer.animationDuration = 0.5f;
    return layer;
}

#pragma mark -
#pragma mark - Public

- (void)animationWithPositionValue:(id)value {

    CJTransactionBegin
    
    NSString *keyPath = @"position";
    
    if (_main) {
        
        // 位移
        [self cj_setBaseAnimationWithValue:value forKeyPath:keyPath duration:_animationDuration delay:0];
        
        // 缩放
        [self cj_scaleAnimationWithCATransform3D:CATransform3DMakeScale(.85, .85, 1) duration:_animationDuration delay:0];
    } else {
        
        // 曲线位移
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat fromPoint = [[self.presentationLayer valueForKeyPath:keyPath] CGPointValue].x;
        CGFloat midX = fromPoint + ([value CGPointValue].x - fromPoint) * .5f;
        CGPoint controlPoint = CGPointMake(midX, [value CGPointValue].y * 3.5);
        [path moveToPoint:[[[self presentationLayer] valueForKeyPath:keyPath] CGPointValue]];
        [path addQuadCurveToPoint:[value CGPointValue] controlPoint:controlPoint];
        [self cj_positionAnimationWithValue:value CGPath:path.CGPath duration:_animationDuration delay:0];
        
        // 小球缩放动画
        [self.innerLayer cj_scaleAnimationWithCATransform3D:CATransform3DMakeScale(1, .45, 1) duration:_animationDuration delay:0];
        
        // 小球缩放完毕，小球抖动
        [self.innerLayer cj_shakeAnimationWithDirection:2 duration:_animationDuration / 2.0f delay:_animationDuration];
    }
    
    CJTransactionCommit
}

#pragma mark -
#pragma mark - Setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat bubbleW = frame.size.width;
    self.innerLayer.bounds = (CGRect){.origin=CGPointZero, .size=frame.size};
    self.innerLayer.position = CGPointMake(CGRectGetWidth(frame)/2.0f, CGRectGetWidth(frame)/2.0f);
    self.innerLayer.cornerRadius = CGRectGetWidth(frame) / 2.0f;
    self.innerLayer.fillColor    = _bubbleFillColor.CGColor;
    self.innerLayer.path         = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, bubbleW, bubbleW) cornerRadius:bubbleW/2.0f].CGPath;
}

- (void)setMain:(BOOL)main {
    _main = main;
    if (main) {
        [self.innerLayer removeFromSuperlayer];
    } else {
        [self addSublayer:self.innerLayer];
    }
}

#pragma mark -
#pragma mark - Getter

- (CAShapeLayer *)innerLayer {
    if (!_innerLayer) {
        _innerLayer = [CAShapeLayer layer];
    }
    return _innerLayer;
}

@end
