//
//  HDTableView.m
//  HDTableDemo
//
//  Created by 李远超 on 15/7/24.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "HDTableView.h"

#define HDTableCellTag 8888
#define HDTableHeaderTag 6666
#define HDTableFooterTag 5555

#define HDIndexPathFromNSIndexPath(indexPath) [HDIndexPath indexPathForColumn:indexPath.row inSection:indexPath.section]
#define NSIndexPathFromHDIndexPath(indexPath) [NSIndexPath indexPathForRow:indexPath.column inSection:indexPath.section]

static NSString *CellForReuseIdentifier = @"CellForReuseIdentifier";
static NSString *HeaderForReuseIdentifier = @"HeaderForReuseIdentifier";
static NSString *FooterForReuseIdentifier = @"FooterForReuseIdentifier";

@implementation HDTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:frame style:style];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];

        _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);

        [self addSubview:self.tableView];

        [self initProperty];
    }
    return self;
}

- (void)initProperty {
    self.widthForColumn = 150;
    self.widthForHeader = 0;
    self.widthForFooter = 0;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)scrollToColumnAtIndexPath:(HDIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:NSIndexPathFromHDIndexPath(indexPath) atScrollPosition:scrollPosition animated:animated];
}

- (void)selectColumnAtIndexPath:(HDIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    [self.tableView selectRowAtIndexPath:NSIndexPathFromHDIndexPath(indexPath) animated:animated scrollPosition:scrollPosition];
    HDTableCell *cell = (HDTableCell *)[((UITableViewCell *)[self.tableView cellForRowAtIndexPath:NSIndexPathFromHDIndexPath(indexPath)]).contentView viewWithTag:HDTableCellTag];
    cell.selected = YES;
}

- (void)deselectColumnAtIndexPath:(HDIndexPath *)indexPath animated:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:NSIndexPathFromHDIndexPath(indexPath) animated:animated];
    HDTableCell *cell = (HDTableCell *)[((UITableViewCell *)[self.tableView cellForRowAtIndexPath:NSIndexPathFromHDIndexPath(indexPath)]).contentView viewWithTag:HDTableCellTag];
    cell.selected = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSectionsInTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfColumnsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellForReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellForReuseIdentifier];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = self.selectionStyle;
    }
    UIView *contentView = [self cellForColumnAtIndexPath:HDIndexPathFromNSIndexPath(indexPath) reuseableCell:(HDTableCell *)[cell.contentView viewWithTag:HDTableCellTag]];
    contentView.tag = HDTableCellTag;
    [cell.contentView addSubview:contentView];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self widthForColumnAtIndexPath:HDIndexPathFromNSIndexPath(indexPath)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self widthForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self widthForFooterInSection:section];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [cell.contentView viewWithTag:HDTableCellTag];
    view.frame = CGRectMake(0, CGRectGetWidth(cell.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(cell.frame), CGRectGetHeight(self.frame));
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UIView *contentView = [((UITableViewHeaderFooterView *)view).contentView viewWithTag:HDTableHeaderTag];
    contentView.frame = CGRectMake(0, CGRectGetWidth(view.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(view.frame), CGRectGetHeight(self.frame));
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UIView *contentView = [((UITableViewHeaderFooterView *)view).contentView viewWithTag:HDTableFooterTag];
    contentView.frame = CGRectMake(0, CGRectGetWidth(view.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(view.frame), CGRectGetHeight(self.frame));
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HDTableCell *hdCell = (HDTableCell *)[cell.contentView viewWithTag:HDTableCellTag];
    hdCell.highlighted = YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HDTableCell *hdCell = (HDTableCell *)[cell.contentView viewWithTag:HDTableCellTag];
    hdCell.highlighted = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HDTableCell *hdCell = (HDTableCell *)[cell.contentView viewWithTag:HDTableCellTag];
    hdCell.selected = YES;

    if ([self.delegate respondsToSelector:@selector(tableView:didSelectColumnAtIndexPath:)]) {
        [self.delegate tableView:self didSelectColumnAtIndexPath:HDIndexPathFromNSIndexPath(indexPath)];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HDTableCell *hdCell = (HDTableCell *)[cell.contentView viewWithTag:HDTableCellTag];
    hdCell.selected = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderForReuseIdentifier];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderForReuseIdentifier];
        header.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        header.contentView.backgroundColor = [UIColor clearColor];
    }
    UIView *contentView = [self viewForHeaderInSection:section reuseableHeader:[header.contentView viewWithTag:HDTableHeaderTag]];
    contentView.tag = HDTableHeaderTag;
    [header.contentView addSubview:contentView];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FooterForReuseIdentifier];
    if (footer == nil) {
        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:FooterForReuseIdentifier];
        footer.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        footer.contentView.backgroundColor = [UIColor clearColor];
    }
    UIView *contentView = [self viewForFooterInSection:section reuseableFooter:[footer.contentView viewWithTag:HDTableFooterTag]];
    contentView.tag = HDTableFooterTag;
    [footer.contentView addSubview:contentView];
    return footer;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(tableView:scrollToIndexPath:)]) {
        [self.delegate tableView:self scrollToIndexPath:HDIndexPathFromNSIndexPath([self.tableView indexPathForRowAtPoint:scrollView.contentOffset])];
    }
}

#pragma mark - HDTableViewDataSource - safe

- (NSInteger)numberOfSectionsInTableView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSource numberOfSectionsInTableView:self];
    }
    return 1;
}

- (NSInteger)numberOfColumnsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(tableView:numberOfColumnsInSection:)]) {
        return [self.dataSource tableView:self numberOfColumnsInSection:section];
    }
    return 0;
}

- (HDTableCell *)cellForColumnAtIndexPath:(HDIndexPath *)indexPath reuseableCell:(HDTableCell *)cell {
    if ([self.dataSource respondsToSelector:@selector(tableView:cellForColumnAtIndexPath:reuseableCell:)]) {
        return [self.dataSource tableView:self cellForColumnAtIndexPath:indexPath reuseableCell:cell];
    }
    return nil;
}

#pragma mark - HDTableViewDelegate - safe

- (NSInteger)widthForColumnAtIndexPath:(HDIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:widthForColumnAtIndexPath:)]) {
        return [self.delegate tableView:self widthForColumnAtIndexPath:indexPath];
    }
    return self.widthForColumn;
}

- (NSInteger)widthForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:widthForHeaderInSection:)]) {
        return [self.delegate tableView:self widthForHeaderInSection:section];
    }
    return self.widthForHeader;
}

- (NSInteger)widthForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:widthForFooterInSection:)]) {
        return [self.delegate tableView:self widthForFooterInSection:section];
    }
    return self.widthForFooter;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section reuseableHeader:(UIView *)header{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:reuseableHeader:)]) {
        return [self.delegate tableView:self viewForHeaderInSection:section reuseableHeader:header];
    }
    return nil;
}

- (UIView *)viewForFooterInSection:(NSInteger)section reuseableFooter:(UIView *)footer{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:reuseableFooter:)]) {
        return [self.delegate tableView:self viewForFooterInSection:section reuseableFooter:footer];
    }
    return nil;
}

@end
