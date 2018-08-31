//
//  YFVerticalPopMenuBar.h
//   wineindustry
//
//  Created by OS on 2018/6/8.
//  Copyright © 2018年 Nonsense. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopMenuDelegate;

@interface YFVerticalPopMenuBar : UIView

/**
 箭头三角形底和高 默认10*5
 */
@property (assign, nonatomic) CGSize arrowSize;

/**
 箭头定点的偏移量（距离右侧）默认20
 */
@property (assign, nonatomic) CGFloat arrowOffsetX;

/**
 圆角  默认4
 */
@property (assign, nonatomic) CGFloat radius;

/**
 border颜色
 */
@property (strong, nonatomic) UIColor *borderColor;

/**
 border宽度 默认1
 */
@property (assign, nonatomic) CGFloat borderWidth;

/**
 图标大小 默认20*20
 */
@property (assign, nonatomic) CGSize iconSize;

/**
 图片源
 */
@property (strong, nonatomic) NSArray *imgList;

/**
 标题源
 */
@property (strong, nonatomic) NSArray *titleList;

/**
 title颜色
 */
@property (strong, nonatomic) UIColor *titleColor;

/**
 title字体
 */
@property (strong, nonatomic) UIFont *titleFont;

/**
 menu的Frame 如果设置此属性 将关闭宽高自适应
 */
@property (assign, nonatomic) CGRect menuFrame;


/**
 代理
 */
@property (strong, nonatomic) id <PopMenuDelegate>delegate;

/**
 实例化方法
 */
- (instancetype)initWithTitleList:(NSArray <NSString *>*)titleList imageList:(NSArray <NSString *>*)imageList showPosition:(CGPoint)origin delegate:(id <PopMenuDelegate>)delegate;

/**
 展示隐藏方法
 */
- (void)showMenuBarToView:(UIView *)view;

- (void)hideMenuBar;

@end

#pragma mark - Protocol
@protocol PopMenuDelegate <NSObject>
@optional

- (void)popMenuBar:(YFVerticalPopMenuBar *)popMenuBar didSelectItemAtIndex:(NSUInteger)index;

- (NSDictionary<NSAttributedStringKey, id>*)popMenuBar:(YFVerticalPopMenuBar *)popMenuBar attributesForIndex:(NSUInteger)index;

- (NSString *)popMenuBar:(YFVerticalPopMenuBar *)popMenuBar backgroundImageForIndex:(NSUInteger)index;

@end
