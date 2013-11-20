//
//  QQPimImageListViewController.m
//  YYGridView
//
//  Created by yan simon on 13-11-5.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYImageGridViewController.h"
#import "YYImagePickerViewController.h"

@interface YYImageGridViewController ()

@end

@implementation YYImageGridViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupData];
    [self setupGridView];
    [self setupNavigationBar];
    [self setupToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.gridView reloadData];
}

#pragma mark Private Method
- (NSArray *)selectedDataModels {
    if (!self.listData || [self.listData count] == 0) {
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (YYGridDataModel *dataModel in self.listData) {
        if (dataModel.isSelected) {
            [arr addObject:dataModel];
        }
    }
    if ([arr count] == 0) {
        return nil;
    }
    
    return arr;
}

#pragma mark YYGridViewDatasource
- (CGFloat)YYGridView:(YYGridView *)YYGridView heightForRowAtIndex:(int)rowIndex {
    return 80;
}

- (NSInteger)numberOfColumnsInYYGridView:(YYGridView *)YYGridView {
    return 4;
}

- (NSInteger)numberOfCellsInYYGridView:(YYGridView *)YYGridView {
    return [self.listData count];
}

- (YYGridViewCell *)YYGridView:(YYGridView *)YYGridView cellForRowIndex:(int)rowIndex columnIndex:(int)columnIndex {
    YYGridViewCell *cell = (YYGridViewCell *)[YYGridView dequeueReusableYYGridViewCell];
	
	if (cell == nil) {
		cell = [[YYGridViewCell alloc] init];
	}
    
    int column = (int)[YYGridView numberOfColumns];
    int index = rowIndex *column + columnIndex;
    
    YYGridDataModel *dataModel = [self.listData objectAtIndex:index];
    [cell setupData:dataModel];
	return cell;
}

#pragma mark YYGridViewDelegate
-(void)YYGridView:(YYGridView *)YYGridView didSelectCellAtRowIndex:(int)rowIndex columnIndex:(int)columnIndex {
    int column = [YYGridView numberOfColumns];
    int index = rowIndex *column + columnIndex;
    
    YYImagePreviewViewController *preview = [[YYImagePreviewViewController alloc] init];
    preview.listData = self.listData;
    preview.currentIndex = index;
    [self.navigationController pushViewController:preview animated:YES];
}

-(void)YYGridView:(YYGridView *)YYGridView didClickRadioButtonAtRowIndex:(int)rowIndex columnIndex:(int)columnIndex {
    
}

#pragma mark Init Method
- (void)setupData {
    if (((YYImagePickerViewController *)self.navigationController).images) {
        self.listData = (NSMutableArray *)((YYImagePickerViewController *)self.navigationController).images;
    } else {
        // data for test
        self.listData = [[NSMutableArray alloc] init];
        [[YYAssetsManager sharedInstance] allAssetsWithGroup:self.group completionHandler:^(NSArray * allAssets){
            for (ALAsset * asset in allAssets) {
                YYGridDataModel *dataModel = [[YYGridDataModel alloc] init];
                dataModel.image = [UIImage imageWithCGImage:asset.thumbnail];
                dataModel.assetsURL = asset.defaultRepresentation.url;
                dataModel.asset = asset;
                [self.listData addObject:dataModel];
                NSLog(@"%@",[NSValue valueWithCGSize:asset.defaultRepresentation.dimensions]);
            }
            [self.gridView reloadData];
        }];
    }
}

- (void)setupGridView {
    self.gridView = [[YYGridView alloc] initWithFrame:self.view.frame];
    self.gridView.gridViewDataSource = self;
    self.gridView.gridViewDelegate = self;
    [self.view addSubview:self.gridView];
}

- (void)setupNavigationBar {
    self.title = @"Photos";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupToolBar
{
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
    [self.view addSubview:self.toolBar];
    
    //self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom]
    UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonItemClicked:)];
    [self.toolBar setItems:@[emptyItem,item]];
}

#pragma mark private
- (void)leftBarButtonItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClicked:(id)sender {
    YYImagePickerViewController *picker = (YYImagePickerViewController *)self.navigationController;
    if (picker.imagePickerDelegate && [picker.imagePickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingImages:)]) {
        [picker.imagePickerDelegate imagePickerController:picker didFinishPickingImages:[self selectedDataModels]];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)doneButtonItemClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
