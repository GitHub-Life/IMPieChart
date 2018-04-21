//
//  IMPieChartView.m
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/16.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPieChartView.h"
#import "IMPieCalculator.h"
#import "IMPieLayer.h"
#import "UIView+IMArea.h"
#import "UIView+IMRect.h"
#import "IMPiePoint.h"

#define DescStyle1Offset 10
#define DescStyle1Font [UIFont systemFontOfSize:10]
#define DescSpace 2

@interface IMPieChartView ()

@property (nonatomic, strong) NSMutableArray<IMPieLayer *> *pieLayers;

@property (nonatomic, assign, readonly) BOOL showDesc;

@end

@implementation IMPieChartView

- (UIColor *)colorWithIndex:(NSInteger)index {
    return _colors[index % _colors.count];
}

- (BOOL)showDesc {
    return (_descArray && _descArray.count >= _numArray.count);
}

- (void)setNumArray:(NSArray<NSNumber *> *)numArray {
    _numArray = numArray;
    [self draw];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    self.backgroundColor = [UIColor clearColor];
}

- (void)draw {
    NSMutableArray *ma = self.layer.sublayers.mutableCopy;
    for (CALayer *layer in ma) {
        [layer removeFromSuperlayer];
    }
    _pieLayers = [NSMutableArray array];
    _selectedIndex = -1;
    if (!_colors || !(_colors.count)
        || !_numArray || !(_numArray.count)) {
        return;
    }
    NSArray<NSNumber *> *percents = [IMPieCalculator percentArrayWithDataArray:_numArray order:_order];
    
    CGFloat startAngle = _startAngle;
    
    for (int i = 0; i < percents.count; i++) {
        IMPieLayer *pieLayer = [IMPieLayer layer];
        pieLayer.index = i;
        pieLayer.num = _numArray[i];
        pieLayer.percent = percents[i];
        if (self.showDesc) {
            pieLayer.desc = _descArray[i];
        }
        CGFloat endAngle = startAngle + 2 * M_PI * percents[i].floatValue;
        UIBezierPath *piePath = [self sectorPathWithStartAngle:startAngle endAngle:endAngle];
        // 颜色数量<numArray数量时，后面的颜色取颜色数组的最后一个元素
//        pieLayer.fillColor = (i < _colors.count ? _colors[i] : _colors.lastObject).CGColor;
        // 颜色数量<numArray数量时，颜色循环使用
        pieLayer.fillColor = [self colorWithIndex:i].CGColor;
        pieLayer.startAngle = startAngle;
        pieLayer.endAngle = endAngle;
        pieLayer.path = piePath.CGPath;
        [self.layer addSublayer:pieLayer];
        [_pieLayers addObject:pieLayer];
        startAngle = endAngle;
    }
    if (_drawAnimation) {
        [self addAnimation];
    }
    [self setNeedsDisplay];
}

#pragma mark - 扇形的 BezierPath
- (UIBezierPath *)sectorPathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    if (_separatorWidth > 0) {
        CGFloat offsetAfterStartAngle = [IMPieCalculator offsetAngleWithAngle:startAngle radius:_hollowRadius separatorWidth:_separatorWidth clockwise:YES];
        CGFloat offsetAfterStartAngle1 = [IMPieCalculator offsetAngleWithAngle:startAngle radius:(_hollowRadius + _sectorWidth) separatorWidth:_separatorWidth clockwise:YES];
        CGFloat offsetAfterEndAngle = [IMPieCalculator offsetAngleWithAngle:endAngle radius:_hollowRadius separatorWidth:_separatorWidth clockwise:NO];
        CGFloat offsetAfterEndAngle1 = [IMPieCalculator offsetAngleWithAngle:endAngle radius:(_hollowRadius + _sectorWidth) separatorWidth:_separatorWidth clockwise:NO];
        [piePath moveToPoint:[IMPieCalculator pointWithAngle:offsetAfterStartAngle radius:_hollowRadius center:self.centerSelf]];
        [piePath addArcWithCenter:self.centerSelf radius:_hollowRadius startAngle:offsetAfterStartAngle endAngle:offsetAfterEndAngle clockwise:YES];
        [piePath addLineToPoint:[IMPieCalculator pointWithAngle:offsetAfterEndAngle1 radius:(_hollowRadius + _sectorWidth) center:self.centerSelf]];
        [piePath addArcWithCenter:self.centerSelf radius:(_hollowRadius + _sectorWidth) startAngle:offsetAfterEndAngle1 endAngle:offsetAfterStartAngle1 clockwise:NO];
    } else {
        [piePath moveToPoint:[IMPieCalculator pointWithAngle:startAngle radius:_hollowRadius center:self.centerSelf]];
        [piePath addArcWithCenter:self.centerSelf radius:_hollowRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [piePath addLineToPoint:[IMPieCalculator pointWithAngle:endAngle radius:(_hollowRadius + _sectorWidth) center:self.centerSelf]];
        [piePath addArcWithCenter:self.centerSelf radius:(_hollowRadius + _sectorWidth) startAngle:endAngle endAngle:startAngle clockwise:NO];
    }
    [piePath closePath];
    return piePath;
}

