//
//  JWExcelCell.m
//  JXPT
//
//  Created by 一只皮卡丘 on 2018/6/20.
//  Copyright © 2018年 一只皮卡丘. All rights reserved.
//

#import "JWExcelCell.h"

@implementation JWExcelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithIdentifier:(NSString *)identifier
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.reuseIdentifier = identifier;
    }
    return self;
}

- (void)prepareForReuse
{
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_textLabel) {
        _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

@end
