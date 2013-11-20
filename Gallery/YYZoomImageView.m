//
//  ZoomImageView.m
//  YYGridView
//
//  Created by yan simon on 13-11-15.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYZoomImageView.h"

@interface YYZoomImageView ()

@property(nonatomic, assign) float rate; // width / height

@end

@implementation YYZoomImageView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;

		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];
        
        // setup scrollView
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.maximumZoomScale = 2.0;
        self.zoomScale = 1.0;
        self.bounces = YES;
        self.scrollEnabled = YES;
        
        // double tap
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        
        
        self.rate = self.frame.size.width / self.frame.size.height;
    }
    return self;
}

- (void)setup
{
    
}
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    
    if (!image) {
        return;
    }
    // reset imageView's frame
    if (image.size.width / image.size.height < self.rate) {
        float newHeight = self.imageView.frame.size.width * image.size.height / image.size.width;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, newHeight);
    } else {
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    // er..
    [self setZoomScale:self.minimumZoomScale animated:NO];
    [self setContentOffset:CGPointMake(0, 0)];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
