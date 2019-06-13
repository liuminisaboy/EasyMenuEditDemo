//
//  MenuCollectionViewCell.m
//  EasyMenuEditDemo
//
//  Created by Sen on 2019/6/13.
//  Copyright © 2019年 easyhud. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
