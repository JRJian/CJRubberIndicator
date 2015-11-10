//
//  CJRubberIndicator.m
//  CJRubberIndicator
//
//  Created by chenjiantao on 15/11/2.
//  Copyright © 2015年 chenjiantao. All rights reserved.
//

#import "CJRubberIndicator.h"
#import "CJBubble.h"
#import "CALayer+CJAnimations.h"

@interface CJRubberIndicator()<UIGestureRecognizerDelegate>

// 最后一次移动的方向
@property (nonatomic, assign) CJMoveDirection   lastDirection;

// 小球数组，包含大球
@property (nonatomic, strong) NSMutableArray    *bubbles;

// 大球
@property (nonatomic, strong) CJBubble          *mainBubble;

// 背景
@property (nonatomic, strong) CAShapeLayer      *menu;

// 球之间的间距，会根据Indicator的视图大小自动计算
@property (nonatomic, assign) CGFloat           padding;

@end

@implementation CJRubberIndicator

#pragma mark -
#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    // 设置默认配置
    [self _resetDefault];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // 设置默认配置
    [self _resetDefault];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 移除所有图层
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    // 计算需要用到的变量
    _padding                        = CGRectGetHeight(self.bounds) * .2f;
    NSInteger   numberOfBubbles     = _bubbles.count;
    CGFloat     indicatorW          = CGRectGetWidth(self.bounds);
    CGFloat     menuH               = CGRectGetHeight(self.bounds);
    CGFloat     bubbleW             = menuH - 2 * _padding;
    CGFloat     menuW               = MIN(numberOfBubbles * (bubbleW + 2 * _padding) + 2 * _padding, indicatorW); // 注意需要加上大球的边距
    CGFloat     menuX               = (indicatorW - menuW) * .5f;
    
    self.menu.frame                 = CGRectMake(menuX, 0, menuW, menuH);
    
    // 设置背景菜单
    UIBezierPath *path  = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, menuW, menuH)
                                                     cornerRadius:menuH / 2.0f];
    _menu.fillColor     = self.backgroundColor.CGColor;   // 闭环填充的颜色
    _menu.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
    
    if (!self.menu.superlayer) {
        [self.layer addSublayer:_menu];
        self.backgroundColor = [UIColor clearColor];
    }
    
    // 球球摆放
    [_bubbles enumerateObjectsUsingBlock:^(CJBubble *bubble, NSUInteger idx, BOOL *stop) {
        
        CGRect bubbleRect   = CGRectMake(0, _padding, bubbleW, bubbleW);
        
        if (idx == 0) {
            
            // 大球样式设置
            CGFloat mainBubbleW         = _padding * 2 + menuH;
            _mainBubble                 = bubble;
            _mainBubble.main            = YES;
            _mainBubble.strokeColor     = _menu.fillColor;
            _mainBubble.lineWidth       = _padding * 2;
            _mainBubble.strokeStart     = 0.0f;
            _mainBubble.strokeEnd       = 1.0f;
            _mainBubble.path            = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, mainBubbleW, mainBubbleW) cornerRadius:mainBubbleW/2.0f].CGPath;
            _mainBubble.fillColor       = _currentPageIndicatorTintColor.CGColor;
            bubbleRect.size             = CGSizeMake(menuH, menuH);
            bubbleRect.origin.y         = -_padding;
            bubbleRect.origin.x         = menuX;
            
        } else {
            
            bubble.main         = NO;
            // 减去大球的边距
            CGFloat left        = CGRectGetMaxX(_mainBubble.frame) - 2 * _padding + idx * (bubbleW + 2 * _padding);
            bubbleRect.origin.x = left;
            
        }
        
        bubble.frame = bubbleRect;
        
        [self.layer addSublayer:bubble];
    }];
}

#pragma mark -
#pragma mark - Private
#pragma mark 默认配置

- (void)_resetDefault {
    
    self.backgroundColor = [UIColor colorWithRed:0.357 green:0.196 blue:0.337 alpha:1.0f];
    
    _pageIndicatorTintColor = [UIColor colorWithRed:0.961 green:0.561 blue:0.518 alpha:1.0f];
    _currentPageIndicatorTintColor = [UIColor colorWithRed:0.788 green:0.216 blue:0.337 alpha:1.0f];
    
    _tapGestureEnabled = YES;
    
    if (_tapGestureEnabled) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
}

