//
//  HDTableView.h
//  HDTableDemo
//
//  Created by 李远超 on 15/7/24.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTableCell.h"
#import "HDIndexPath.h"

@class HDTableView;

@protocol HDTableViewDataSource <NSObject>

@required

- (NSInteger)tableView:(HDTableView *)tableView numberOfColumnsInSection:(NSInteger)section;

- (HDTableCell *)tableView:(HDTableView *)tableView cellForColumnAtIndexPath:(HDIndexPath *)indexPath reuseableCell:(HDTableCell *)cell;

@optional

- (NSInteger)numberOfSectionsInTableView:(HDTableView *)tableView;

@end

@protocol HDTableViewDelegate <NSObject>

@optional

- (NSInteger)tableView:(HDTableView *)tableView widthForColumnAtIndexPath:(HDIndexPath *)indexPath;
- (NSInteger)tableView:(HDTableView *)tableView widthForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(HDTableView *)tableView widthForFooterInSection:(NSInteger)section;

- (void)tableView:(HDTableView *)tableView didSelectColumnAtIndexPath:(HDIndexPath *)indexPath;

- (UIView *)tableView:(HDTableView *)tableView viewForHeaderInSection:(NSInteger)section reuseableHeader:(UIView *)header;
- (UIView *)tableView:(HDTableView *)tableView viewForFooterInSection:(NSInteger)section reuseableFooter:(UIView *)footer;

- (void)tableView:(HDTableView *)tableView scrollToIndexPath:(HDIndexPath *)indexPath;

@end

@interface HDTableView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<HDTableViewDataSource> dataSource;
@property (nonatomic, assign) id<HDTableViewDelegate> delegate;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

@property (nonatomic, assign) NSInteger widthForColumn;
@property (nonatomic, assign) NSInteger widthForHeader;
@property (nonatomic, assign) NSInteger widthForFooter;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (void)reloadData;

- (void)scrollToColumnAtIndexPath:(HDIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)selectColumnAtIndexPath:(HDIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectColumnAtIndexPath:(HDIndexPath *)indexPath animated:(BOOL)animated;

@end
