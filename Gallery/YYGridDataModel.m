//
//  GridDataModel.m
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYGridDataModel.h"

@implementation YYGridDataModel

- (id)init
{
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:@"Icon.png"];
        self.isSelected = NO;
    }
    return self;
}
@end
