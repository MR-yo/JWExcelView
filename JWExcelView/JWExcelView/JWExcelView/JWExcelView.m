//
//  JWExcelView.m
//  JXPT
//
//  Created by 一只皮卡丘 on 2018/6/19.
//  Copyright © 2018年 一只皮卡丘. All rights reserved.
//

#import "JWExcelView.h"

@interface JWExcelView ()
{
    NSMutableDictionary *_cachedCells;
    NSMutableSet *_reusableCells;
    NSMutableSet *_newVisibleCells;
    CGPoint _lastContentOffset;
    CGFloat _nextWidth;
    CGFloat _nextHeight;
    BOOL    _needsReload;
 
    struct {
        unsigned jwExcelCellForIndexPath: 1;
        unsigned numberOfSectionsInExcelView : 1;
        unsigned numberOfRowsInExcelView : 1;
        unsigned heightForSectionsAtIndexPath : 1;
        unsigned widthOfRowsAtIndexPath : 1;
    } _dataSourceDefault;
    
    struct {
        unsigned didSelectItemAtIndexPath : 1;
    } _delegateDefault;
}

@end

const CGFloat _defaultSectionHeight = 30;
const CGFloat _defaultRowWidth = 60;

@implementation JWExcelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cachedCells = [[NSMutableDictionary alloc] init];
        _reusableCells = [[NSMutableSet alloc] init];
        _newVisibleCells = [[NSMutableSet alloc] init];
        _lastContentOffset = CGPointZero;
        self.bounces = NO;
    }
    return self;
}

- (void)setExcelDataSource:(id<JWExcelViewDataSourse>)excelDataSource
{
    _excelDataSource = excelDataSource;
    
    _dataSourceDefault.numberOfSectionsInExcelView = [_excelDataSource respondsToSelector:@selector(numberOfSectionsInExcelView:)];
    _dataSourceDefault.numberOfRowsInExcelView = [_excelDataSource respondsToSelector:@selector(numberOfRowsInExcelView:)];
    _dataSourceDefault.heightForSectionsAtIndexPath = [_excelDataSource respondsToSelector:@selector(jwExcelView:heightForSectionsAtIndexPath:)];
    _dataSourceDefault.widthOfRowsAtIndexPath = [_excelDataSource respondsToSelector:@selector(jwExcelView:widthOfRowsAtIndexPath:)];
    _dataSourceDefault.jwExcelCellForIndexPath = [_excelDataSource respondsToSelector:@selector(jwExcelView:jwExcelCellForIndexPath:)];
    
    [self configMainView];
    [self _setNeedsReload];
}

- (void)setExcelDelegate:(id<JWExcelViewDelegate>)excelDelegate
{
    _excelDelegate = excelDelegate;
    
    _delegateDefault.didSelectItemAtIndexPath = [_excelDelegate respondsToSelector:@selector(jwExcelView:didSelectItemAtIndexPath:)];
}

