//
//  UIView+IMArea.h
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/21.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CoordinateArea) {
    CoordinateOrigin = 0,
    CoordinateFirstQuadrant,
    CoordinateSecondQuadrant,
    CoordinateThirdQuadrant,
    CoordinateFourthQuadrant,
    CoordinateAxisNegativeX,
    CoordinateAxisPositiveX,
    CoordinateAxisNegativeY,
    CoordinateAxisPositiveY
};

@interface UIView (IMArea)

/** 以View中心点位坐标原点,判断point所在坐标区域 */
- (CoordinateArea)coordinateAreaWithPoint:(CGPoint)point;

/** 以View中心点位坐标原点,判断angle所在坐标区域 */
- (CoordinateArea)coordinateAreaWithAngle:(CGFloat)angle;

/** 以x = centerSelf.x的Y轴为分界线，两点是否在同一侧 */
- (BOOL)xAreaIsSameWithPoint:(CGPoint)point point1:(CGPoint)point1;

/** 以y = centerSelf.y的X轴为分界线，两点是否在同一侧 */
- (BOOL)yAreaIsSameWithPoint:(CGPoint)point point1:(CGPoint)point1;

/** 判断两个点 是否在同一区域 */
- (BOOL)areaIsSameWithPoint:(CGPoint)point point1:(CGPoint)point1;

@end
