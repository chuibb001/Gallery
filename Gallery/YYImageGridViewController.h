//
//  QQPimImageListViewController.h
//  YYGridView
//
//  Created by yan simon on 13-11-5.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYGridView.h"
#import "YYGridDataModel.h"
#import "YYAssetsManager.h"
#import "YYImagePreviewViewController.h"

@interface YYImageGridViewController : UIViewController<YYGridViewDelegate,YYGridViewDataSource>

@property (nonatomic, strong) ALAssetsGroup *group;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) YYGridView *gridView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIButton *doneButton;

@end