- (void)configMainView
{
    // calculate max section count and max row count
    NSUInteger maxSectionCount = _dataSourceDefault.numberOfSectionsInExcelView ? [self.excelDataSource numberOfSectionsInExcelView:self] : 1;
    NSUInteger maxRowCount = _dataSourceDefault.numberOfRowsInExcelView ? [self.excelDataSource numberOfRowsInExcelView:self] : 1;

    // calculate contentSize
    CGFloat contentSizeW = 0;
    CGFloat contentSizeH = 0;
    if (_dataSourceDefault.heightForSectionsAtIndexPath) {
        for (int i = 0; i < maxSectionCount; i++) {
            contentSizeH += [self.excelDataSource jwExcelView:self heightForSectionsAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        }
    }else{
        contentSizeH = _defaultSectionHeight * maxSectionCount;
    }
    
    if (_dataSourceDefault.widthOfRowsAtIndexPath) {
        for (int i = 0; i < maxRowCount; i++) {
            contentSizeW += [self.excelDataSource jwExcelView:self widthOfRowsAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }else{
        contentSizeW = _defaultRowWidth * maxRowCount;
    }
    
    self.contentSize = CGSizeMake(contentSizeW, contentSizeH);
}

- (void)buildOriginView:(NSIndexPath *)originIndexPath
{
    [self layoutIfNeeded];
    
    // build origin visible cell
    if (_dataSourceDefault.jwExcelCellForIndexPath) {
        
        NSInteger row = originIndexPath.row;
        NSInteger section = originIndexPath.section;
        CGFloat originW = _lastContentOffset.x;
        CGFloat originH = _lastContentOffset.y;
        CGFloat visibleW = MIN(self.frame.size.width, self.contentSize.width) + originW + _nextWidth;
        CGFloat visibleH = MIN(self.frame.size.height, self.contentSize.height) + originH + _nextHeight;
        
        while (originH < visibleH || originW < visibleW) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            CGFloat currentH = 0;
            CGFloat currentW = 0;
            if ([_cachedCells objectForKey:indexPath] == nil) {
                // create cell
                JWExcelCell *cell = [self.excelDataSource jwExcelView:self jwExcelCellForIndexPath:indexPath];
                currentH = _dataSourceDefault.heightForSectionsAtIndexPath ? [self.excelDataSource jwExcelView:self heightForSectionsAtIndexPath:indexPath] : _defaultSectionHeight;
                currentW = _dataSourceDefault.widthOfRowsAtIndexPath ? [self.excelDataSource jwExcelView:self widthOfRowsAtIndexPath:indexPath] : _defaultRowWidth;
                cell.frame = CGRectMake(originW, originH, currentW, currentH);
                cell.indexPath = indexPath;
                [self addSubview:cell];
                // cache cell
                [_cachedCells setObject:cell forKey:indexPath];
            }else{
                JWExcelCell *cell = [_cachedCells objectForKey:indexPath];
                currentH = cell.frame.size.height;
                currentW = cell.frame.size.width;
            }
            
            if (originH + currentH >= visibleH && originW + currentW >= visibleW) {
                break;
            }else{
                if (originH + currentH < visibleH) {
                    originH += currentH;
                    section ++;
                    continue;
                }else{
                    // restart
                    section = originIndexPath.section;
                    originH = _lastContentOffset.y;
                }
                if (originW + currentW < visibleW) {
                    originW += currentW;
                    row ++;
                    continue;
                }else{
                    // restart
                    row = originIndexPath.row;
                    originW = _lastContentOffset.x;
                }
            }
            
        }
    }
}

#pragma mark - get reuseable cell
- (JWExcelCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    for (JWExcelCell *cell in _reusableCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            JWExcelCell *strongCell = cell;
            [_reusableCells removeObject:cell];
            [strongCell prepareForReuse];
            return strongCell;
        }
    }
    return nil;
}

#pragma mark - layout
- (void)layoutSubviews
{
    // visibleBounds need bigger than show view, otherwise, the scroll view will show empty.
    // but I let the item width and height control by delegate, get next item width has a little trouble.
    // after all, this method will call very frequent
    // btw, when frame > visible size , don't draw surplus items
    _nextWidth = 0;
    _nextHeight = 0;
    if (self.frame.size.width < self.contentSize.width) {
        _nextWidth = _dataSourceDefault.widthOfRowsAtIndexPath ? _defaultRowWidth : [self.excelDataSource jwExcelView:self widthOfRowsAtIndexPath:[self getOriginIndexPath:CGPointMake(self.contentOffset.x + self.bounds.size.width, self.contentOffset.y)]];
    }
    if (self.frame.size.height < self.contentSize.height) {
        _nextHeight = _dataSourceDefault.heightForSectionsAtIndexPath ? _defaultSectionHeight : [self.excelDataSource jwExcelView:self heightForSectionsAtIndexPath:[self getOriginIndexPath:CGPointMake(self.contentOffset.x, self.contentOffset.y + self.bounds.size.height)]];
    }
    
    const CGRect visibleBounds = CGRectMake(self.contentOffset.x,self.contentOffset.y,self.bounds.size.width + _nextWidth,self.bounds.size.height + _nextHeight);
    
    // remove cell whitch out of visibleBounds from superview, and put it to _reusableCells if it has reuseIdentifier
    for (JWExcelCell *cell in _cachedCells.allValues) {
        if (!CGRectIntersectsRect(cell.frame,visibleBounds)) {
            if (cell.reuseIdentifier) {
                [_reusableCells addObject:cell];
            }
            [cell removeFromSuperview];
            [_cachedCells removeObjectForKey:cell.indexPath];
        }
    }
    
    // add new cell
    [self buildOriginView:[self getOriginIndexPath:self.contentOffset]];
}

- (NSIndexPath *)getOriginIndexPath:(CGPoint)contentOffset
{
    NSUInteger row = 0;
    NSUInteger section = 0;
    
    CGFloat height = 0;
    if (_dataSourceDefault.heightForSectionsAtIndexPath) {
        while (true) {
            height += [self.excelDataSource jwExcelView:self heightForSectionsAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            if (height > contentOffset.y) {
                height -= [self.excelDataSource jwExcelView:self heightForSectionsAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
                break;
            }else{
                section ++;
            }
        }
    }else{
        section = contentOffset.y / _defaultSectionHeight;
    }

    CGFloat width = 0;
    if (_dataSourceDefault.widthOfRowsAtIndexPath) {
        while (true) {
            width += [self.excelDataSource jwExcelView:self widthOfRowsAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            if (width > contentOffset.x) {
                width -= [self.excelDataSource jwExcelView:self widthOfRowsAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                break;
            }else{
                row ++;
            }
        }
    }else{
        row = contentOffset.x / _defaultRowWidth;
    }
    
    _lastContentOffset = CGPointMake(width, height);
    return [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark - reload
- (void)reloadData
{
    [self configMainView];
    [self _setNeedsReload];
}

- (void)_setNeedsReload
{
    _needsReload = YES;
    [self setNeedsLayout];
}

@end
