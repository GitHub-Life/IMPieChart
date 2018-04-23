//
//  IMPieLayer.h
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/16.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface IMPieLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign, readonly) CGFloat centerAngle;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSNumber *num;
@property (nonatomic, copy) NSNumber *percent;
@property (nonatomic, assign) int percentFractionalDigits;
@property (nonatomic, copy, readonly) NSString *percentStr;
@property (nonatomic, copy) NSString *desc;


@end
