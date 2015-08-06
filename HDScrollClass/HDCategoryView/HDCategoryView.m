//
//  HDCategoryView.m
//  HDCategoryDemo
//
//  Created by 李远超 on 15/8/3.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "HDCategoryView.h"

@interface HDCategoryView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *headerViewArray;
@property (nonatomic, strong) NSMutableArray *cellViewArray;
@property (nonatomic, strong) NSMutableArray *footerViewArray;

@property (nonatomic, strong) HDIndexPath *selectedIndexPath;

@end

@implementation HDCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;

        [self addSubview:self.scrollView];

        _selectedFlagView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedFlagView.backgroundColor = [UIColor purpleColor];

        [self.scrollView addSubview:self.selectedFlagView];

        [self initProperty];
    }
    return self;
}

- (void)initProperty {
    self.widthForColumn = 150;
    self.widthForHeader = 0;
    self.widthForFooter = 0;
    self.heightForSelectedFlag = 0;

    self.headerViewArray = [NSMutableArray array];
    self.cellViewArray = [NSMutableArray array];
    self.footerViewArray = [NSMutableArray array];

    self.selectedIndexPath = HDIndexPathZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;

    [self.headerViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        CGRect rect = view.frame;
        rect.size.height = CGRectGetHeight(self.frame);
        view.frame = rect;
    }];

    [self.cellViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *array = obj;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = obj;
            CGRect rect = view.frame;
            rect.size.height = CGRectGetHeight(self.frame);
            view.frame = rect;
        }];
    }];

    [self.footerViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        CGRect rect = view.frame;
        rect.size.height = CGRectGetHeight(self.frame);
        view.frame = rect;
    }];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, CGRectGetHeight(self.frame));

    [self layoutSelectedFlagViewWithAnimated:NO];
}

- (void)layoutSelectedFlagViewWithAnimated:(BOOL)animated {
    if (self.selectedIndexPath) {
        HDCategoryCell *cell = [self cellForColumnAtIndexPath:self.selectedIndexPath];
        cell.selected = YES;
        CGRect rect = cell.frame;
        [UIView animateWithDuration:animated ? 0.5 : 0 animations:^{
            NSInteger height = [self heightForSelectedFlagAtIndexPath:self.selectedIndexPath];
            self.selectedFlagView.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetHeight(rect) - height, CGRectGetWidth(rect), height);
        }];
    }
}

- (void)reloadData {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    [self.headerViewArray removeAllObjects];
    [self.cellViewArray removeAllObjects];
    [self.footerViewArray removeAllObjects];

    NSInteger x = 0;
    for (int i = 0; i < [self numberOfSections]; i++) {
        UIView *headerView = [self viewForHeaderInSection:i reuseableHeader:nil];
        NSInteger headerWidth = [self widthForHeaderInSection:i];
        if (headerView && headerWidth > 0) {
            [self.headerViewArray addObject:headerView];
            [self.scrollView addSubview:headerView];
            headerView.frame = CGRectMake(x, 0, headerWidth, CGRectGetHeight(self.scrollView.bounds));
            x += headerWidth;
        }
        NSMutableArray *cellViewArray = [NSMutableArray array];
        for (int j = 0; j < [self numberOfColumnsInSection:i]; j++) {
            HDIndexPath *indexPath = [HDIndexPath indexPathForColumn:j inSection:i];
            HDCategoryCell *cellView = [self cellForColumnAtIndexPath:indexPath reuseableCell:nil];
            NSInteger cellWidth = [self widthForColumnAtIndexPath:indexPath];
            if (cellView && cellWidth > 0) {
                [cellViewArray addObject:cellView];
                [self.scrollView addSubview:cellView];
                cellView.didSelectBlock = ^ (HDCategoryCell *cell) {
                    [self resetCellStatus];
                    cell.selected = YES;
                    self.selectedIndexPath = indexPath;
                    if ([self.delegate respondsToSelector:@selector(categoryView:didSelectColumnAtIndexPath:)]) {
                        [self.delegate categoryView:self didSelectColumnAtIndexPath:indexPath];
                    }
                    [self layoutSelectedFlagViewWithAnimated:YES];
                };
                cellView.frame = CGRectMake(x, 0, cellWidth, CGRectGetHeight(self.scrollView.bounds));
                x += cellWidth;
            }
        }
        [self.cellViewArray addObject:cellViewArray];
        UIView *footerView = [self viewForFooterInSection:i reuseableFooter:nil];
        NSInteger footerWidth = [self widthForFooterInSection:i];
        if (footerView && footerWidth > 0) {
            [self.footerViewArray addObject:footerView];
            [self.scrollView addSubview:footerView];
            footerView.frame = CGRectMake(x, 0, footerWidth, CGRectGetHeight(self.scrollView.bounds));
            x += footerWidth;
        }
    }
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.bounds));

    [self.scrollView addSubview:self.selectedFlagView];
}

