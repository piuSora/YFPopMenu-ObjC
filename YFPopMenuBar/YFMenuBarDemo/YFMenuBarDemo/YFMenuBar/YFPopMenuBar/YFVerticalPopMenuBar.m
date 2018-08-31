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
#import "YFMenuCellModel.h"

static NSString *cellID = @"PopMenuBarCell";

@interface YFVerticalPopMenuBar ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *selectTableView;
@property (strong, nonatomic) NSMutableArray <YFMenuCellModel *> *cellData;
@property (strong, nonatomic) CAShapeLayer *bLayer; //border layer
@property (assign, nonatomic) CGPoint position;
@property (strong, nonatomic) NSMutableArray *cellHeight;//用于缓存每个cell行高
@end

@implementation YFVerticalPopMenuBar


- (id)initWithTitleList:(NSArray *)titleList imageList:(NSArray *)imageList showPosition:(CGPoint)origin delegate:(id<PopMenuDelegate>)delegate{
    _titleList = titleList;;
    _imgList = imageList;;
    _position = origin;;
    _delegate = delegate;
    
    self = [self init];
    return self;
}

- (id)init{
    if (self = [super init]) {
        _titleColor = RGBColor(51, 51, 51);
        _titleFont = [UIFont systemFontOfSize:14];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(popMenuBar:didSelectItemAtIndex:)]) {
        [self.delegate popMenuBar:self didSelectItemAtIndex:indexPath.row];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CellModel *tmpModel = self.cellData[indexPath.row];
//    CGFloat titleHeight = [self gettingStringSizeWithString:tmpModel.title attributes:tmpModel.attributes].height;
//    CGFloat contentHeight = tmpModel.imgSize.height > titleHeight ? tmpModel.imgSize.height : titleHeight;
//    return contentHeight + 20;
    return [self.cellHeight[indexPath.row] floatValue];
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
    self.cellHeight = [NSMutableArray array];
    //宽度及高度计算
    for (YFMenuCellModel *tmpModel in self.cellData) {
        CGFloat tmpWidth;//单行宽度
        CGFloat tmpHeight;//单行高度
        if (tmpModel.imgName && ![tmpModel.imgName isEqualToString:@""] && tmpModel.title && ![tmpModel.title isEqualToString:@""]) {
            //图片文字都有
            CGSize titleSize = [self gettingStringSizeWithString:tmpModel.title attributes:tmpModel.attributes paddingWidth:34 + self.iconSize.width];
            tmpWidth = titleSize.width + 34 + self.iconSize.width;
            tmpHeight = (tmpModel.imgSize.height > (titleSize.height) ? tmpModel.imgSize.height : (titleSize.height)) + 20;
        }
        else if (tmpModel.imgName){
            //只有图片
            tmpWidth = self.iconSize.width + 21;
            tmpHeight = self.iconSize.height + 20;
        }
        else if (tmpModel.title){
            //只有文字
            CGSize titleSize = [self gettingStringSizeWithString:tmpModel.title attributes:tmpModel.attributes paddingWidth:26];
            tmpWidth = titleSize.width + 26;
            tmpHeight = (titleSize.height) + 20 ;
        }
        else{
            tmpWidth = 0;
            tmpHeight = 0;
        }
        height += tmpHeight;
        width = tmpWidth > width ? tmpWidth : width;
        [self.cellHeight addObject:[NSNumber numberWithFloat:tmpHeight]];
    }
    height += self.arrowSize.height;
    if (self.menuFrame.size.height != 0) {//关闭自适应
        return self.frame;
    }
    return CGRectMake(self.position.x, self.position.y, width, height);
}

//获取字符串大小
- (CGSize)gettingStringSizeWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey, id>*)attributes paddingWidth:(CGFloat)padding{
    CGSize size;
    if (self.menuFrame.size.width) {//手动设置宽高计算
        size = [str boundingRectWithSize:CGSizeMake(self.menuFrame.size.width - padding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    }
    else{//单行大小计算
        size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        size = CGSizeMake(size.width + 0.5, size.height + 0.5);//autolayout布局会四舍五入 多留0.5空白
    }
    return size;
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

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
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

- (void)setArrowOffsetX:(CGFloat)arrowOffsetX{
    _arrowOffsetX = arrowOffsetX;
    [self reloadView];
}

- (void)setMenuFrame:(CGRect)menuFrame{
    _menuFrame = menuFrame;
    self.frame = menuFrame;
    self.selectTableView.scrollEnabled = YES;
    [self reloadView];
}

#pragma mark - cell data

- (NSMutableArray<YFMenuCellModel *> *)cellData{
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
            if (i < _titleList.count) {//设置标题数据源
                if (_titleList[i]) {
                    NSDictionary *attributes;
                    if ([self.delegate respondsToSelector:@selector(popMenuBar:attributesForIndex:)]) {//如果代理设置了富文本
                        attributes = [self.delegate popMenuBar:self attributesForIndex:i];
                    }
                    else{
                        attributes = @{NSForegroundColorAttributeName:_titleColor,NSFontAttributeName:_titleFont};
                    }
                    [dic setObject:attributes forKey:@"attributes"];
                    [dic setObject:_titleList[i] forKey:@"title"];
                }
            }
            if (i < _imgList.count) {//设置图片数据源
                if (_imgList[i]){
                    [dic setObject:_imgList[i] forKey:@"imgName"];
                    [dic setObject:[NSValue valueWithCGSize:self.iconSize] forKey:@"imgSize"];
                }
            }
            if ([self.delegate respondsToSelector:@selector(popMenuBar:backgroundImageForIndex:)]) {//设置背景图片数据源
                [dic setObject:[self.delegate popMenuBar:self backgroundImageForIndex:i] forKey:@"backgroundImage"];
            }
            //转模型
            YFMenuCellModel *model = [YFMenuCellModel new];
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
        _selectTableView.scrollEnabled = NO;
        _selectTableView.backgroundColor = [UIColor clearColor];
        _selectTableView.showsVerticalScrollIndicator = NO;
        _selectTableView.showsHorizontalScrollIndicator = NO;
        _selectTableView.tableFooterView = [UIView new];
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_selectTableView];
    }
    return _selectTableView;
}

@end
