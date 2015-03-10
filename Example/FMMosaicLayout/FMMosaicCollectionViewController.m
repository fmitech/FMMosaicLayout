//
//  FMMosaicCollectionViewController.m
//  FMLightboxMosaic
//
//  Created by Julian Villella on 2015-01-30.
//  Copyright (c) 2015 Fluid Media. All rights reserved.
//

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
    return 62;
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
            [UIImage imageNamed:@"balcony"],
            [UIImage imageNamed:@"birds"],
            [UIImage imageNamed:@"bridge"],
            [UIImage imageNamed:@"city"],
            [UIImage imageNamed:@"mountains"],
            [UIImage imageNamed:@"ceiling"],
            [UIImage imageNamed:@"game"],
            [UIImage imageNamed:@"leaves"],
            [UIImage imageNamed:@"stream"],
            [UIImage imageNamed:@"sunset"]
        ];
    }
    return _stockImages;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
