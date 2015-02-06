//
//  FMLightboxMosaicLayout.h
//  FMLightboxMosaic
//
//  Created by Julian Villella on 2015-01-30.
//  Copyright (c) 2015 Fluid Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMLightboxMosaicLayout;

typedef NS_ENUM(NSUInteger, FMMosaicCellSize) {
    FMMosaicCellSizeSmall,
    FMMosaicCellSizeBig
};

@protocol FMMosaicLayoutDelegate <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section;

@optional
- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

@end

@interface FMLightboxMosaicLayout : UICollectionViewLayout

@property (nonatomic, weak) id<FMMosaicLayoutDelegate> delegate;

@end
