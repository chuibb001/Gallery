//
//  YYImageGroupsViewController.h
//  Gallery
//
//  Created by yan simon on 13-11-18.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAssetsManager.h"
#import "YYImageGridViewController.h"

@interface YYImageGroupsDataModel : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) ALAssetsGroup *assetsGroup;

@end

@interface YYImageGroupsTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *thumbnailImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *countLabel;

- (void)setupWithDataModel:(YYImageGroupsDataModel *)dataModel;
- (void)setupWithAssetsGroup:(ALAssetsGroup *)group;

@end

@interface YYImageGroupsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) UITableView *groupsTableView;

@end
