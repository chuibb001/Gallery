//
//  YYImagePreviewViewController.m
//  Gallery
//
//  Created by yan simon on 13-11-18.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYImagePreviewViewController.h"

@interface YYImagePreviewViewController ()

@property (nonatomic,strong) NSMutableDictionary *imageCaches;
@property (nonatomic,assign) BOOL isShowingNavigationBar;

@end

@implementation YYImagePreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
    [self setupGalleryView];
    [self setupToolBar];
    [self setupNavigationBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;  // fuck!
    self.view.backgroundColor = [UIColor blackColor];
    self.imageCaches = [[NSMutableDictionary alloc] init];
    self.isShowingNavigationBar = YES;
    
    // single tap
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}
- (UIImage *)loadImageAtIndex:(NSInteger)index
{
    YYGridDataModel *dataModel = [self.listData objectAtIndex:index];
    //NSString *url = dataModel.asset.defaultRepresentation.url.absoluteString;
    //UIImage *image = self.imageCaches[url];
    UIImage *image = [UIImage imageWithCGImage:dataModel.asset.defaultRepresentation.fullResolutionImage];
    //self.imageCaches[url] = image;
    return image;
}

#pragma mark YYGalleryViewDelegate
- (void)GalleryView:(YYGalleryView *)galleryView itemAtIndex:(NSInteger)index
{
    if (index >= 0 && index < [self.listData count]) {
        // load the image in subthread
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIImage *image = [self loadImageAtIndex:index];
            //[self loadImageAtIndex:index + 1];
            //[self loadImageAtIndex:index - 1];
            dispatch_async(dispatch_get_main_queue(),^{
                [self.galleryView setImage:image atIndex:index];
                //NSLog(@"%@",self.imageCaches);
            });
        });
    }
}
-(void)GalleryView:(YYGalleryView *)galleryView didScrollToIndex:(NSInteger)index
{
    self.currentIndex = index;
    BOOL isOn = ((YYGridDataModel *)self.listData[index]).isSelected;
    [self setRadioButtonOn:isOn];
}

- (NSInteger)numberOfItemsInGallery
{
    return [self.listData count];
}

#pragma mark private
- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    [self.navigationController setNavigationBarHidden:self.isShowingNavigationBar animated:NO];
    [self.toolBar setHidden:self.isShowingNavigationBar];
    self.isShowingNavigationBar = !self.isShowingNavigationBar;
}
- (void)radioButtonClicked:(id)sender
{
    
    // change the state of the radio button
    YYGridDataModel *dataModel = self.listData[self.currentIndex];
    dataModel.isSelected = !dataModel.isSelected;
    [self setRadioButtonOn:dataModel.isSelected];
}
- (void)doneButtonItemClicked:(id)sender
{
    
}

#pragma mark setup
- (void)setupGalleryView
{
    self.galleryView = [[YYGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + kContentViewPadding, self.view.frame.size.height) delegate:self];
    self.galleryView.currentIndex = self.currentIndex;
    
    [self.view addSubview:self.galleryView];
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

- (void)setupNavigationBar {
    self.title = @"Photos";
    //UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonItemClicked:)];
    self.radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.radioButton.frame = CGRectMake(0, 0, 50, 50);
    BOOL isOn = ((YYGridDataModel *)self.listData[self.currentIndex]).isSelected;
    [self setRadioButtonOn:isOn];
    [self.radioButton addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.radioButton];
    //self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)setRadioButtonOn:(BOOL)isOn
{
    if (isOn) {
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
    } else {
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
