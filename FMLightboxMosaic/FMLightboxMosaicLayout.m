//
//  FMLightboxMosaicLayout.m
//  FMLightboxMosaic
//
//  Created by Julian Villella on 2015-01-30.
//  Copyright (c) 2015 Fluid Media. All rights reserved.
//

#import "FMLightboxMosaicLayout.h"
#import <objc/message.h>

static const NSInteger kFMDefaultNumberOfColumnsInSection = 2;
static const FMMosaicCellSize kFMDefaultCellSize = FMMosaicCellSizeSmall;

@interface FMLightboxMosaicLayout ()

/**
 *  A 2D array holding an array of columns heights for each section
 */
@property (nonatomic, strong) NSMutableArray *columnHeightsInSection;
@property (nonatomic, strong) NSMutableDictionary *layoutAttributes;

@end

@implementation FMLightboxMosaicLayout

- (void)prepareLayout {
    for (NSInteger sectionIndex = 0; sectionIndex < [self.collectionView numberOfSections]; sectionIndex++) {
        
        CGFloat interitemSpacing = [self interitemSpacingAtSection:sectionIndex];
        NSMutableArray *smallMosaicCellIndexPathsBuffer = [[NSMutableArray alloc] initWithCapacity:2];
        
        for (NSInteger cellIndex = 0; cellIndex < [self.collectionView numberOfItemsInSection:sectionIndex]; cellIndex++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex];
            
            NSInteger indexOfShortestColumn = [self indexOfShortestColumnInSection:sectionIndex];
            FMMosaicCellSize mosaicCellSize = [self mosaicCellSizeForItemAtIndexPath:cellIndexPath];

            if (mosaicCellSize == FMMosaicCellSizeBig) {
                UICollectionViewLayoutAttributes *layoutAttributes = [self addBigMosaicLayoutAttributesForIndexPath:cellIndexPath inColumn:indexOfShortestColumn];
                CGFloat columnHeight = [self.columnHeightsInSection[sectionIndex][indexOfShortestColumn] floatValue];
                self.columnHeightsInSection[sectionIndex][indexOfShortestColumn] = @(columnHeight + layoutAttributes.frame.size.height + interitemSpacing);
                
            } else if(mosaicCellSize == FMMosaicCellSizeSmall) {
                [smallMosaicCellIndexPathsBuffer addObject:cellIndexPath];
                if(smallMosaicCellIndexPathsBuffer.count >= 2) {
                    // We only need one small mosaic cell layout attribute because they have the same origin.y and size.height
                    UICollectionViewLayoutAttributes *layoutAttributes = [self addSmallMosaicLayoutAttributesForIndexPath:smallMosaicCellIndexPathsBuffer[0]
                                                            inColumn:indexOfShortestColumn bufferIndex:0];
                    [self addSmallMosaicLayoutAttributesForIndexPath:smallMosaicCellIndexPathsBuffer[1] inColumn:indexOfShortestColumn bufferIndex:1];
                    
                    CGFloat columnHeight = [self.columnHeightsInSection[sectionIndex][indexOfShortestColumn] floatValue];
                    self.columnHeightsInSection[sectionIndex][indexOfShortestColumn] = @(columnHeight + layoutAttributes.frame.size.height + interitemSpacing);
                    [smallMosaicCellIndexPathsBuffer removeAllObjects];
                }
            }
        }
        
        // Handle odd number of small mosaic cells
        if (smallMosaicCellIndexPathsBuffer.count > 0) {
            NSInteger indexOfShortestColumn = [self indexOfShortestColumnInSection:sectionIndex];
            UICollectionViewLayoutAttributes *layoutAttributes = [self addSmallMosaicLayoutAttributesForIndexPath:smallMosaicCellIndexPathsBuffer[0]
                                                                                                         inColumn:indexOfShortestColumn bufferIndex:0];
            CGFloat columnHeight = [self.columnHeightsInSection[sectionIndex][indexOfShortestColumn] floatValue];
            self.columnHeightsInSection[sectionIndex][indexOfShortestColumn] = @(columnHeight + layoutAttributes.frame.size.height + interitemSpacing);
            [smallMosaicCellIndexPathsBuffer removeAllObjects];
        }
        
        // Add bottom section insets, and remove extra added inset
        UIEdgeInsets sectionInset = [self insetForSectionAtIndex:sectionIndex];
        NSArray *columnHeights = self.columnHeightsInSection[sectionIndex];
        for (NSInteger i = 0; i < columnHeights.count; i++) {
            CGFloat columnHeight = [columnHeights[i] floatValue];
            self.columnHeightsInSection[sectionIndex][i] = @(columnHeight + sectionInset.bottom - interitemSpacing);
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesInRect = [[NSMutableArray alloc] initWithCapacity:self.layoutAttributes.count];
    
    [self.layoutAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if(CGRectIntersectsRect(rect, attributes.frame)){
            [attributesInRect addObject:attributes];
        }
    }];
    
    return attributesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.layoutAttributes objectForKey:indexPath];
}

