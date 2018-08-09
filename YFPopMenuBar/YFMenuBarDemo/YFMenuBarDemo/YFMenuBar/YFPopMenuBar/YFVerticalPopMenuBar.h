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
 箭头三角形底和高
 */
@property (assign, nonatomic) CGSize arrowSize;

/**
 圆角
 */
@property (assign, nonatomic) CGFloat radius;

/**
 border颜色
 */
@property (strong, nonatomic) UIColor *borderColor;

/**
 border宽度
 */
@property (assign, nonatomic) CGFloat borderWidth;

/**
 图标大小
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

@property (strong, nonatomic) id <PopMenuDelegate>delegate;

- (instancetype)initWithTitleList:(NSArray *)titleList imageList:(NSArray *)imageList showPosition:(CGPoint)origin;

- (void)showMenuBarToView:(UIView *)view;
- (void)hideMenuBar;

@end

#pragma mark - Protocol
@protocol PopMenuDelegate <NSObject>
@optional

- (void)popMenuBar:(YFVerticalPopMenuBar *)popMenuBar didSelectItemAtIndex:(NSUInteger)index;

@end