#pragma mark - 点击扇形事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    BOOL validArea = NO;
    for (IMPieLayer *pieLayer in _pieLayers) {
        if (CGPathContainsPoint(pieLayer.path, &CGAffineTransformIdentity, point, 0)) {
            validArea = YES;
            self.selectedIndex = pieLayer.index;
        } else {
            pieLayer.position = CGPointZero;
            pieLayer.isSelected = NO;
        }
    }
    if (!validArea) {
        self.selectedIndex = -1;
    }
}

#pragma mark - 设置选中的扇形
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    IMPieLayer *prevSelectedLayer;
    if (_selectedIndex >= 0 && _selectedIndex < _pieLayers.count && _selectedIndex != selectedIndex) {
        prevSelectedLayer = _pieLayers[_selectedIndex];
        prevSelectedLayer.position = CGPointZero;
        prevSelectedLayer.isSelected = NO;
    }
    if (selectedIndex >= 0 && selectedIndex < _pieLayers.count) {
        IMPieLayer *pieLayer = _pieLayers[selectedIndex];
        pieLayer.isSelected = !pieLayer.isSelected;
        if (_animOffset > 0 && pieLayer.isSelected) {
            [self sectorOffset:pieLayer];
        } else {
            pieLayer.position = CGPointZero;
        }
        if (_clickPieEvent) {
            _clickPieEvent(pieLayer);
        }
    } else {
        selectedIndex = -1;
        if (prevSelectedLayer && _clickPieEvent) {
            _clickPieEvent(prevSelectedLayer);
        }
    }
    _selectedIndex = selectedIndex;
}

#pragma mark - 设置扇形的偏移
- (void)sectorOffset:(IMPieLayer *)pieLayer {
    CGPoint originalPosition = pieLayer.position;
    double middleAngle = (pieLayer.startAngle + pieLayer.endAngle) / 2.0;
    CGPoint newPosition = CGPointMake(originalPosition.x + self.animOffset * cos(middleAngle), originalPosition.y + self.animOffset * sin(middleAngle));
    pieLayer.position = newPosition;
}

#pragma mark - 添加绘制动画
- (void)addAnimation {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    CGFloat diagonalLength_2 = sqrt(pow(self.bounds.size.width, 2) + pow(self.bounds.size.height, 2)) / 2;
    maskLayer.lineWidth = diagonalLength_2;
    maskLayer.path = [UIBezierPath bezierPathWithArcCenter:self.centerSelf radius:(diagonalLength_2 / 2) startAngle:_startAngle endAngle:_startAngle + 2 * M_PI clockwise:YES].CGPath;
    self.layer.mask = maskLayer;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 1;
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:anim forKey:@"strokeEnd"];
}

#pragma mark - 绘制描述文本
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!_pieLayers) {
        return;
    }
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    if (_descShowStyle == IMPieDescShowStyle1) {
        [self descShowStyle1DrawMethod1];
    }
}

