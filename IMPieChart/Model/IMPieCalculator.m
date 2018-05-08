//
//  IMPieCalculator.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/17.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPieCalculator.h"

@implementation IMPieCalculator

+ (NSArray<NSNumber *> *)percentArrayWithDataArray:(NSArray<NSNumber *> *)dataArray order:(NSComparisonResult)order {
    NSArray<NSNumber *> *sortDataArray;
    if (order == NSOrderedSame) {
        sortDataArray = dataArray;
    } else {
        sortDataArray = [dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            double result = [obj1 doubleValue] - [obj2 doubleValue];
            if (result < 0) {
                return order;
            } else if (result > 0) {
                return -order;
            }
            return NSOrderedSame;
        }];
    }
    double sum = [[sortDataArray valueForKeyPath:@"@sum.doubleValue"] doubleValue];
    NSMutableArray<NSNumber *> *percentArray = [NSMutableArray array];
    for (NSNumber *num in sortDataArray) {
        [percentArray addObject:@(num.floatValue / sum)];
    }
    return percentArray;
}

+ (CGPoint)pointWithAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center {
    CGFloat x = radius * cos(angle);
    CGFloat y = radius * sin(angle);
    return CGPointMake(center.x + x, center.y + y);
}

+ (CGFloat)offsetAngleWithAngle:(CGFloat)angle radius:(CGFloat)radius separatorWidth:(CGFloat)separatorWidth clockwise:(BOOL)clockwise {
    CGFloat offsetAngle = asin(separatorWidth * 0.5 / radius);
    return clockwise ? (angle + offsetAngle) : (angle - offsetAngle);
}

+ (CGPoint)pointWithAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center separatorWidth:(CGFloat)separatorWidth clockwise:(BOOL)clockwise {
    angle = [self offsetAngleWithAngle:angle radius:radius separatorWidth:separatorWidth clockwise:clockwise];
    return [self pointWithAngle:angle radius:radius center:center];
}

+ (CGFloat)angleWithAngle:(CGFloat)angle {
    if (angle < 2 * M_PI) {
        return angle;
    }
    return angle - (int)(angle / (2 * M_PI)) * 2 * M_PI;
}

@end
