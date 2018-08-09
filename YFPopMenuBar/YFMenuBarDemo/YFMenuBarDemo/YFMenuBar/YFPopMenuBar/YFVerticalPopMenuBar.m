//
//  YFVerticalPopMenuBar.m
//   wineindustry
//
//  Created by OS on 2018/6/8.
//  Copyright © 2018年 Nonsense. All rights reserved.
//
#define RGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "YFVerticalPopMenuBar.h"
#import "PopMenuBarCell.h"
#import "CellModel.h"

static NSString *cellID = @"PopMenuBarCell";

@interface YFVerticalPopMenuBar ()<UITableViewDelegate,UITableViewDataSource>

/**
 箭头定点的偏移量（距离右侧）
 */
@property (assign, nonatomic) CGFloat arrowOffsetX;
@property (strong, nonatomic) UITableView *selectTableView;
@property (strong, nonatomic) NSMutableArray <CellModel *> *cellData;
@property (strong, nonatomic) CAShapeLayer *bLayer; //border layer
@property (assign, nonatomic) CGPoint position;
@end

@implementation YFVerticalPopMenuBar


- (id)initWithTitleList:(NSArray *)titleList imageList:(NSArray *)imageList showPosition:(CGPoint)origin{
    if (self = [super init]) {
        _titleList = titleList;
        _imgList = imageList;
        _position = origin;
        _titleColor = RGBColor(51, 51, 51);
        _arrowSize = CGSizeMake(10, 5);
        _arrowOffsetX = 20;
        _iconSize = CGSizeMake(20, 20);
        _borderWidth = 1;
        _borderColor = RGBColor(232, 232, 232);
        _radius = 4;
        
        self.backgroundColor = [UIColor whiteColor];
        [self reloadView];
        
        [self.selectTableView registerNib:[UINib nibWithNibName:@"PopMenuBarCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.selectTableView.delegate = self;
        self.selectTableView.dataSource = self;
        
    }
    return self;
}

//设置箭头
- (void)settingTopArrow{
    //上箭头
    //
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor redColor] set];
    //point 1-7从箭头顶点开始逆时针标记
    [path moveToPoint:CGPointMake(self.frame.size.width - self.arrowOffsetX, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - self.arrowOffsetX - self.arrowSize.width / 2.0, self.arrowSize.height)];
    [path addArcWithCenter:CGPointMake(0 + _radius, self.arrowSize.height + _radius) radius:_radius startAngle:M_PI * 3 / 2.0 endAngle:M_PI clockwise:0];
    [path addArcWithCenter:CGPointMake(_radius, self.frame.size.height - _radius) radius:_radius startAngle:M_PI endAngle:M_PI / 2.0 clockwise:0];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - _radius, self.frame.size.height - _radius) radius:_radius startAngle:M_PI / 2.0 endAngle:M_PI * 2 clockwise:0];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - _radius, self.arrowSize.height + _radius) radius:_radius startAngle:2 * M_PI endAngle:M_PI * 3 / 2.0 clockwise:0];
    [path addLineToPoint:CGPointMake(self.frame.size.width - self.arrowOffsetX + self.arrowSize.width / 2.0, self.arrowSize.height)];
    [path closePath];
    
    //作为mask的layer 不能有子类或者父类layer 所以需要重新实例化一个layer作为边界border的颜色
    if (_bLayer) {
        [_bLayer removeFromSuperlayer];
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    _bLayer = [CAShapeLayer layer];
    _bLayer.lineWidth = self.borderWidth;
    _bLayer.strokeColor = [self.borderColor CGColor];
    _bLayer.fillColor = [[UIColor clearColor] CGColor];
    _bLayer.path = path.CGPath;
    layer.path = path.CGPath;
    [self.layer addSublayer:_bLayer];
    self.layer.mask = layer;
}


#pragma mark - tableview delegate & tableview datsource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PopMenuBarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.cellData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate popMenuBar:self didSelectItemAtIndex:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat contentHeight = self.cellData[indexPath.row].imgSize.height > 17 ? self.iconSize.height : 17;
    return contentHeight + 20;
}

