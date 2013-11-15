//
//  YYGridViewCell.m
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYGridViewCell.h"

@implementation YYGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
        self.radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
        [self addSubview:self.radioButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
    self.radioButton.frame = CGRectMake(self.frame.size.width - 25, 5, 20, 20);
}

- (void)setupData:(YYGridDataModel *)dataModel {
    self.dataModel = dataModel;
    self.imageView.image = dataModel.image;
    [self setCellSelected:dataModel.isSelected];
}

- (void)setCellSelected:(BOOL)selected {
    if (selected) {
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
        [UIView beginAnimations:@"scale" context:nil];
        [UIView setAnimationDuration:0.1];
        CGAffineTransform newTransform =  CGAffineTransformScale(self.radioButton.transform, 2, 2);
        [self.radioButton setTransform:newTransform];
        [UIView commitAnimations];
    } else {
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
    }
}
@end
