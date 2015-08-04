//
//  HDCategoryCell.m
//  HDCategoryDemo
//
//  Created by 李远超 on 15/8/4.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "HDCategoryCell.h"

@implementation HDCategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    self.selected = YES;
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.contentView) {
        self.contentView.frame = self.bounds;
    } else {
        if (self.imageView.image) {
            CGSize size = self.imageView.image.size;
            self.imageView.frame = CGRectMake(self.imageEdgeInsets.left, (CGRectGetHeight(self.frame) - size.height) / 2, size.width, size.height);

            self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + self.textEdgeInsets.left, 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.imageView.frame) - self.textEdgeInsets.left - self.textEdgeInsets.right, CGRectGetHeight(self.frame));
        } else {
            self.textLabel.frame = CGRectMake(self.textEdgeInsets.left, 0, CGRectGetWidth(self.frame) - self.textEdgeInsets.left - self.textEdgeInsets.right, CGRectGetHeight(self.frame));
        }
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.imageView.highlighted = _selected;
    self.textLabel.highlighted = _selected;
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    self.imageView.highlighted = _highlighted;
    self.textLabel.highlighted = _highlighted;
}

#pragma mark - Setters

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    [self addSubview:_contentView];
    _contentView.frame = self.bounds;
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
