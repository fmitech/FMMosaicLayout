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

@protocol FMMosaicLayout <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout columnWidthForSectionAtIndex:(NSInteger)section;

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout cellSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FMLightboxMosaicLayout : UICollectionViewLayout

@end
