//
//  IMPieCalculator.h
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/17.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPieCalculator : NSObject

+ (NSArray<NSNumber *> *)percentArrayWithDataArray:(NSArray<NSNumber *> *)dataArray order:(NSComparisonResult)order;

+ (CGPoint)pointWithAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center;

+ (CGFloat)offsetAngleWithAngle:(CGFloat)angle radius:(CGFloat)radius separatorWidth:(CGFloat)separatorWidth clockwise:(BOOL)clockwise;

+ (CGPoint)pointWithAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center separatorWidth:(CGFloat)separatorWidth clockwise:(BOOL)clockwise;

+ (CGFloat)angleWithAngle:(CGFloat)angle;

@end
