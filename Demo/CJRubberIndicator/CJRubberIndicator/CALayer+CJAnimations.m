//
//  CALayer+CJAnimations.m
//  CJRubberIndicator
//
//  Created by jian on 15/11/3.
//  Copyright © 2015年 chenjiantao. All rights reserved.
//

#import "CALayer+CJAnimations.h"
#import <UIKit/UIKit.h>

@implementation CALayer (CJAnimations)

- (void)cj_setBaseAnimationWithValue:(id)value
                          forKeyPath:(NSString *)keyPath
                            duration:(CFTimeInterval)duration
                               delay:(CFTimeInterval)delay {
    // 关闭隐式动画
    CJTransactionBegin
    
    [self setValue:value forKeyPath:keyPath];
    
    CABasicAnimation *anim;
    anim            = [CABasicAnimation animationWithKeyPath:keyPath];
    anim.duration   = duration;
    anim.beginTime  = CACurrentMediaTime() + delay;
    anim.fillMode   = kCAFillModeBoth; // 设置恒定值，也就是动画之前会用fromValue来作用当前图层,动画之后会用toValue来作用当前图层
    anim.fromValue  = [[self presentationLayer] valueForKeyPath:keyPath];// 获取当前正在动画的动画图层副本中指定的keyPath 的 value.比如我们的动画是持续到.5秒此时位置在x=10,那么就是从这个位置开始动画
    anim.toValue    = value;
    [self addAnimation:anim forKey:keyPath];
    
    CJTransactionCommit
}

- (void)cj_positionAnimationWithValue:(id)value
                               CGPath:(CGPathRef)path
                             duration:(CFTimeInterval)duration
                                delay:(CFTimeInterval)delay {
    
    NSString *keyPath = @"position";
    [self setValue:value forKeyPath:keyPath];
    
    // 外壳曲线路径动画
    CAKeyframeAnimation *kfani = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    kfani.path = path;
    kfani.duration = duration;
    kfani.fillMode = kCAFillModeBoth;
    kfani.rotationMode = kCAAnimationRotateAuto;
    kfani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    kfani.beginTime = CACurrentMediaTime() + delay;
    [self addAnimation:kfani forKey:@"pathAnim"];
}

- (void)cj_scaleAnimationWithCATransform3D:(CATransform3D)transform
                                  duration:(CFTimeInterval)duration
                                     delay:(CFTimeInterval)delay {
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                         [NSValue valueWithCATransform3D:transform],
                         [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    scaleAnim.duration = duration;
    scaleAnim.keyTimes = @[@0, @0.5, @1];
    scaleAnim.beginTime = CACurrentMediaTime() + delay;
    [self addAnimation:scaleAnim forKey:@"scaleAnim"];
}

- (void)cj_shakeAnimationWithDirection:(NSInteger)direction
                              duration:(CFTimeInterval)duration
                                 delay:(CFTimeInterval)delay {
    
    CAKeyframeAnimation *kfani = [CAKeyframeAnimation animationWithKeyPath:direction == 1 ? @"transform.translation.x" : @"transform.translation.y"];
    [kfani setValues:@[@(-5), @(0), @(3), @(0), @(-2), @(0), @(1), @(0)]];
    [kfani setDuration:duration];
    [kfani setBeginTime:CACurrentMediaTime() + delay];
    [kfani setRemovedOnCompletion:YES];
    
    // 设置过度效果的速度曲线
    NSMutableArray *tfs = [[NSMutableArray alloc] initWithCapacity:kfani.values.count];
    for (int i = 1; i <= kfani.values.count; i++) {
        if (i % 2 == 0) {
            [tfs addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        } else {
            [tfs addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        }
    }
    [kfani setTimingFunctions:tfs];
    [self addAnimation:kfani forKey:@"shakeAnim"];
}

@end
