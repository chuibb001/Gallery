//
//  QQPimImagePickerViewController.h
//  YYGridView
//
//  Created by yan simon on 13-11-5.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYImagePickerViewControllerDelegate;

@interface YYImagePickerViewController : UINavigationController

@property (nonatomic ,weak) id<YYImagePickerViewControllerDelegate> imagePickerDelegate;

/**
 *  if the datas are from the outside , pass an array of type GridDataModel
 */
@property (nonatomic ,strong) NSArray *images;

@end

@protocol YYImagePickerViewControllerDelegate <NSObject>

- (void)imagePickerController:(YYImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images;

@end
