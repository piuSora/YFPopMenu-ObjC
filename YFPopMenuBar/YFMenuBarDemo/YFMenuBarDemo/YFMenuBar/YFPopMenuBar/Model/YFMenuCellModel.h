//
//  CellModel.h
//   wineindustry
//
//  Created by OS on 2018/6/8.
//  Copyright © 2018年 Nonsense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YFMenuCellModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) CGSize imgSize;
@property (strong, nonatomic) NSString *imgName;
@property (strong, nonatomic) NSString *backgroundImage;
@property (strong, nonatomic) NSDictionary<NSAttributedStringKey, id>*attributes;

@end
