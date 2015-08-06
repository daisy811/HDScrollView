//
//  HDCategoryView.h
//  HDCategoryDemo
//
//  Created by 李远超 on 15/8/3.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDIndexPath.h"
#import "HDCategoryCell.h"

@class HDCategoryView;

@protocol HDCategoryViewDelegate <NSObject>

@optional

- (NSInteger)categoryView:(HDCategoryView *)categoryView widthForColumnAtIndexPath:(HDIndexPath *)indexPath;
- (NSInteger)categoryView:(HDCategoryView *)categoryView widthForHeaderInSection:(NSInteger)section;
- (NSInteger)categoryView:(HDCategoryView *)categoryView widthForFooterInSection:(NSInteger)section;
- (NSInteger)categoryView:(HDCategoryView *)categoryView heightForSelectedFlagAtIndexPath:(HDIndexPath *)indexPath;

- (void)categoryView:(HDCategoryView *)categoryView didSelectColumnAtIndexPath:(HDIndexPath *)indexPath;

- (UIView *)categoryView:(HDCategoryView *)categoryView viewForHeaderInSection:(NSInteger)section reuseableHeader:(UIView *)header;
- (UIView *)categoryView:(HDCategoryView *)categoryView viewForFooterInSection:(NSInteger)section reuseableFooter:(UIView *)footer;

- (void)categoryView:(HDCategoryView *)categoryView scrollToIndexPath:(HDIndexPath *)indexPath;

@end

@protocol HDCategoryViewDataSource <NSObject>

@required

- (NSInteger)categoryView:(HDCategoryView *)categoryView numberOfColumnsInSection:(NSInteger)section;

- (HDCategoryCell *)categoryView:(HDCategoryView *)categoryView cellForColumnAtIndexPath:(HDIndexPath *)indexPath reuseableCell:(HDCategoryCell *)cell;

@optional

- (NSInteger)numberOfSectionsInCategoryView:(HDCategoryView *)categoryView;

@end

@interface HDCategoryView : UIView

@property (nonatomic, assign) id<HDCategoryViewDataSource> dataSource;
@property (nonatomic, assign) id<HDCategoryViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIView *selectedFlagView;

@property (nonatomic, assign) NSInteger widthForColumn;
@property (nonatomic, assign) NSInteger widthForHeader;
@property (nonatomic, assign) NSInteger widthForFooter;
@property (nonatomic, assign) NSInteger heightForSelectedFlag;

- (void)reloadData;

- (HDCategoryCell *)cellForColumnAtIndexPath:(HDIndexPath *)indexPath;

- (CGRect)rectForColumnAtIndexPath:(HDIndexPath *)indexPath;

- (void)selectColumnAtIndexPath:(HDIndexPath *)indexPath animated:(BOOL)animated;
- (void)deselectColumnAtIndexPath:(HDIndexPath *)indexPath;

@end