- (void)resetCellStatus {
    [self.cellViewArray enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        [array enumerateObjectsUsingBlock:^(HDCategoryCell *cell, NSUInteger idx, BOOL *stop) {
            cell.highlighted = NO;
            cell.selected = NO;
        }];
    }];
}

- (HDCategoryCell *)cellForColumnAtIndexPath:(HDIndexPath *)indexPath {
    if (self.cellViewArray.count > indexPath.section) {
        NSMutableArray *array = self.cellViewArray[indexPath.section];
        if (array.count > indexPath.column) {
            HDCategoryCell *cell = array[indexPath.column];
            return cell;
        }
    }
    return nil;
}

- (CGRect)rectForColumnAtIndexPath:(HDIndexPath *)indexPath {
    HDCategoryCell *cell = [self cellForColumnAtIndexPath:indexPath];
    return cell.frame;
}

- (void)selectColumnAtIndexPath:(HDIndexPath *)indexPath animated:(BOOL)animated {
    if (self.selectedIndexPath) {
        HDCategoryCell *cell = [self cellForColumnAtIndexPath:self.selectedIndexPath];
        cell.highlighted = NO;
        cell.selected = NO;
    }
    HDCategoryCell *cell = [self cellForColumnAtIndexPath:indexPath];
    cell.selected = YES;
    self.selectedIndexPath = indexPath;
    [self.scrollView scrollRectToVisible:cell.frame animated:YES];
    [self layoutSelectedFlagViewWithAnimated:animated];
}

- (void)deselectColumnAtIndexPath:(HDIndexPath *)indexPath {
    HDCategoryCell *cell = [self cellForColumnAtIndexPath:indexPath];
    cell.selected = NO;
}

#pragma mark - HDCategoryViewDataSource - safe

- (NSInteger)numberOfColumnsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(categoryView:numberOfColumnsInSection:)]) {
        return [self.dataSource categoryView:self numberOfColumnsInSection:section];
    }
    return 0;
}

- (HDCategoryCell *)cellForColumnAtIndexPath:(HDIndexPath *)indexPath reuseableCell:(HDCategoryCell *)cell {
    if ([self.dataSource respondsToSelector:@selector(categoryView:cellForColumnAtIndexPath:reuseableCell:)]) {
        return [self.dataSource categoryView:self cellForColumnAtIndexPath:indexPath reuseableCell:cell];
    }
    return nil;
}

- (NSInteger)numberOfSections {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCategoryView:)]) {
        return [self.dataSource numberOfSectionsInCategoryView:self];
    }
    return 1;
}

#pragma mark - HDCategoryViewDelegate - safe

- (NSInteger)widthForColumnAtIndexPath:(HDIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(categoryView:widthForColumnAtIndexPath:)]) {
        return [self.delegate categoryView:self widthForColumnAtIndexPath:indexPath];
    }
    return self.widthForColumn;
}

- (NSInteger)widthForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(categoryView:viewForHeaderInSection:reuseableHeader:)]) {
        return [self.delegate categoryView:self widthForHeaderInSection:section];
    }
    return self.widthForHeader;
}

- (NSInteger)widthForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(categoryView:widthForFooterInSection:)]) {
        return [self.delegate categoryView:self widthForFooterInSection:section];
    }
    return self.widthForFooter;
}

- (NSInteger)heightForSelectedFlagAtIndexPath:(HDIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(categoryView:heightForSelectedFlagAtIndexPath:)]) {
        return [self.delegate categoryView:self heightForSelectedFlagAtIndexPath:indexPath];
    }
    return self.heightForSelectedFlag;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section reuseableHeader:(UIView *)header {
    if ([self.delegate respondsToSelector:@selector(categoryView:viewForHeaderInSection:reuseableHeader:)]) {
        return [self.delegate categoryView:self viewForHeaderInSection:section reuseableHeader:header];
    }
    return nil;
}

- (UIView *)viewForFooterInSection:(NSInteger)section reuseableFooter:(UIView *)footer {
    if ([self.delegate respondsToSelector:@selector(categoryView:viewForFooterInSection:reuseableFooter:)]) {
        return [self.delegate categoryView:self viewForFooterInSection:section reuseableFooter:footer];
    }
    return nil;
}

@end
