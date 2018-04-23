//
//  UIView+IMArea.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/21.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "UIView+IMArea.h"
#import "UIView+IMRect.h"

@implementation UIView (IMArea)

- (CoordinateArea)coordinateAreaWithPoint:(CGPoint)point {
    CGPoint center = self.centerSelf;
    if (point.x == center.x && point.y == center.y) {
        return CoordinateOrigin;
    } else if (point.x == center.x) {
        if (point.y < 0) {
            return CoordinateAxisNegativeY;
        }
        return CoordinateAxisPositiveY;
    } else if (point.y == center.y) {
        if (point.x < 0) {
            return CoordinateAxisNegativeX;
        }
        return CoordinateAxisPositiveX;
    } else if (point.x < center.x) {
        if (point.y < center.y) {
            return CoordinateThirdQuadrant;
        }
        return CoordinateSecondQuadrant;
    } else {
        if (point.y < center.y) {
            return CoordinateFourthQuadrant;
        }
        return CoordinateFirstQuadrant;
    }
}

- (CoordinateArea)coordinateAreaWithAngle:(CGFloat)angle {
    CGPoint testPoint = CGPointMake(self.centerSelf.x + cos(angle), self.centerSelf.y + sin(angle));
    return [self coordinateAreaWithPoint:testPoint];
}

- (BOOL)xAreaIsSameWithPoint:(CGPoint)point point1:(CGPoint)point1 {
    return (point.x < self.centerSelf.x && point1.x < self.centerSelf.x) || (point.x > self.centerSelf.x && point1.x > self.centerSelf.x);
}

- (BOOL)yAreaIsSameWithPoint:(CGPoint)point point1:(CGPoint)point1 {
    return (point.y < self.centerSelf.y && point1.y < self.centerSelf.y) || (point.y > self.centerSelf.y && point1.y > self.centerSelf.y);
}

- (BOOL)areaIsSameWithPoint:(CGPoint)point point1:(CGPoint)point1 {
    return [self coordinateAreaWithPoint:point] == [self coordinateAreaWithPoint:point1];
}

@end
