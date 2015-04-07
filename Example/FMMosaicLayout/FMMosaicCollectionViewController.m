//
// FMMosaicCollectionViewController.m
// FMMosaicLayout
//
// Created by Julian Villella on 2015-01-30.
// Copyright (c) 2015 Fluid Media. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FMMosaicCollectionViewController.h"
#import "FMMosaicCellView.h"
#import "FMMosaicLayout.h"
#import "FMHeaderView.h"
#import "FMFooterView.h"

static const CGFloat kFMHeaderFooterHeight  = 44.0;
static const NSInteger kFMMosaicColumnCount = 2;

@interface FMMosaicCollectionViewController () <FMMosaicLayoutDelegate>

@property (nonatomic, strong) NSArray *stockImages;

@end

@implementation FMMosaicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FMHeaderView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:[FMHeaderView reuseIdentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FMFooterView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:[FMFooterView reuseIdentifier]];
}

- (void)adjustContentInsets {
    UIEdgeInsets insets = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 31;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FMMosaicCellView reuseIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", indexPath.item + 1];
    cell.imageView.image = self.stockImages[indexPath.item % self.stockImages.count];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FMHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                              withReuseIdentifier:[FMHeaderView reuseIdentifier] forIndexPath:indexPath];
        
        headerView.titleLabel.text = [NSString stringWithFormat:@"SECTION %ld", indexPath.section + 1];
        reusableView = headerView;
        
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        FMFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                               withReuseIdentifier:[FMFooterView reuseIdentifier] forIndexPath:indexPath];
        
        NSInteger assetCount = [self collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
        footerView.titleLabel.text = assetCount == 1 ? @"1 ASSET" : [NSString stringWithFormat:@"%ld ASSETS", assetCount];
        reusableView = footerView;
    }
    
    return reusableView;
}

#pragma mark <FMMosaicLayoutDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        numberOfColumnsInSection:(NSInteger)section {
    return kFMMosaicColumnCount;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.item % 12 == 0) ? FMMosaicCellSizeBig : FMMosaicCellSizeSmall;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        interitemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
   heightForHeaderInSection:(NSInteger)section {
    return kFMHeaderFooterHeight;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
   heightForFooterInSection:(NSInteger)section {
    return kFMHeaderFooterHeight;
}

- (BOOL)headerShouldOverlayContentInCollectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout {
    return YES;
}

- (BOOL)footerShouldOverlayContentInCollectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout {
    return YES;
}

#pragma mark - Accessors

- (NSArray *)stockImages {
    if (!_stockImages) {
        _stockImages = @[
            [UIImage imageNamed:@"back"],
            [UIImage imageNamed:@"balcony"],
            [UIImage imageNamed:@"birds"],
            [UIImage imageNamed:@"bridge"],
            [UIImage imageNamed:@"ceiling"],
            [UIImage imageNamed:@"city"],
            [UIImage imageNamed:@"cityscape"],
            [UIImage imageNamed:@"game"],
            [UIImage imageNamed:@"leaves"],
            [UIImage imageNamed:@"mountain-tops"],
            [UIImage imageNamed:@"mountains"],
            [UIImage imageNamed:@"sitting"],
            [UIImage imageNamed:@"snowy-mountains"],
            [UIImage imageNamed:@"stars"],
            [UIImage imageNamed:@"stream"],
            [UIImage imageNamed:@"sunset"],
            [UIImage imageNamed:@"two-birds"],
            [UIImage imageNamed:@"waves"]
        ];
    }
    return _stockImages;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
