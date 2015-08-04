//
//  ViewController.m
//  HDScrollDemo
//
//  Created by 李远超 on 15/8/4.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "ViewController.h"
#import "HDCategoryView.h"
#import "HDTableView.h"

@interface ViewController () <HDCategoryViewDataSource, HDCategoryViewDelegate, HDTableViewDataSource, HDTableViewDelegate>

@property (nonatomic, strong) HDCategoryView *categoryView;
@property (nonatomic, strong) HDTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryView = [[HDCategoryView alloc] initWithFrame:CGRectZero];
    self.categoryView.dataSource = self;
    self.categoryView.delegate = self;

    [self.view addSubview:self.categoryView];

    [self.categoryView reloadData];

    self.tableView = [[HDTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.categoryView.frame = CGRectMake(10, 100, CGRectGetWidth(self.view.frame) - 20, 44);

    self.tableView.frame = CGRectMake(10, 300, self.view.frame.size.width - 20, 80);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView scrollToColumnAtIndexPath:[HDIndexPath indexPathForColumn:0 inSection:3] atScrollPosition:0 animated:YES];
    [self.tableView selectColumnAtIndexPath:[HDIndexPath indexPathForColumn:0 inSection:3] animated:YES scrollPosition:0];
}

#pragma mark - HDCategoryViewDataSource

- (NSInteger)numberOfSectionsInCategoryView:(HDCategoryView *)categoryView {
    return 5;
}

- (NSInteger)categoryView:(HDCategoryView *)categoryView numberOfColumnsInSection:(NSInteger)section {
    return 1;
}

- (HDCategoryCell *)categoryView:(HDCategoryView *)categoryView cellForColumnAtIndexPath:(HDIndexPath *)indexPath reuseableCell:(HDCategoryCell *)cell {
    if (cell == nil) {
        cell = [[HDCategoryCell alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:1.0 / (indexPath.column + 1)];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.highlightedTextColor = [UIColor greenColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [indexPath description]];
    return cell;
}

#pragma mark - HDCategoryViewDelegate

- (void)categoryView:(HDCategoryView *)categoryView didSelectColumnAtIndexPath:(HDIndexPath *)indexPath {
    NSLog(@"did select %@", [indexPath description]);
    [categoryView deselectColumnAtIndexPath:indexPath];
}

- (NSInteger)categoryView:(HDCategoryView *)categoryView heightForSelectedFlagAtIndexPath:(HDIndexPath *)indexPath {
    return 2;
}

- (NSInteger)categoryView:(HDCategoryView *)categoryView widthForColumnAtIndexPath:(HDIndexPath *)indexPath {
    return 250;
}

- (NSInteger)categoryView:(HDCategoryView *)categoryView widthForFooterInSection:(NSInteger)section {
    if (section != 4) {
        return 5;
    }
    return 0;
}

- (UIView *)categoryView:(HDCategoryView *)categoryView viewForFooterInSection:(NSInteger)section reuseableFooter:(UIView *)footer {
    if (footer == nil) {
        footer = [[UIView alloc] initWithFrame:CGRectZero];
        footer.backgroundColor = [UIColor yellowColor];
    }
    return footer;
}

#pragma mark - HDTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(HDTableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(HDTableView *)tableView numberOfColumnsInSection:(NSInteger)section {
    return 1;
}

- (HDTableCell *)tableView:(HDTableView *)tableView cellForColumnAtIndexPath:(HDIndexPath *)indexPath reuseableCell:(HDTableCell *)cell {
    if (cell == nil) {
        cell = [[HDTableCell alloc] initWithFrame:CGRectZero];
        cell.textLabel.textColor = [UIColor greenColor];
        cell.textLabel.highlightedTextColor = [UIColor purpleColor];
//        UILabel *view = [[UILabel alloc] init];
//        view.backgroundColor = [UIColor whiteColor];
//        view.textColor = [UIColor greenColor];
//        cell.contentView = view;
    }
    cell.imageView.image = [UIImage imageNamed:@"icon"];
    cell.textLabel.text = [NSString stringWithFormat:@"title - %li", indexPath.section];
//    UILabel *label = (UILabel *)cell.contentView;
//    label.text = [NSString stringWithFormat:@"title - %li", indexPath.section];

    return cell;
}

#pragma mark - HDTableViewDelegate

- (void)tableView:(HDTableView *)tableView didSelectColumnAtIndexPath:(HDIndexPath *)indexPath {
    [tableView deselectColumnAtIndexPath:indexPath animated:YES];
}

//- (NSInteger)tableView:(HDTableView *)tableView widthForHeaderInSection:(NSInteger)section {
//    return 5;
//}

- (NSInteger)tableView:(HDTableView *)tableView widthForFooterInSection:(NSInteger)section {
    if (section != 9) {
        return 5;
    }
    return 0;
}

- (NSInteger)tableView:(HDTableView *)tableView heightForSelectedFlagAtIndexPath:(HDIndexPath *)indexPath {
    return 2;
}

//- (UIView *)tableView:(HDTableView *)tableView viewForHeaderInSection:(NSInteger)section reuseableHeader:(UIView *)header {
//    if (header == nil) {
//        header = [[UIView alloc] initWithFrame:CGRectZero];
//        header.backgroundColor = [UIColor yellowColor];
//    }
//    return header;
//}

- (UIView *)tableView:(HDTableView *)tableView viewForFooterInSection:(NSInteger)section reuseableFooter:(UIView *)footer {
    if (footer == nil) {
        footer = [[UIView alloc] initWithFrame:CGRectZero];
        footer.backgroundColor = [UIColor blueColor];
    }
    return footer;
}

@end
