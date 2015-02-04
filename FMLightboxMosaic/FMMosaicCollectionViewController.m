//
//  FMMosaicCollectionViewController.m
//  FMLightboxMosaic
//
//  Created by Julian Villella on 2015-01-30.
//  Copyright (c) 2015 Fluid Media. All rights reserved.
//

#import "FMMosaicCollectionViewController.h"
#import "FMMosaicCollectionViewCell.h"
#import "FMLightboxMosaicLayout.h"

static const CGFloat kFMStatusBarHeight = 20.0;

@interface FMMosaicCollectionViewController () <FMMosaicLayoutDelegate>

@end

@implementation FMMosaicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor yellowColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(kFMStatusBarHeight, 0.0, 0.0, 0.0);
    
    if([self.collectionViewLayout isKindOfClass:[FMLightboxMosaicLayout class]]) {
        [self.collectionViewLayout performSelector:@selector(setDelegate:) withObject:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FMMosaicCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
    cell.titleLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

#pragma mark <FMMosaicLayoutDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section {
    return 4;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return FMMosaicCellSizeBig;
}

@end
