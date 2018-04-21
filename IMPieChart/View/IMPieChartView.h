//
//  IMPieChartView.h
//  IMPieChartDemo
//
//  Created by 万涛 on 2018/4/16.
//  Copyright © 2018年 iMoon. All rights reserved.
//

/** 坐标系
 *  ③ | ④
 *  ------>
 *  ② ↓ ①
 */

#import <UIKit/UIKit.h>
@class IMPieLayer;

typedef NS_ENUM(NSInteger, IMPieDescShowStyle) {
    IMPieDescShowStyleNone = 0,
    IMPieDescShowStyle1
};

typedef void(^ClickPieBlock)(IMPieLayer *pieLayer);

@interface IMPieChartView : UIView

/** 数据的排序方式 */
@property (nonatomic, assign) NSComparisonResult order;

/** 开始绘制的角度(弧度制) */
@property (nonatomic, assign) CGFloat startAngle;

/** 扇形的内外径差 */
@property (nonatomic, assign) IBInspectable CGFloat sectorWidth;

/** 空心半径 */
@property (nonatomic, assign) IBInspectable CGFloat hollowRadius;

/** 每个扇形之间的分隔距离 */
@property (nonatomic, assign) IBInspectable CGFloat separatorWidth;

/** 点击每个扇形时，扇形动画偏移量(若此值为0，则无偏移动画) */
@property (nonatomic, assign) IBInspectable CGFloat animOffset;

/** 是否动画绘制 */
@property (nonatomic, assign) IBInspectable BOOL drawAnimation;

/** 数据的描述样式 */
@property (nonatomic, assign) IMPieDescShowStyle descShowStyle;

/** 饼状图每个扇形的颜色集合，当颜色数量<numArray数量时, 颜色循环取出使用 */
@property (nonatomic, strong) NSArray<UIColor *> *colors;

/** 点击饼状图的回调事件 */
@property (nonatomic, strong) ClickPieBlock clickPieEvent;

/** 设置此值 即开始绘制饼状图 */
@property (nonatomic, strong) NSArray<NSNumber *> *numArray;
/** 数值的描述集合(如果此集合中的数量<numArray数量时,将不做显示) */
@property (nonatomic, strong) NSArray<NSString *> *descArray;
/** 描述文本颜色 */
@property (nonatomic, copy) IBInspectable UIColor *descColor;
/** 描述文本字体 */
@property (nonatomic, copy) UIFont *descFont;
/** 百分比文本字体 */
@property (nonatomic, copy) UIFont *percentFont;

/** 选中的扇形索引值(未选中任何扇形，值为-1) */
@property (nonatomic, assign) NSInteger selectedIndex;

@end
