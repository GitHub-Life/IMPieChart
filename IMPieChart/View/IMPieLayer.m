//
//  IMPieLayer.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/16.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPieLayer.h"

@implementation IMPieLayer

- (CGFloat)centerAngle {
    return (_startAngle + _endAngle) / 2;
}

- (NSString *)percentStr {
    return [NSString stringWithFormat:@"%.2f%%", _percent.floatValue * 100];
}

@end
