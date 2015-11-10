//
//  CJRubberIndicator.h
//  CJRubberIndicator
//
//  Created by chenjiantao on 15/11/2.
//  Copyright © 2015年 chenjiantao. All rights reserved.
//

#import <UIKit/UIKit.h>

// 移动方向
typedef NS_ENUM(NSInteger, CJMoveDirection) {
    CJMoveDirectionLeft  = 0,
    CJMoveDirectionRight = 1,
};

@interface CJRubberIndicator : UIControl

// 总共页数，默认0
@property (nonatomic) NSUInteger    numberOfPages;

// 当前页数，默认0
@property (nonatomic) NSUInteger    currentPage;

// 是否允许点击小球，默认YES
@property (nonatomic) BOOL          tapGestureEnabled;

// 默认小球颜色
@property (nonatomic, copy) UIColor *pageIndicatorTintColor;

// 当前选中小球颜色
@property (nonatomic, copy) UIColor *currentPageIndicatorTintColor;

@end
