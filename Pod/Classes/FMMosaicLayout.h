//
//  FMMosaicLayout.h
//  FMMosaicLayout
//
//  Created by Julian Villella on 2015-01-30.
//  Copyright (c) 2015 Fluid Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMMosaicLayout;

typedef NS_ENUM(NSUInteger, FMMosaicCellSize) {
    FMMosaicCellSizeSmall,
    FMMosaicCellSizeBig
};

@protocol FMMosaicLayoutDelegate <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section;

@optional
- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

@end

@interface FMMosaicLayout : UICollectionViewLayout

// Not used, just for backwards compatability
@property (nonatomic, weak) id<FMMosaicLayoutDelegate> delegate;

@end