#pragma mark - Action

- (void)showMenuBarToView:(UIView *)view{
    [view addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hideMenuBar{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

#pragma mark - method

//获取view的frame
- (CGRect)gettingViewFrame{
    CGFloat height = 0;
    CGFloat width = 0;
    CGFloat contentHeight = 0;
    for (int i = 0; i < self.cellData.count; i++) {
        contentHeight = self.cellData[i].imgSize.height > 17 ? self.cellData[i].imgSize.height : 17;
        height += contentHeight + 20;
    }
    height += self.arrowSize.height;
    if (self.imgList.count && self.titleList.count) {//图片文字都有
        width = [self gettingMaxWidthWithTitleList] + 34 + self.iconSize.width;
    }
    else if (self.imgList.count){//只有图片
        width = self.iconSize.width + 21;
    }
    else if (self.titleList.count){//只有文字
        width = [self gettingMaxWidthWithTitleList] + 26;
    }
    else{
        width = 0;
    }
    return CGRectMake(self.position.x, self.position.y, width, height);
}

//获取最长文字宽度
- (CGFloat)gettingMaxWidthWithTitleList{
    CGFloat maxWidth = 0;
    for (NSString *str in self.titleList) {
        CGFloat tmpWidth = [self gettingStringWidthWithString:str];
        if (tmpWidth > maxWidth) {
            maxWidth = tmpWidth;
        }
    }
    return maxWidth;
}

//获取字符串宽度
- (CGFloat)gettingStringWidthWithString:(NSString *)str{
    return [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width + 1;
}

//刷新
- (void)reloadMenuData{
    self.cellData = nil;
    [self.selectTableView reloadData];
    [self reloadView];
}

- (void)reloadView{
    [self setFrame:[self gettingViewFrame]];
    [self settingTopArrow];
    self.selectTableView.frame = CGRectMake(0, self.arrowSize.height, self.frame.size.width, self.frame.size.height - self.arrowSize.height);
}

#pragma mark - setter & getter

- (void)setArrowSize:(CGSize)arrowSize{
    _arrowSize = arrowSize;
    [self reloadView];
}

- (void)setTitleList:(NSArray *)titleList{
    _titleList = titleList;
    [self reloadMenuData];
}

- (void)setImgList:(NSArray *)imgList{
    _imgList = imgList;
    [self reloadMenuData];
}

- (void)setIconSize:(CGSize)iconSize{
    _iconSize = iconSize;
    [self reloadMenuData];
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self reloadMenuData];
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    [self reloadView];
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self reloadView];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    [self reloadView];
}

#pragma mark - cell data

- (NSMutableArray<CellModel *> *)cellData{
    if (!_cellData) {
        _cellData = [NSMutableArray array];
        NSInteger count = 0;
        if (self.imgList.count > self.titleList.count) {
           count = self.imgList.count;
        }
        else if (self.titleList.count > self.imgList.count){
            count = self.titleList.count;
        }
        else{
            count = self.titleList.count;
        }
        for (int i = 0 ; i < count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (i < _titleList.count) {
                if (_titleList[i]) {
                    [dic setObject:_titleList[i] forKey:@"title"];
                    [dic setObject:self.titleColor forKey:@"titleColor"];
                }
            }
            if (i < _imgList.count) {
                if (_imgList[i]){
                    [dic setObject:_imgList[i] forKey:@"imgName"];
                    [dic setObject:[NSValue valueWithCGSize:self.iconSize] forKey:@"imgSize"];
                }
            }
            CellModel *model = [CellModel new];
            [model setValuesForKeysWithDictionary:dic];
            [_cellData addObject:model];
        }
    }
    return _cellData;
}

#pragma mark - setter & getter

- (UITableView *)selectTableView{
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] init];
//        _selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.arrowSize.height, self.frame.size.width, self.frame.size.height - self.arrowSize.height) style:UITableViewStylePlain];
        _selectTableView.scrollEnabled = NO;
        _selectTableView.backgroundColor = [UIColor clearColor];
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_selectTableView];
    }
    return _selectTableView;
}

@end
