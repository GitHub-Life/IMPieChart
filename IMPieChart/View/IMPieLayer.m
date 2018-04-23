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
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterPercentStyle;
    nf.maximumFractionDigits = _percentFractionalDigits;
    nf.minimumFractionDigits = _percentFractionalDigits;
    return [nf stringFromNumber:_percent];
}

@end
