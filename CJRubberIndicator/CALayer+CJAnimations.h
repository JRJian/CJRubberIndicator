//
//  CALayer+CJAnimations.h
//  CJRubberIndicator
//
//  Created by jian on 15/11/3.
//  Copyright © 2015年 chenjiantao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define CJTransactionBegin [CATransaction begin];\
[CATransaction setDisableActions:YES];

#define CJTransactionCommit [CATransaction commit];

@interface CALayer (CJAnimations)

/**
 *  基本动画
 *
 *  @param value    动画值
 *  @param keyPath  动画键值
 *  @param duration 持续时间
 *  @param delay    延时时间
 */
- (void)cj_setBaseAnimationWithValue:(id)value
                          forKeyPath:(NSString *)keyPath
                            duration:(CFTimeInterval)duration
                               delay:(CFTimeInterval)delay;

/**
 *  路径位移动画
 *
 *  @param path     路径
 *  @param duration 持续时间
 *  @param delay    延时时间
 */
- (void)cj_positionAnimationWithValue:(id)value
                               CGPath:(CGPathRef)path
                             duration:(CFTimeInterval)duration
                                delay:(CFTimeInterval)delay;

/**
 *  缩放动画
 *
 *  @param transform 缩放3D矩阵
 *  @param duration  持续时间
 *  @param delay     延时时间
 */
- (void)cj_scaleAnimationWithCATransform3D:(CATransform3D)transform
                                  duration:(CFTimeInterval)duration
                                     delay:(CFTimeInterval)delay;

/**
 *  抖动动画
 *
 *  @param direction 1：横向抖动，other：纵向抖动
 *  @param duration  持续时间
 *  @param delay     延时时间
 */
- (void)cj_shakeAnimationWithDirection:(NSInteger)direction
                              duration:(CFTimeInterval)duration
                                 delay:(CFTimeInterval)delay;

@end
