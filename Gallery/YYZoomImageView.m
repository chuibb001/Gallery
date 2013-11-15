//
//  ZoomImageView.m
//  YYGridView
//
//  Created by yan simon on 13-11-15.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYZoomImageView.h"

@implementation YYZoomImageView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;

		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];
        
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.maximumZoomScale = 2.0;
        self.bounces = YES;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)setup
{
    
}
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}

- (void)resetNomalScale
{
    [self setZoomScale:self.minimumZoomScale animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}


@end