#pragma mark - 绘制 Style1 的描述
/** 绘制 Style1 的描述 步骤1 */
- (void)descShowStyle1DrawMethod1 {
    /** 将折点分不同区域先缓存起来，到最后再遍历绘制 */
    NSMutableArray<IMPiePoint *> *firstQuadrantInflexionPoints = [NSMutableArray array];
    NSMutableArray<IMPiePoint *> *secondQuadrantInflexionPoints = [NSMutableArray array];
    NSMutableArray<IMPiePoint *> *thirdQuadrantInflexionPoints = [NSMutableArray array];
    NSMutableArray<IMPiePoint *> *fourthQuadrantInflexionPoints = [NSMutableArray array];
    for (int i = 0; i < _pieLayers.count; i++) {
        IMPieLayer *pieLayer = _pieLayers[i];
        CGPoint inflexionPoint = [IMPieCalculator pointWithAngle:pieLayer.centerAngle radius:(_hollowRadius + _sectorWidth + DescStyle1Offset) center:self.centerSelf];
        CoordinateArea area = [self coordinateAreaWithPoint:inflexionPoint];
        IMPiePoint *imPoint = [IMPiePoint point:inflexionPoint];
        imPoint.tag = i;
        imPoint.angle = pieLayer.centerAngle;
        // 当折点与上一个折点回出现绘制位置重合的时候，根据区所处区域分别向不同的方向偏移
        switch (area) {
            case CoordinateAxisPositiveX:
            case CoordinateFirstQuadrant: {
                // 第一象限(即View右下方区域),先缓存,后遍历绘制
                [firstQuadrantInflexionPoints addObject:imPoint];
            } break;
            case CoordinateAxisPositiveY:
            case CoordinateSecondQuadrant: {
                // 第二象限(即View左下方区域),先缓存,后遍历绘制
                [secondQuadrantInflexionPoints addObject:imPoint];
            } break;
            case CoordinateAxisNegativeX:
            case CoordinateThirdQuadrant: {
                // 第三象限(即View右下方区域),先缓存,后遍历绘制
                [thirdQuadrantInflexionPoints addObject:imPoint];
            } break;
            case CoordinateAxisNegativeY:
            case CoordinateFourthQuadrant: {
                // 第四象限(即View右上方区域),先缓存,后遍历绘制
                [fourthQuadrantInflexionPoints addObject:imPoint];
            } break;
            case CoordinateOrigin: break;
        }
    }
    
    // 这里之所以根据起始区域设置最初的参考折点的区域，是为了防止第一个扇形的角度超过π而出现绘制超出显示范围
    // 参考折点设置的区域为其实角度所在象限的前一个象限即可
    // 绘制第四象限的折点，将初始参考折点设置在第三象限
    CGPoint prevInflexionPoint = CGPointZero;
    fourthQuadrantInflexionPoints = [fourthQuadrantInflexionPoints sortedArrayUsingComparator:^NSComparisonResult(IMPiePoint *obj1, IMPiePoint *obj2) {
        if (obj1.angle < obj2.angle) {
            return NSOrderedDescending;
        } else if (obj1.angle > obj2.angle) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }].mutableCopy;
    for (IMPiePoint *point in fourthQuadrantInflexionPoints) {
        CGPoint inflexionPoint = point.cgPoint;
        IMPieLayer *pieLayer = _pieLayers[point.tag];
        CGSize percentStrSize = [pieLayer.percentStr sizeWithAttributes:@{NSFontAttributeName : DescStyle1Font}];
        // 与上一折点出现绘制重合时，向上偏移
        while ([self needOffset:inflexionPoint prevInflexionPoint:prevInflexionPoint textSize:percentStrSize]) {
            inflexionPoint.y -= 1;
        }
        [self descShowStyle1DrawMethod2With:inflexionPoint pieLayer:pieLayer];
        prevInflexionPoint = inflexionPoint;
    }
    
    // 绘制第一象限的折点，将初始参考折点为第四象限角度最大的折点, 否则将其设置为第四象限任意点
    if (fourthQuadrantInflexionPoints.count) {
        prevInflexionPoint = fourthQuadrantInflexionPoints.firstObject.cgPoint;
    } else {
        prevInflexionPoint = CGPointMake(self.width, 0);
    }
    firstQuadrantInflexionPoints = [firstQuadrantInflexionPoints sortedArrayUsingComparator:^NSComparisonResult(IMPiePoint *obj1, IMPiePoint *obj2) {
        if (obj1.angle < obj2.angle) {
            return NSOrderedAscending;
        } else if (obj1.angle > obj2.angle) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }].mutableCopy;
    for (IMPiePoint *point in firstQuadrantInflexionPoints) {
        CGPoint inflexionPoint = point.cgPoint;
        IMPieLayer *pieLayer = _pieLayers[point.tag];
        CGSize percentStrSize = [pieLayer.percentStr sizeWithAttributes:@{NSFontAttributeName : DescStyle1Font}];
        // 与上一折点出现绘制重合时，向下偏移
        while ([self needOffset:inflexionPoint prevInflexionPoint:prevInflexionPoint textSize:percentStrSize]) {
            inflexionPoint.y += 1;
        }
        [self descShowStyle1DrawMethod2With:inflexionPoint pieLayer:pieLayer];
        prevInflexionPoint = inflexionPoint;
    }
    
    // 绘制第二象限的折点，将初始参考折点设置在第一象限
    prevInflexionPoint = CGPointMake(self.width, self.height);
    secondQuadrantInflexionPoints = [secondQuadrantInflexionPoints sortedArrayUsingComparator:^NSComparisonResult(IMPiePoint *obj1, IMPiePoint *obj2) {
        if (obj1.angle < obj2.angle) {
            return NSOrderedDescending;
        } else if (obj1.angle > obj2.angle) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }].mutableCopy;
    for (IMPiePoint *point in secondQuadrantInflexionPoints) {
        CGPoint inflexionPoint = point.cgPoint;
        IMPieLayer *pieLayer = _pieLayers[point.tag];
        CGSize percentStrSize = [pieLayer.percentStr sizeWithAttributes:@{NSFontAttributeName : DescStyle1Font}];
        // 与上一折点出现绘制重合时，向下偏移
        while ([self needOffset:inflexionPoint prevInflexionPoint:prevInflexionPoint textSize:percentStrSize]) {
            inflexionPoint.y += 1;
        }
        [self descShowStyle1DrawMethod2With:inflexionPoint pieLayer:pieLayer];
        prevInflexionPoint = inflexionPoint;
    }
    
    // 绘制第三象限的折点, 将初始参考折点为第二限角度最大的折点, 否则将其设置为第二象限任意点
    if (secondQuadrantInflexionPoints.count) {
        prevInflexionPoint = secondQuadrantInflexionPoints.firstObject.cgPoint;
    } else {
        prevInflexionPoint = CGPointMake(0, self.height);
    }
    thirdQuadrantInflexionPoints = [thirdQuadrantInflexionPoints sortedArrayUsingComparator:^NSComparisonResult(IMPiePoint *obj1, IMPiePoint *obj2) {
        if (obj1.angle < obj2.angle) {
            return NSOrderedAscending;
        } else if (obj1.angle > obj2.angle) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }].mutableCopy;
    for (IMPiePoint *point in thirdQuadrantInflexionPoints) {
        CGPoint inflexionPoint = point.cgPoint;
        IMPieLayer *pieLayer = _pieLayers[point.tag];
        CGSize percentStrSize = [pieLayer.percentStr sizeWithAttributes:@{NSFontAttributeName : DescStyle1Font}];
        // 与上一折点出现绘制重合时，向上偏移
        while ([self needOffset:inflexionPoint prevInflexionPoint:prevInflexionPoint textSize:percentStrSize]) {
            inflexionPoint.y -= 1;
        }
        [self descShowStyle1DrawMethod2With:inflexionPoint pieLayer:pieLayer];
        prevInflexionPoint = inflexionPoint;
    }
}

