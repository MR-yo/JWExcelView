//
//  JWExcelCell.h
//  JXPT
//
//  Created by 一只皮卡丘 on 2018/6/20.
//  Copyright © 2018年 一只皮卡丘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWExcelCell : UIView

@property (nonatomic, copy) NSString *reuseIdentifier;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UILabel *textLabel;

- (id)initWithIdentifier:(NSString *)identifier;

- (void)prepareForReuse;

@end