- (CGSize)collectionViewContentSize {
    CGFloat width = [self collectionViewContentWidth];
    __block CGFloat height = 0.0;
    
    [self.columnHeightsInSection enumerateObjectsUsingBlock:^(NSArray *columnHeights, NSUInteger sectionIndex, BOOL *stop) {
        NSInteger indexOfTallestColumn = [self indexOfTallestColumnInSection:sectionIndex];
        height += [columnHeights[indexOfTallestColumn] floatValue];
    }];
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionViewContentWidth {
    return self.collectionView.bounds.size.width;
}

#pragma mark - Accessors

- (NSArray *)columnHeightsInSection {
    if (!_columnHeightsInSection) {
        NSInteger sectionCount = [self.collectionView numberOfSections];
        _columnHeightsInSection = [[NSMutableArray alloc] initWithCapacity:sectionCount];
        
        for (NSInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
            NSInteger numberOfColumnsInSection = [self numberOfColumnsInSection:sectionIndex];
            NSMutableArray *columnHeights = [[NSMutableArray alloc] initWithCapacity:numberOfColumnsInSection];
            for (NSInteger columnIndex = 0; columnIndex < numberOfColumnsInSection; columnIndex++) {
                UIEdgeInsets sectionInsets = [self insetForSectionAtIndex:sectionIndex];
                [columnHeights addObject:@(sectionInsets.top)];
            }
            
            [_columnHeightsInSection addObject:columnHeights];
        }
    }
    
    return _columnHeightsInSection;
}

- (NSMutableDictionary *)layoutAttributes {
    if (!_layoutAttributes) {
        _layoutAttributes = [[NSMutableDictionary alloc] init];
    }
    
    return _layoutAttributes;
}

#pragma mark - Helpers

#pragma mark Layout Attributes Helpers

// Returns layout attributes after it has been calculated
- (UICollectionViewLayoutAttributes *)addSmallMosaicLayoutAttributesForIndexPath:(NSIndexPath *)cellIndexPath inColumn:(NSInteger)column bufferIndex:(NSInteger)bufferIndex {
#warning Refactor with addBigMosaicLayoutAttributesForIndexPath:inColumn
    NSInteger sectionIndex = cellIndexPath.section;
    
    CGFloat cellHeight = [self cellHeightForMosaicSize:FMMosaicCellSizeSmall section:sectionIndex];
    CGFloat cellWidth = cellHeight;
    CGFloat columnHeight = [self.columnHeightsInSection[sectionIndex][column] floatValue];
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
    CGFloat originX = column * [self columnWidthInSection:sectionIndex];
    CGFloat originY = [self verticalOffsetForSection:sectionIndex] + columnHeight;
    
    // Factor in interitem spacing and insets
    UIEdgeInsets sectionInset = [self insetForSectionAtIndex:sectionIndex];
    CGFloat interitemSpacing = [self interitemSpacingAtSection:sectionIndex];
    originX += sectionInset.left;
    originX += column * interitemSpacing;
    originX += (cellWidth + interitemSpacing) * bufferIndex; // Account for first or second small mosaic cell
    
    layoutAttributes.frame = CGRectMake(originX, originY, cellWidth, cellHeight);
    [self.layoutAttributes setObject:layoutAttributes forKey:cellIndexPath];
    
    return layoutAttributes;
}

// Returns layout attributes after it has been calculated
- (UICollectionViewLayoutAttributes *)addBigMosaicLayoutAttributesForIndexPath:(NSIndexPath *)cellIndexPath inColumn:(NSInteger)column {
#warning Refactor with addSmallMosaicLayoutAttributesForIndexPath:inColumn:bufferIndex
    NSInteger sectionIndex = cellIndexPath.section;
    
    CGFloat cellHeight = [self cellHeightForMosaicSize:FMMosaicCellSizeBig section:sectionIndex];
    CGFloat cellWidth = cellHeight;
    CGFloat columnHeight = [self.columnHeightsInSection[sectionIndex][column] floatValue];
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
    CGFloat originX = column * [self columnWidthInSection:sectionIndex];
    CGFloat originY = [self verticalOffsetForSection:sectionIndex] + columnHeight;
    
    // Factor in interitem spacing and insets
    UIEdgeInsets sectionInset = [self insetForSectionAtIndex:sectionIndex];
    CGFloat interitemSpacing = [self interitemSpacingAtSection:sectionIndex];
    originX += sectionInset.left;
    originX += column * interitemSpacing;
    
    layoutAttributes.frame = CGRectMake(originX, originY, cellWidth, cellHeight);
    [self.layoutAttributes setObject:layoutAttributes forKey:cellIndexPath];
    
    return layoutAttributes;
}

#pragma mark Sizing Helpers

- (CGFloat)cellHeightForMosaicSize:(FMMosaicCellSize)mosaicCellSize section:(NSInteger)section {
    CGFloat bigCellSize = [self columnWidthInSection:section];
    CGFloat interitemSpacing = [self interitemSpacingAtSection:section];
    return mosaicCellSize == FMMosaicCellSizeBig ? bigCellSize : (bigCellSize - interitemSpacing) / 2.0;
}

- (CGFloat)verticalOffsetForSection:(NSInteger)section {
    CGFloat verticalOffset = 0.0;
    
    for (NSInteger i = 0; i < section; i++) {
        NSInteger indexOfTallestColumn = [self indexOfTallestColumnInSection:i];
        CGFloat sectionHeight = [self.columnHeightsInSection[i][indexOfTallestColumn] floatValue];
        verticalOffset += sectionHeight;
    }
    
    return verticalOffset;
}

- (CGFloat)columnWidthInSection:(NSInteger)section {
    UIEdgeInsets sectionInset = [self insetForSectionAtIndex:section];
    CGFloat combinedInteritemSpacing = ([self numberOfColumnsInSection:section] - 1) * [self interitemSpacingAtSection:section];
    CGFloat combinedColumnWidth = [self collectionViewContentWidth] - sectionInset.left - sectionInset.right - combinedInteritemSpacing;
    
    return combinedColumnWidth / [self numberOfColumnsInSection:section];
}

#pragma mark Index Helpers

- (NSInteger)indexOfShortestColumnInSection:(NSInteger)section {
    NSArray *columnHeights = [self.columnHeightsInSection objectAtIndex:section];

    NSInteger indexOfShortestColumn = 0;
    for (int i = 1; i < columnHeights.count; i++) {
        if([columnHeights[i] floatValue] < [columnHeights[indexOfShortestColumn] floatValue])
            indexOfShortestColumn = i;
    }
    
    return indexOfShortestColumn;
}

- (NSInteger)indexOfTallestColumnInSection:(NSInteger)section {
    NSArray *columnHeights = [self.columnHeightsInSection objectAtIndex:section];
    
    NSInteger indexOfTallestColumn = 0;
    for (int i = 1; i < columnHeights.count; i++) {
        if([columnHeights[i] floatValue] > [columnHeights[indexOfTallestColumn] floatValue])
            indexOfTallestColumn = i;
    }
    
    return indexOfTallestColumn;
}

#pragma mark - Delegate Wrappers

- (NSInteger)numberOfColumnsInSection:(NSInteger)section {
    NSInteger columnCount = kFMDefaultNumberOfColumnsInSection;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:numberOfColumnsInSection:)]) {
        columnCount = [self.delegate collectionView:self.collectionView layout:self numberOfColumnsInSection:section];
    }
    return columnCount;
}

- (FMMosaicCellSize)mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCellSize cellSize = kFMDefaultCellSize;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:mosaicCellSizeForItemAtIndexPath:)]) {
        cellSize = [self.delegate collectionView:self.collectionView layout:self mosaicCellSizeForItemAtIndexPath:indexPath];
    }
    return cellSize;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        inset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return inset;
}

- (CGFloat)interitemSpacingAtSection:(NSInteger)section {
    CGFloat interitemSpacing = 0.0;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:interitemSpacingForSectionAtIndex:)]) {
        interitemSpacing = [self.delegate collectionView:self.collectionView layout:self interitemSpacingForSectionAtIndex:section];
    }
    
    return interitemSpacing;
}

@end
