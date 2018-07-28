//
//  ViewController.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/16.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "ViewController.h"
#import "IMPieChartView.h"
#import "IMPieLayer.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet IMPieChartView *pieChartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pieChartViewHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pieChartView.sectorWidth = 30;
    _pieChartView.hollowRadius = 30;
    _pieChartView.startAngle = -M_PI_2;
    _pieChartView.animOffset = 10;
    _pieChartView.drawAnimation = YES;
    _pieChartView.descShowStyle = IMPieDescShowStyle1;
    _pieChartView.order = NSOrderedDescending;
//    _pieChartView.colors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor purpleColor]];
    _pieChartView.colors = @[[UIColor blackColor], [UIColor whiteColor]];
    _pieChartView.descArray = @[@"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖", @"拾"];
    [_pieChartView setClickPieEvent:^(IMPieLayer *pieLayer) {
        NSLog(@"isSelected = %d, index = %d, num = %@, percent = %@", pieLayer.isSelected, (int)pieLayer.index, pieLayer.num, pieLayer.percentStr);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self randowRedraw];
}

- (IBAction)randowRedraw {
    int count = arc4random() % 10 + 1;
    NSMutableArray<NSNumber *> *numArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [numArray addObject:@(arc4random() % 100 + 1)];
    }
    _pieChartView.numArray = numArray;
}

- (IBAction)selectedNext {
    _pieChartView.selectedIndex = (_pieChartView.selectedIndex + 1) % _pieChartView.numArray.count;
}

- (IBAction)needIncreaseHeight {
    _pieChartView.numArray = @[@99, @0.2, @0.3, @0.1, @0.4];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_pieChartView addObserver:self forKeyPath:@"needIncreaseHeight" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_pieChartView removeObserver:self forKeyPath:@"needIncreaseHeight"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _pieChartView && [keyPath isEqualToString:@"needIncreaseHeight"]) {
        CGFloat newValue = [change[@"new"] doubleValue];
        if (newValue > 0) {
            _pieChartViewHeight.constant += newValue * 2;
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.pieChartView setNeedsDisplay];
            });
        }
    }
    NSLog(@" - keyPath = %@", keyPath);
    NSLog(@" - object = %@", object);
    NSLog(@" - change = %@", change);
}

@end
