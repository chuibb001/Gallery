//
//  YYImageGroupsViewController.m
//  Gallery
//
//  Created by yan simon on 13-11-18.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYImageGroupsViewController.h"

@implementation YYImageGroupsDataModel
@end

@implementation YYImageGroupsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.thumbnailImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, 150, 20)];
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self addSubview:self.nameLabel];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 18, 100, 20)];
        [self.countLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.countLabel setTextColor:[UIColor grayColor]];
        [self addSubview:self.countLabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setupWithDataModel:(YYImageGroupsDataModel *)dataModel
{
    self.thumbnailImageView.image = dataModel.image;
    self.nameLabel.text = dataModel.name;
    self.countLabel.text = [NSString stringWithFormat:@"(%d)",dataModel.count];
    
}

- (void)setupWithAssetsGroup:(ALAssetsGroup *)group
{
    self.thumbnailImageView.image = [UIImage imageWithCGImage:group.posterImage];
    self.nameLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    self.countLabel.text = [NSString stringWithFormat:@"(%d)",group.numberOfAssets];
}

@end

@interface YYImageGroupsViewController ()

@end

@implementation YYImageGroupsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupTableView];
    [self setupData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //YYImageGroupsDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    ALAssetsGroup *group = [self.listData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"YYImageGroupsTableViewCell";
    
    YYImageGroupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YYImageGroupsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setupWithAssetsGroup:group];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.groupsTableView deselectRowAtIndexPath:indexPath animated:YES];
    YYImageGridViewController *grid = [[YYImageGridViewController alloc] init];
    grid.group = [self.listData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:grid animated:YES];
}

#pragma mark setup
- (void)setupData
{
    self.listData = [[NSMutableArray alloc] init];
    [[YYAssetsManager sharedInstance] allAssetsGroupsWithCompletionHandler:^(NSArray *groups){
        if (groups && [groups count] > 0) {
            for (ALAssetsGroup *group in groups) {
                YYImageGroupsDataModel *dataModel = [[YYImageGroupsDataModel alloc] init];
                dataModel.image = [UIImage imageWithCGImage:group.posterImage];
                dataModel.name = [group valueForProperty:ALAssetsGroupPropertyName];
                dataModel.count = group.numberOfAssets;
                dataModel.assetsGroup = group;
                [self.listData addObject:group];
            }
            [self.groupsTableView reloadData];
        }
    }];
    
}

- (void)setupTableView
{
    self.groupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.groupsTableView.delegate = self;
    self.groupsTableView.dataSource = self;
    [self.view addSubview:self.groupsTableView];
}
@end
