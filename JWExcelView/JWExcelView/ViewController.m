//
//  ViewController.m
//  JWExcelView
//
//  Created by 一只皮卡丘 on 2018/6/22.
//  Copyright © 2018年 一只皮卡丘. All rights reserved.
//

#import "ViewController.h"
#import "JWExcelView.h"

#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface ViewController () <JWExcelViewDelegate,JWExcelViewDataSourse>

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"表格";
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildMainView];
}

#pragma mark - buildView
- (void)buildMainView
{
    JWExcelView *excelView = [[JWExcelView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    excelView.excelDelegate = self;
    excelView.excelDataSource = self;
    [self.view addSubview:excelView];
}

- (JWExcelCell *)jwExcelView:(JWExcelView *)jwExcelView jwExcelCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    JWExcelCell *cell = [jwExcelView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[JWExcelCell alloc] initWithIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld,%ld",indexPath.section,indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:200/255.0 green:230/255.0 blue:200/255.0 alpha:1.0];
    }
    return cell;
}

// section count, default = 1
- (NSUInteger)numberOfSectionsInExcelView:(JWExcelView *)jwExcelView
{
    return 50;
}

// row count, default = 1
- (NSUInteger)numberOfRowsInExcelView:(JWExcelView *)jwExcelView
{
    return 50;
}

// section height, default = 30
- (CGFloat)jwExcelView:(JWExcelView *)jwExcelView heightForSectionsAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// row width, default = 60
- (CGFloat)jwExcelView:(JWExcelView *)jwExcelView widthOfRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - request for data
- (void)getDataFromServer
{
    
}

#pragma mark - operation
- (void)jwExcelView:(JWExcelView *)jwExcelView didSelectItem:(NSIndexPath *)indexPath
{
    
}


@end
