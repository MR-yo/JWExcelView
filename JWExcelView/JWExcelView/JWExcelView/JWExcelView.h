//
//  JWExcelView.h
//  JXPT
//
//  Created by 一只皮卡丘 on 2018/6/19.
//  Copyright © 2018年 一只皮卡丘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWExcelCell.h"

NS_ASSUME_NONNULL_BEGIN

@class JWExcelView;
@protocol JWExcelViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (void)jwExcelView:(JWExcelView *)jwExcelView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol JWExcelViewDataSourse <NSObject>

@required
- (JWExcelCell *)jwExcelView:(JWExcelView *)jwExcelView jwExcelCellForIndexPath:(NSIndexPath *)indexPath;

@optional
// section count, default = 1
- (NSUInteger)numberOfSectionsInExcelView:(JWExcelView *)jwExcelView;

// row count, default = 1
- (NSUInteger)numberOfRowsInExcelView:(JWExcelView *)jwExcelView;

// section height, default = 30
- (CGFloat)jwExcelView:(JWExcelView *)jwExcelView heightForSectionsAtIndexPath:(NSIndexPath *)indexPath;

// row width, default = 60
- (CGFloat)jwExcelView:(JWExcelView *)jwExcelView widthOfRowsAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JWExcelView : UIScrollView

@property (nonatomic, weak) id<JWExcelViewDelegate> excelDelegate;

@property (nonatomic, weak) id<JWExcelViewDataSourse> excelDataSource;

- (instancetype)initWithFrame:(CGRect)frame;

- (JWExcelCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
