//
//  FMLightboxMosaicLayout.m
//  FMLightboxMosaic
//
//  Created by Julian Villella on 2015-01-30.
//  Copyright (c) 2015 Fluid Media. All rights reserved.
//

#import "FMLightboxMosaicLayout.h"
#import <objc/message.h>

static const CGFloat kFMDefaultColumnWidth = 100.0;
static const FMMosaicCellSize kFMDefaultCellSize = FMMosaicCellSizeSmall;

@interface FMLightboxMosaicLayout ()

@property (nonatomic, strong) NSMutableArray *columns;

@end

@implementation FMLightboxMosaicLayout

- (void)prepareLayout {
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGSize)collectionViewContentSize {
    return CGSizeZero;
}

#pragma mark - Helpers

- (CGFloat)columnWidthForSectionAtIndex:(NSInteger)section {
    CGFloat columnWidth = kFMDefaultColumnWidth;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:columnWidthForSectionAtIndex:)]) {
        columnWidth = [self.delegate collectionView:self.collectionView layout:self columnWidthForSectionAtIndex:section];
    }
    return columnWidth;
}

- (FMMosaicCellSize)cellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCellSize cellSize = kFMDefaultCellSize;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:cellSizeForItemAtIndexPath:)]) {
        cellSize = [self.delegate collectionView:self.collectionView layout:self cellSizeForItemAtIndexPath:indexPath];
    }
    return cellSize;
}

@end
