//
//  UICollectionViewDemoViewController.m
//  JWExcelView
//
//  Created by 一只皮卡丘 on 2018/7/4.
//  Copyright © 2018年 一只皮卡丘. All rights reserved.
//

#import "UICollectionViewDemoViewController.h"

#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface UICollectionViewDemoViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static NSString *collectionCellId = @"cellid";

@implementation UICollectionViewDemoViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"UICollectionView";
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildMainView];
}

#pragma mark - buildView
- (void)buildMainView
{
    CGSize realSize = CGSizeMake(50 * 60, 50 * 30);

    // draw scrollView
    // use ScrollView does not seem to reuse UICollectionViewCell
    // not use ScrollView can not realize the effect I want
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    scrollView.contentSize = realSize;
    [self.view addSubview:scrollView];
    
    // draw collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // only one direction ?
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, realSize.width, realSize.height) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentSize = realSize;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellId];
    [scrollView addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 50;
}

static int count = 0;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
        NSLog(@"not reuse");
    }else{
        count ++;
        NSLog(@"reuse %d",count);
    }
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(60, 30);
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - request for data
- (void)getDataFromServer
{
    
}

#pragma mark - operation
- (void)doSomethings
{
    
}


@end
