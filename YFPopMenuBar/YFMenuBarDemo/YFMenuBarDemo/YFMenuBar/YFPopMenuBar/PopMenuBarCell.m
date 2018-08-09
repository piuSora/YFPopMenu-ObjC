//
//  PopMenuBarCell.m
//   wineindustry
//
//  Created by OS on 2018/6/8.
//  Copyright © 2018年 Nonsense. All rights reserved.
//

#import "PopMenuBarCell.h"

@interface PopMenuBarCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadings;

@end

@implementation PopMenuBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CellModel *)model{
    if ([model.imgName isEqualToString:@""] || !model.imgName) {
        self.iconWidth.constant = 0;
        self.titleLeadings.constant = 0;
    }
    else{
        self.iconWidth.constant = model.imgSize.width;
        self.iconHeight.constant = model.imgSize.height;
        self.titleLeadings.constant = 8;
    }
    self.titleLabel.text = model.title;
    self.titleLabel.textColor = model.titleColor;
    self.icon.image = [UIImage imageNamed:model.imgName];
}


@end
