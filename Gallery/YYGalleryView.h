//
//  GalleryView.h
//  YYGridView
//
//  Created by yan simon on 13-11-14.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYZoomImageView.h"

@protocol YYGalleryViewDelegate;
@interface YYGalleryView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,weak) id<YYGalleryViewDelegate> delegate;
@property (nonatomic,assign) NSInteger currentIndex;

- (id)initWithFrame:(CGRect)frame delegate:(id<YYGalleryViewDelegate>)delegate;

@end

@protocol YYGalleryViewDelegate <NSObject>

@required

- (NSInteger)numberOfItemsInGallery;
- (UIImage *)GalleryView:(YYGalleryView *)galleryView itemAtIndex:(NSInteger)index;
- (UIImage *)nextItemInGalleryView:(YYGalleryView *)galleryView;
- (UIImage *)previousItemInGalleryView:(YYGalleryView *)galleryView;

@end