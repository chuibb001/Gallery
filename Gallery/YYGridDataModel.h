//
//  GridDataModel.h
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYGridDataModel : NSObject

@property (nonatomic,assign) int rowIndex;
@property (nonatomic,assign) int columnIndex;
@property (nonatomic,strong) UIImage *image;    // thumbnail image
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) NSURL *assetsURL;  
@end
