//
//  HDIndexPath.m
//  HDTableDemo
//
//  Created by 李远超 on 15/7/30.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "HDIndexPath.h"

@implementation HDIndexPath

+ (HDIndexPath *)indexPathForColumn:(NSInteger)column inSection:(NSInteger)section {
    HDIndexPath *indexPath = [[HDIndexPath alloc] init];
    indexPath.column = column;
    indexPath.section = section;
    return indexPath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"column: %@, section: %@", [NSNumber numberWithInteger:self.column], [NSNumber numberWithInteger:self.section]];
}

@end
