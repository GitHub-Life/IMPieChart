//
//  IMPoint.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/17.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPoint.h"
#import "IMPieCalculator.h"

@implementation IMPoint

+ (instancetype)point:(CGFloat)x :(CGFloat)y {
    IMPoint *point = [[IMPoint alloc] init];
    point.x = x;
    point.y = y;
    return point;
}

+ (instancetype)point:(CGPoint)point {
    IMPoint *imPoint = [[IMPoint alloc] init];
    imPoint.x = point.x;
    imPoint.y = point.y;
    return imPoint;
}

- (CGPoint)cgPoint {
    return CGPointMake(_x, _y);
}

- (CGFloat)angle {
    return [IMPieCalculator angleWithAngle:_angle];
}

@end
