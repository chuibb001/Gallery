//
//  YYGridViewCell.h
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYGridDataModel.h"
@import QuartzCore;

@interface YYGridViewCell : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *radioButton;
@property (nonatomic,strong) YYGridDataModel *dataModel;

/**
 *  setup the cell with the given data model
 */
- (void)setupData:(YYGridDataModel *)dataModel;

/**
 *  change the state of the radio button
 */
- (void)setCellSelected:(BOOL)selected;

@end
