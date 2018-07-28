//
//  IMPiePoint.h
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/17.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPiePoint : NSObject

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) NSInteger tag;

+ (instancetype)point:(CGFloat)x :(CGFloat)y;

+ (instancetype)point:(CGPoint)point;

- (CGPoint)cgPoint;

/** 以点所在View中心点为坐标原点,而得的angle(弧度制) */
@property (nonatomic, assign) CGFloat angle;

@end