/** 绘制 Style1 的描述 步骤2 */
- (void)descShowStyle1DrawMethod2With:(CGPoint)inflexionPoint pieLayer:(IMPieLayer *)pieLayer {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *indexLinePath = [UIBezierPath bezierPath];
    [indexLinePath moveToPoint:[IMPieCalculator pointWithAngle:pieLayer.centerAngle radius:(_hollowRadius + _sectorWidth) center:self.centerSelf]];
    [indexLinePath addLineToPoint:inflexionPoint];
    CGSize percentStrSize = [pieLayer.percentStr sizeWithAttributes:@{NSFontAttributeName : DescStyle1Font}];
    if (inflexionPoint.x <= self.centerSelf.x) {
        CGPoint endPoint = CGPointMake((self.centerSelf.x - _hollowRadius - _sectorWidth - DescStyle1Offset), inflexionPoint.y);
        [indexLinePath addLineToPoint:endPoint];
        [pieLayer.percentStr drawAtPoint:CGPointMake((endPoint.x - percentStrSize.width - DescSpace), endPoint.y - percentStrSize.height / 2) withAttributes:@{NSFontAttributeName : DescStyle1Font, NSForegroundColorAttributeName : [self colorWithIndex:pieLayer.index]}];
        if (self.showDesc) {
            CGSize descSize = [_descArray[pieLayer.index] sizeWithAttributes:@{NSFontAttributeName : DescStyle1Font}];
            [_descArray[pieLayer.index] drawAtPoint:CGPointMake((endPoint.x - percentStrSize.width - DescSpace - descSize.width - DescSpace), endPoint.y - descSize.height / 2) withAttributes:@{NSFontAttributeName : DescStyle1Font, NSForegroundColorAttributeName : [UIColor darkTextColor]}];
        }
    } else {
        CGPoint endPoint = CGPointMake((self.centerSelf.x + _hollowRadius + _sectorWidth + DescStyle1Offset), inflexionPoint.y);
        [indexLinePath addLineToPoint:endPoint];
        if (self.showDesc) {
            CGSize descSize = [_descArray[pieLayer.index] sizeWithAttributes:@{NSFontAttributeName : DescStyle1Font}];
            [_descArray[pieLayer.index] drawAtPoint:CGPointMake((endPoint.x + DescSpace), endPoint.y - descSize.height / 2) withAttributes:@{NSFontAttributeName : DescStyle1Font, NSForegroundColorAttributeName : [UIColor darkTextColor]}];
            [pieLayer.percentStr drawAtPoint:CGPointMake((endPoint.x + DescSpace + descSize.width + DescSpace), endPoint.y - percentStrSize.height / 2) withAttributes:@{NSFontAttributeName : DescStyle1Font, NSForegroundColorAttributeName : [self colorWithIndex:pieLayer.index]}];
        } else {
            [pieLayer.percentStr drawAtPoint:CGPointMake((endPoint.x + DescSpace), endPoint.y - percentStrSize.height / 2) withAttributes:@{NSFontAttributeName : DescStyle1Font, NSForegroundColorAttributeName : [self colorWithIndex:pieLayer.index]}];
        }
    }
    CGContextSetStrokeColorWithColor(context, [self colorWithIndex:pieLayer.index].CGColor);
    [indexLinePath stroke];
}

/** 是否需要偏移折点 */
- (BOOL)needOffset:(CGPoint)inflexionPoint prevInflexionPoint:(CGPoint)prevInflexionPoint textSize:(CGSize)textSize {
    BOOL xAreaIsSame = [self xAreaIsSameWithPoint:inflexionPoint point1:prevInflexionPoint];
    BOOL textOverlap = fabs(inflexionPoint.y - prevInflexionPoint.y) < textSize.height;
    BOOL positionNeedOffset = NO;
    CoordinateArea area = [self coordinateAreaWithPoint:inflexionPoint];
    switch (area) {
        case CoordinateAxisPositiveX:
        case CoordinateFirstQuadrant:
        case CoordinateAxisPositiveY:
        case CoordinateSecondQuadrant: {
            positionNeedOffset = inflexionPoint.y < prevInflexionPoint.y;
        } break;
        case CoordinateAxisNegativeX:
        case CoordinateThirdQuadrant:
        case CoordinateAxisNegativeY:
        case CoordinateFourthQuadrant: {
            positionNeedOffset = inflexionPoint.y > prevInflexionPoint.y;
        } break;
        case CoordinateOrigin: break;
    }
    return xAreaIsSame && (textOverlap || positionNeedOffset);
}

@end
