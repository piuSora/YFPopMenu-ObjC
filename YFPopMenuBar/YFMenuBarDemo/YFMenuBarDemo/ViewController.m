//
//  ViewController.m
//  YFMenuBarDemo
//
//  Created by OS on 2018/8/8.
//  Copyright © 2018年 Piu. All rights reserved.
//

#import "ViewController.h"
#import "YFVerticalPopMenuBar.h"

@interface ViewController () <PopMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSArray *attributesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)action:(UIButton *)sender {
    YFVerticalPopMenuBar *verticalMenu = [[YFVerticalPopMenuBar alloc] initWithTitleList:@[@"123",@"345",@"98765431231212312312312312312312312"] imageList:@[@"ranking_China",@"ranking_China",@"ranking_China"] showPosition:CGPointMake(sender.frame.origin.x - 100, sender.center.y + sender.frame.size.height) delegate:self];
//    verticalMenu.menuFrame = CGRectMake(100, 100, 140, 200);
    verticalMenu.imgList = @[@"ranking_China",@"ranking_China",@"ranking_China"];
    verticalMenu.titleList = @[@"1",@"12",@"123",@"1234",@"12345",@"123456"];
    verticalMenu.backgroundColor = [UIColor grayColor];
    [verticalMenu showMenuBarToView:self.view];
}

#pragma mark - Delegate

- (void)popMenuBar:(YFVerticalPopMenuBar *)popMenuBar didSelectItemAtIndex:(NSUInteger)index{
    self.titleLabel.text = popMenuBar.titleList[index];
    [popMenuBar hideMenuBar];
}

- (NSDictionary<NSAttributedStringKey,id> *)popMenuBar:(YFVerticalPopMenuBar *)popMenuBar attributesForIndex:(NSUInteger)index{
    return self.attributesArray[index];
}

- (NSString *)popMenuBar:(YFVerticalPopMenuBar *)popMenuBar backgroundImageForIndex:(NSUInteger)index{
    return @"background.jpg";
}

#pragma mark - setter & getter

- (NSArray *)attributesArray{
    if (!_attributesArray) {
        NSDictionary *attri1 = @{NSForegroundColorAttributeName : [UIColor greenColor],NSFontAttributeName : [UIFont systemFontOfSize:17]};
        NSDictionary *attri2 = @{NSForegroundColorAttributeName : [UIColor redColor],NSFontAttributeName : [UIFont systemFontOfSize:22]};
        NSDictionary *attri3 = @{NSForegroundColorAttributeName : [UIColor purpleColor],NSFontAttributeName : [UIFont systemFontOfSize:10]};;
        
        _attributesArray = [NSArray arrayWithObjects:attri1,attri2,attri3,attri1,attri3,attri2, nil];
    }
    return _attributesArray;
}

@end
