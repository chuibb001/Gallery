//
//  QQPimImagePickerViewController.m
//  YYGridView
//
//  Created by yan simon on 13-11-5.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYImagePickerViewController.h"
#import "YYImageListViewController.h"

@interface YYImagePickerViewController ()

@property (nonatomic,strong) YYImageListViewController *imageListController;
@end

@implementation YYImagePickerViewController

- (id)init
{
    self.imageListController = [[YYImageListViewController alloc] init];
    self = [super initWithRootViewController:self.imageListController];
    if (self) {
        
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
