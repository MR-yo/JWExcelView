# JWExcelView

`Lightwight` `UITableView style`

![Demo](http://owlvwomsh.bkt.clouddn.com/jwexcel.gif)

# Usage
---
```
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
    return 30;
}

// row width, default = 60
- (CGFloat)jwExcelView:(JWExcelView *)jwExcelView widthOfRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
```

# Installation
---

### CocoaPods
1. Add `pod 'JWExcelView'` to your Podfile.
2. Run `pod install` or pod update.
3. Import `<JWExcelView/JWExcelView.h>`.

### Manually
1. Download all the files in the JWExcelView subdirectory.
2. Add the source files to your Xcode project.
3. Import `JWExcelView.h`.


