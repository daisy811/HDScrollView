//
//  HDCategoryCell.h
//  HDCategoryDemo
//
//  Created by 李远超 on 15/8/4.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectBlock)(void);

@interface HDCategoryCell : UIView

@property (nonatomic, copy) DidSelectBlock didSelectBlock;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@end
