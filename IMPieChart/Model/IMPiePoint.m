//
//  IMPiePoint.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/17.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPiePoint.h"
#import "IMPieCalculator.h"

@implementation IMPiePoint

+ (instancetype)point:(CGFloat)x :(CGFloat)y {
    IMPiePoint *imPiePoint = [[IMPiePoint alloc] init];
    imPiePoint.x = x;
    imPiePoint.y = y;
    return imPiePoint;
}

+ (instancetype)point:(CGPoint)point {
    IMPiePoint *imPiePoint = [[IMPiePoint alloc] init];
    imPiePoint.x = point.x;
    imPiePoint.y = point.y;
    return imPiePoint;
}

- (CGPoint)cgPoint {
    return CGPointMake(_x, _y);
}

- (CGFloat)angle {
    return [IMPieCalculator angleWithAngle:_angle];
}

@end
