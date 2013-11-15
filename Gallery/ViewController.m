//
//  ViewController.m
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "ViewController.h"
#import "YYImagePickerViewController.h"

@interface ViewController ()

@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int totalCount;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(10, 100, 300, 44);
        [self.button setTitle:@"选取图片" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button];
        self.listData = [[NSMutableArray alloc] init];
    
//    GalleryView *g = [[GalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) delegate:self];
//    g.delegate = self;
//    self.listData = [[NSMutableArray alloc] init];
//    for (int i = 1; i<=5; i++) {
//        [self.listData addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
//    }
//    g.currentIndex = 4;
//    [self.view addSubview:g];
//    self.totalCount = [self.listData count];
//    self.currentIndex = 0;
}

- (NSInteger)numberOfItemsInGallery
{
    return 5;
}
- (UIImage *)nextItemInGalleryView:(YYGalleryView *)galleryView
{
    if (self.currentIndex < 4) {
        self.currentIndex ++;
        return self.listData[self.currentIndex];
    }
    return nil;
}
- (UIImage *)previousItemInGalleryView:(YYGalleryView *)galleryView
{
    if (self.currentIndex > 0) {
        self.currentIndex --;
        return self.listData[self.currentIndex];
    }
    return nil;
}
- (UIImage *)GalleryView:(YYGalleryView *)galleryView itemAtIndex:(NSInteger)index
{
    if (index >= 0 && index < 5) {
        return self.listData[index];
    }
    return nil;
}
- (UIImage *)GalleryView:(YYGalleryView *)galleryView previousItemAtIndex:(NSInteger)index
{
    return nil;
}
- (void)buttonClicked:(id)sender {
    [self.listData removeAllObjects];
    YYImagePickerViewController *picker = [[YYImagePickerViewController alloc] init];
    picker.imagePickerDelegate = self;
    // photos
    [self loadImageFromPhotoLibrary];
    picker.images = self.listData;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)printALAssetInfo:(ALAsset*)asset
{
    //取图片的url
    //NSString *photoURL=[NSString stringWithFormat:@"%@",asset.defaultRepresentation.url];
    //NSLog(@"photoURL:%@", photoURL);
    // 取图片
    //UIImage* photo = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    //NSLog(@"PHOTO:%@", photo);
    //NSLog(@"photoSize:%@", NSStringFromCGSize(photo.size));
    // 取图片缩图图
    UIImage* photoThumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    NSLog(@"%@", asset.defaultRepresentation.url);
    //NSLog(@"photoSize2:%@", NSStringFromCGSize(photoThumbnail.size));
    NSURL *url = asset.defaultRepresentation.url;
    
    
    YYGridDataModel *dataModel = [[YYGridDataModel alloc] init];
    dataModel.image = photoThumbnail;
    dataModel.assetsURL = url;
    [self.listData addObject:dataModel];
}

-(void)loadImageFromPhotoLibrary
{
    // 为了防止界面卡住，可以异步执行
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    // 获取相册每个组里的具体照片
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result!=nil) {
            // 检查是否是照片，还可能是视频或其它的
            // 所以这里我们还能类举出枚举视频的方法。。。
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [self printALAssetInfo:result];
            }
        }
    };
    //获取相册的组
    ALAssetsLibraryGroupsEnumerationResultsBlock groupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
        if (group!=nil) {
            NSString *groupInfo=[NSString stringWithFormat:@"%@",group];
            NSLog(@"GROUP INFO:%@",groupInfo);
            
            [group enumerateAssetsUsingBlock:groupEnumerAtion];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
        // 相册访问失败的回调，可以打印一下失败原因
        NSLog(@"相册访问失败，ERROR:%@", [error localizedDescription]);
    };
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:groupsEnumeration
                         failureBlock:failureblock];
}

// 同上面的原理，我们再做一个根据URL取图片及缩略图的方法
- (void)loadImageForURL:(NSURL*)photoUrl
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:photoUrl
                  resultBlock:^(ALAsset *asset)
     {
         [self printALAssetInfo:asset];
     }
                 failureBlock:^(NSError *error)
     {
         NSLog(@"error=%@",error);
     }];
}

-(void)imagePickerController:(YYImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images {
    NSLog(@"%@",images);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
