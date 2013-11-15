//
//  ZoomImageView.h
//  YYGridView
//
//  Created by yan simon on 13-11-15.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYZoomImageView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

- (void)setImage:(UIImage *)image;
- (void)resetNomalScale;

@end
