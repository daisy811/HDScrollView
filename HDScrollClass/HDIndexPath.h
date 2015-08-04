//
//  HDIndexPath.h
//  HDTableDemo
//
//  Created by 李远超 on 15/7/30.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HDIndexPathZero [HDIndexPath indexPathForColumn:0 inSection:0]

@interface HDIndexPath : NSObject

+ (HDIndexPath *)indexPathForColumn:(NSInteger)column inSection:(NSInteger)section;

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger section;

@end
