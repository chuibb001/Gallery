//
//  ViewController.h
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "YYImagePickerViewController.h"
#import "YYGridDataModel.h"
#import "YYGalleryView.h"
@import AssetsLibrary;

@interface ViewController : UIViewController<YYImagePickerViewControllerDelegate,YYGalleryViewDelegate>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSMutableArray *listData;

@end
