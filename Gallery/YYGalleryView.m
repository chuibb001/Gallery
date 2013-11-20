//
//  GalleryView.m
//  YYGridView
//
//  Created by yan simon on 13-11-14.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYGalleryView.h"

#define kViewTagOffset 1000

@interface YYGalleryView ()
{
    NSInteger totalNumber;
    CGFloat width;
    CGFloat height;
    
    // this two variables make sure if the visible area has changed
    NSInteger firstIndex;
    NSInteger lastIndex;
}

@property (nonatomic,strong) NSMutableSet *reusableViewSet;
@property (nonatomic,strong) NSMutableSet *visibleViewSet;

@end

@implementation YYGalleryView

- (id)initWithFrame:(CGRect)frame delegate:(id<YYGalleryViewDelegate>)delegate
{
    self.delegate = delegate;
    totalNumber = [self.delegate numberOfItemsInGallery];
    
    return [self initWithFrame:frame];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        self.scrollView.contentSize = CGSizeMake(frame.size.width * totalNumber, frame.size.height);
        self.scrollView.contentOffset = CGPointMake(frame.size.width * 0, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.bounces = YES;
        self.scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scrollView];
        
        width = frame.size.width;
        height = frame.size.height;
        
        self.reusableViewSet = [[NSMutableSet alloc] init];
        self.visibleViewSet = [[NSMutableSet alloc] init];
    }
    return self;
}
-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    firstIndex = currentIndex;
    lastIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(width * currentIndex , 0);
    [self updateImages];
}

#pragma mark Private
- (CGRect)rectAtIndex:(NSInteger)index
{
    return CGRectMake(width * index, 0, width - kContentViewPadding, height);
}
- (BOOL)shouldUpdateImages
{
    // the visible area relatives to content size
    CGRect visibleRect = self.scrollView.bounds;
    // the index of the first visible view
    NSInteger first = (NSInteger)floorf(CGRectGetMinX(visibleRect)) / width;
    // the index of the last visible view
    NSInteger last = (NSInteger)floorf(CGRectGetMaxX(visibleRect) - 1) / width;
    
    // we should adjust the indexes for the border case
    totalNumber = [self.delegate numberOfItemsInGallery];
    if (first < 0) {
        first = 0;
    }
    if (last < 0) {
        last = 0;
    }
    if (first > totalNumber - 1) {
        first = totalNumber - 1;
    }
    if (last > totalNumber - 1) {
        last = totalNumber - 1;
    }
    
    // continue when the visible area has changed
    if (first != firstIndex || last != lastIndex) {
        firstIndex = first;
        lastIndex = last;
        return YES;
    }
    
    return NO;
}
- (void)updateImages
{
    // reuse the unvisible views
    NSInteger visibleIndex;
    for (YYZoomImageView *v in self.visibleViewSet) {
        visibleIndex = v.tag - kViewTagOffset;
        if (visibleIndex < firstIndex || visibleIndex > lastIndex) {
            [self.reusableViewSet addObject:v];
            [v removeFromSuperview];
        }
    }
    
    [self.visibleViewSet minusSet:self.reusableViewSet];
    
    // the reuse pool can only contain two views
    while ([self.reusableViewSet count] > 2) {
        [self.reusableViewSet removeObject:[self.reusableViewSet anyObject]];
    }
    
    // show image at visible indexes
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isImageShownAtIndex:index]) {
			[self showImageAtIndex:index];
		}
	}
}
- (BOOL)isImageShownAtIndex:(NSInteger)index {
	for (YYZoomImageView *v in self.visibleViewSet) {
		if (v.tag - kViewTagOffset == index) {
            return YES;
        }
    }
	return  NO;
}
- (void)showImageAtIndex:(NSInteger)index
{
    // dequeue from the pool or alloc a new one
    YYZoomImageView *v = [self dequeueReusableView];
    CGRect newRect = [self rectAtIndex:index];
    if (!v) {
        v = [[YYZoomImageView alloc] initWithFrame:newRect];
    }
    for (YYZoomImageView * view in self.visibleViewSet) {
        if (v != view) {
            if (view.zoomScale == view.maximumZoomScale) {
                //[view resetNomalScale];
            }
        }
    }
    
    v.frame = newRect;
    v.tag = kViewTagOffset + index;
    [self.delegate GalleryView:self itemAtIndex:index];
    [v setImage:nil];
    
    [self.scrollView addSubview:v];
    [self.visibleViewSet addObject:v];
}
- (YYZoomImageView *)dequeueReusableView
{
    YYZoomImageView *v = [self.reusableViewSet anyObject];
	if (v) {
		[self.reusableViewSet removeObject:v];
	}
	return v;
}

// when subthread finishes loading the image ,call this method to update displaying
- (void)setImage:(UIImage *)image atIndex:(NSInteger)index
{
    for (YYZoomImageView * view in self.visibleViewSet) {
        if (view.tag == kViewTagOffset + index) {
            [view setImage:image];
        }
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        if ([self shouldUpdateImages]) {
            [self updateImages];
        }
        
        // caculate the current page/index
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (page != _currentIndex) {
            _currentIndex = page;
            if (self.delegate && [self.delegate respondsToSelector:@selector(GalleryView:didScrollToIndex:)]) {
                [self.delegate GalleryView:self didScrollToIndex:page];
            }
        }
        
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
@end
