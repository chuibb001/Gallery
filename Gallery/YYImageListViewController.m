//
//  QQPimImageListViewController.m
//  YYGridView
//
//  Created by yan simon on 13-11-5.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYImageListViewController.h"
#import "YYImagePickerViewController.h"

@interface YYImageListViewController ()

@end

@implementation YYImageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupData];
    [self initYYGridView];
    [self initNavigationBar];
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
    //int column = [YYGridView numberOfColumns];
    //int index = rowIndex *column + columnIndex;
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
        for (int i = 0; i < 60; i++) {
            YYGridDataModel *dataModel = [[YYGridDataModel alloc] init];
            [self.listData addObject:dataModel];
        }
    }
}

- (void)initYYGridView {
    self.YYGridView = [[YYGridView alloc] initWithFrame:self.view.frame];
    self.YYGridView.YYGridViewDataSource = self;
    self.YYGridView.YYGridViewDelegate = self;
    [self.view addSubview:self.YYGridView];
}

- (void)initNavigationBar {
    self.title = @"Photos";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonItemClicked:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftBarButtonItemClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonItemClicked:(id)sender {
    YYImagePickerViewController *picker = (YYImagePickerViewController *)self.navigationController;
    if (picker.imagePickerDelegate && [picker.imagePickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingImages:)]) {
        [picker.imagePickerDelegate imagePickerController:picker didFinishPickingImages:[self selectedDataModels]];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
