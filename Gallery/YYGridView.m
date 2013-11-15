//
//  YYGridView.m
//  YYGridView
//
//  Created by yan simon on 13-11-4.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYGridView.h"

@interface YYGridView ()

@property (nonatomic, strong) YYGridViewCell *currentReusableCell;

@end

@implementation YYGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark Public Method
- (YYGridViewCell *)dequeueReusableYYGridViewCell
{
	YYGridViewCell* temp = self.currentReusableCell;
	self.currentReusableCell = nil;
	return temp;
}

- (NSInteger)numberOfColumns {
    return  [self.YYGridViewDataSource numberOfColumnsInYYGridView:self];
}

- (NSInteger)numberOfCells {
    return [self.YYGridViewDataSource numberOfCellsInYYGridView:self];
}

- (YYGridViewCell *)cellForRowIndex:(int)rowIndex columnIndex:(int)columnIndex {
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
    YYGridViewCell *gridCell = (YYGridViewCell *)[cell.contentView.subviews objectAtIndex:columnIndex];
    return gridCell;
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.YYGridViewDataSource numberOfCellsInYYGridView:self];
    int column = [self.YYGridViewDataSource numberOfColumnsInYYGridView:self];
    int row = count / column;
    int last = count % column;
    if (last > 0) {
        last = 1;
    }
	return row + last;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.YYGridViewDataSource YYGridView:self heightForRowAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"YYGridViewRowCellIdentifier";
	
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	int count = [self.YYGridViewDataSource numberOfCellsInYYGridView:self];
    int column = [self.YYGridViewDataSource numberOfColumnsInYYGridView:self];
	
	CGFloat x = 0.0;
	CGFloat height = [self.YYGridViewDataSource YYGridView:self heightForRowAtIndex:indexPath.row];
	CGFloat width = self.frame.size.width / column;
    
	for (int i = 0;i < column;i++) {
		
		if ((i + indexPath.row * column) >= count) {
			
            // hide the invisible cell in the last row
			if ([cell.contentView.subviews count] > i) {
				((UITableViewCell *)[cell.contentView.subviews objectAtIndex:i]).hidden = YES;
			}
			
			continue;
		}
		
		if ([cell.contentView.subviews count] > i) {
            // the cell can be reusable,just change its outlook
			self.currentReusableCell = [cell.contentView.subviews objectAtIndex:i];
		} else {
            // no reusable cell,let the datasource alloc one
			self.currentReusableCell = nil;
		}
		
		YYGridViewCell *gridCell = [self.YYGridViewDataSource YYGridView:self cellForRowIndex:indexPath.row columnIndex:i];
		
		if (gridCell.superview != cell.contentView) {
			[cell removeFromSuperview];
			[cell.contentView addSubview:gridCell];
            // add tap gesture
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [gridCell addGestureRecognizer:tap];
            // add button action
            [gridCell.radioButton addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		gridCell.hidden = NO;
		gridCell.dataModel.rowIndex = indexPath.row;
		gridCell.dataModel.columnIndex = i;
		
        
		gridCell.frame = CGRectMake(x, 0, width, height);
        [gridCell layoutSubviews];
		x += width;
	}
	
    return cell;
}

-(void)handleTap:(UITapGestureRecognizer *)sender {
    
    YYGridViewCell *cell = (YYGridViewCell *)sender.view;
    
    // responde to the delegate
    if (self.YYGridViewDelegate && [self.YYGridViewDelegate respondsToSelector:@selector(YYGridView:didSelectCellAtRowIndex:columnIndex:)]) {
        [self.YYGridViewDelegate YYGridView:self didSelectCellAtRowIndex:cell.dataModel.rowIndex columnIndex:cell.dataModel.columnIndex];
    }
}

- (void)radioButtonClicked:(id)sender {
    
    // change the state of the radio button
    UIButton *button = (UIButton *)sender;
    YYGridDataModel *dataModel = ((YYGridViewCell *)button.superview).dataModel;
    dataModel.isSelected = !dataModel.isSelected;
    [((YYGridViewCell *)[self cellForRowIndex:dataModel.rowIndex columnIndex:dataModel.columnIndex]) setCellSelected:dataModel.isSelected];
    
    // responde to the delegate
    if (self.YYGridViewDelegate && [self.YYGridViewDelegate respondsToSelector:@selector(YYGridView:didClickRadioButtonAtRowIndex:columnIndex:)]) {
        [self.YYGridViewDelegate YYGridView:self didClickRadioButtonAtRowIndex:dataModel.rowIndex columnIndex:dataModel.columnIndex];
    }
    
}
@end
