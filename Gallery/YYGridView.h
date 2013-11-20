//
//  YYGridView.h
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYGridViewCell.h"

@protocol YYGridViewDelegate;

@protocol YYGridViewDataSource;

@interface YYGridView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<YYGridViewDelegate> gridViewDelegate;

@property (nonatomic, weak) id<YYGridViewDataSource> gridViewDataSource;

/**
 *  return a reusable cell
 */
- (YYGridViewCell *)dequeueReusableYYGridViewCell;

/**
 *  return the number of columns
 */
- (NSInteger)numberOfColumns;

/**
 *  return the number of total cells
 */
- (NSInteger)numberOfCells;

/**
 *  return the cell at specified row & column
 */
- (YYGridViewCell *)cellForRowIndex:(int)rowIndex columnIndex:(int)columnIndex;

@end


@protocol YYGridViewDelegate <NSObject>
/**
 *  select the cell
 */
- (void)YYGridView:(YYGridView *)YYGridView didSelectCellAtRowIndex:(int)rowIndex columnIndex:(int)columnIndex;

/**
 *  click the radio button in a cell
 */
- (void)YYGridView:(YYGridView *)YYGridView didClickRadioButtonAtRowIndex:(int)rowIndex columnIndex:(int)columnIndex;

@end

@protocol YYGridViewDataSource <NSObject>

@required

/**
 *  ask for the height of every row
 */
- (CGFloat)YYGridView:(YYGridView *)YYGridView heightForRowAtIndex:(int)rowIndex;

/**
 *  ask for the number of columns at every row
 */
- (NSInteger)numberOfColumnsInYYGridView:(YYGridView *)YYGridView;

/**
 *  ask for the number of total cells , then the number of rows can be calculated
 */
- (NSInteger)numberOfCellsInYYGridView:(YYGridView *)YYGridView;

/**
 *  ask for the cell at specified row & column
 */
- (YYGridViewCell *)YYGridView:(YYGridView *)YYGridView cellForRowIndex:(int)rowIndex columnIndex:(int)columnIndex;

@end
