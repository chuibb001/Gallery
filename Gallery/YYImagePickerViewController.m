//
//  QQPimImagePickerViewController.m
//  YYGridView
//
//  Created by yan simon on 13-11-5.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYImagePickerViewController.h"
#import "YYImageGridViewController.h"
#import "YYImageGroupsViewController.h"

@interface YYImagePickerViewController ()

@property (nonatomic,strong) YYImageGroupsViewController *groupViewController;
@property (nonatomic,strong) YYImageGridViewController *imageListController;

@end

@implementation YYImagePickerViewController

- (id)init
{
    self.groupViewController = [[YYImageGroupsViewController alloc] init];
    self = [super initWithRootViewController:self.groupViewController];
    if (self) {
        self.navigationController.navigationBar.translucent = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark init Method


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
