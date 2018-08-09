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

- (IBAction)action:(UIButton *)sender {
    YFVerticalPopMenuBar *verticalMenu = [[YFVerticalPopMenuBar alloc] initWithTitleList:@[@"123",@"345",@"987654321"] imageList:nil showPosition:CGPointMake(sender.frame.origin.x - 100, sender.center.y + sender.frame.size.height)];
    verticalMenu.imgList = @[@"ranking_China",@"ranking_China",@"ranking_China"];
    verticalMenu.titleColor = [UIColor purpleColor];
    verticalMenu.titleList = @[@"1",@"12",@"123",@"1234",@"12345",@"123456"];
    verticalMenu.delegate = self;
    [verticalMenu showMenuBarToView:self.view];
}


@end