#pragma mark 移动大球到指定的位置

- (void)_moveMainBubbleToIndex:(NSUInteger)toIndex {
    
    // 防止越界
    toIndex = MAX(0, MIN(toIndex, _numberOfPages - 1));
    
    if (toIndex == _currentPage) {
        return;
    }
    
    // 点击了大球直接返回
    CJBubble *toBubble = _bubbles[toIndex];
    
    if (toBubble == _mainBubble) {
        return;
    }
    
    // 大球移动方向
    CJMoveDirection direction = (int)(toIndex - _currentPage) > 0 ? CJMoveDirectionRight : CJMoveDirectionLeft;
    
    // 小球移动的偏移
    CGFloat offsetX     = - 2 * _padding;
    
    // 大球移动的偏移
    CGFloat offsetXB    = offsetX;
    
    // 小球位移时候需要加上大球的宽度
    CGFloat mainBubbleW = -CGRectGetWidth(_mainBubble.bounds);
    
    if (direction == CJMoveDirectionLeft) {
        offsetX     = ABS(offsetX);
        offsetXB    = 0;
        mainBubbleW = ABS(mainBubbleW);
    }
    
    // 大球移动
    CGPoint toPoint = CGPointMake(toBubble.position.x + offsetXB, _mainBubble.position.y);
    [_mainBubble animationWithPositionValue:[NSValue valueWithCGPoint:toPoint]];
    
    // 移动需要位移的小球
    // 大球向右移动，小球往左，否则反之！
    NSInteger startIndex = direction == CJMoveDirectionLeft ? toIndex : (_currentPage + 1);
    NSInteger endIndex   = direction == CJMoveDirectionLeft ? (_currentPage - 1) : toIndex;
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        CJBubble *bubble = _bubbles[i];
        if (bubble != _mainBubble) {
            CGPoint smallToPoint = CGPointMake(bubble.position.x + mainBubbleW + offsetX, bubble.position.y);
            [bubble animationWithPositionValue:[NSValue valueWithCGPoint:smallToPoint]];
        }
    }
    
    // 数组移动
    [_bubbles removeObject:_mainBubble];
    [_bubbles insertObject:_mainBubble atIndex:toIndex];
    
    _currentPage = toIndex;
}

#pragma mark -
#pragma mark - Delegate

#pragma mark UITapGestureRecognizer Delegate

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    if (!_tapGestureEnabled) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:recognizer.view];
    
    // 判断点击了哪个小球
    [_bubbles enumerateObjectsUsingBlock:^(CJBubble *bubble, NSUInteger idx, BOOL *stop) {
        // 大球忽略
        if (!bubble.isMain) {
            CGRect bubbleRect = bubble.frame;
            // 点击了个某个小球
            if (CGRectContainsPoint(bubbleRect, point)) {
                self.currentPage = idx;
                *stop = YES;
            }
        }
    }];
}

#pragma mark -
#pragma mark - Getter

- (NSMutableArray *)bubbles {
    if (!_bubbles) {
        _bubbles = [NSMutableArray array];
    }
    return _bubbles;
}

- (CAShapeLayer *)menu {
    if (!_menu) {
        _menu = [CAShapeLayer layer];
    }
    return _menu;
}

#pragma mark -
#pragma mark - Setter

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    
    // 根据需要添加删除小球
    NSInteger lackCount = numberOfPages - self.bubbles.count;
    
    if (lackCount > 0) {
        // 缺少小球，填充缺少的小球
        for (NSInteger i = 0; i < lackCount; i++) {
            CJBubble *bubble = [CJBubble layerWithBubbleFillColor:_pageIndicatorTintColor];
            [_bubbles addObject:bubble];
        }
    } else if (lackCount < 0) {
        // 小球太多，删除多余的小球
        lackCount = ABS(lackCount);
        [_bubbles removeObjectsInRange:NSMakeRange(0, lackCount)];
    }
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    [self _moveMainBubbleToIndex:currentPage];
}

@end
