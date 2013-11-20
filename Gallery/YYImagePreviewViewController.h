//
//  YYImagePreviewViewController.h
//  Gallery
//
//  Created by yan simon on 13-11-18.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYGalleryView.h"
#import "YYGridDataModel.h"

@interface YYImagePreviewViewController : UIViewController<YYGalleryViewDelegate>

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) YYGalleryView *galleryView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIButton *radioButton;
@property (nonatomic, strong) UIButton *doneButton;

@end
