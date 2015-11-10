//
//  ViewController.m
//  CJRubberIndicator
//
//  Created by chenjiantao on 15/11/2.
//  Copyright © 2015年 chenjiantao. All rights reserved.
//

#import "ViewController.h"
#import "CJRubberIndicator.h"
#import "CALayer+CJAnimations.h"

@interface ViewController ()
@property (nonatomic, strong) CJRubberIndicator *indicator;
@property (nonatomic, assign) BOOL goRight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goRight = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.553 green:0.376 blue:0.549 alpha:1];
    
    CJRubberIndicator *indicator = [[CJRubberIndicator alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 34)];
    indicator.numberOfPages = 8;
    indicator.currentPage = 0;
    [self.view addSubview:indicator];
    indicator.center = self.view.center;
    self.indicator = indicator;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(go:) userInfo:nil repeats:YES];
}

- (void)go:(NSTimer *)tm {
    if (self.goRight) {
        self.indicator.currentPage++;
        self.goRight = self.indicator.currentPage != self.indicator.numberOfPages - 1;
    } else {
        self.indicator.currentPage--;
        self.goRight = self.indicator.currentPage == 0;
    }
    NSLog(@"currentPage:%ld", self.indicator.currentPage);
}

@end
