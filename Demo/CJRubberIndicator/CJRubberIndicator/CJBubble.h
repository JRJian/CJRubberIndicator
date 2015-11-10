//
//  CJBubble.h
//  CJRubberIndicator
//
//  Created by chenjiantao on 15/11/2.
//  Copyright © 2015年 chenjiantao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CJBubble : CAShapeLayer

// 是否大球
@property (nonatomic, assign, getter=isMain) BOOL main;

// 小球填充色
@property (nonatomic, copy) UIColor *bubbleFillColor;

// 动画持续时间，默认0.5s
@property (nonatomic, assign) CFTimeInterval animationDuration;

+ (instancetype)layerWithBubbleFillColor:(UIColor *)bubbleFillColor;

// 动画
- (void)animationWithPositionValue:(id)value;

@end
