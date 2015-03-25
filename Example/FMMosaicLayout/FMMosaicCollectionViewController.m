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
#import "FMMosaicCollectionViewCell.h"
#import "FMMosaicLayout.h"

static const NSInteger kFMMosaicColumnCount = 2;

@interface FMMosaicCollectionViewController () <FMMosaicLayoutDelegate>

@property (nonatomic, strong) NSArray *stockImages;

@end

@implementation FMMosaicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 123;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
        [FMMosaicCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
    cell.titleLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.item];
    cell.imageView.image = self.stockImages[indexPath.item % self.stockImages.count];
    
    return cell;
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
