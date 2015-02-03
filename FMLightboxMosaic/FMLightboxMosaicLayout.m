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
        
        NSMutableArray *smallMosaicCellIndexPathsBuffer = [[NSMutableArray alloc] initWithCapacity:2];
        for (NSInteger cellIndex = 0; cellIndex < [self.collectionView numberOfItemsInSection:sectionIndex]; cellIndex++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex];
            
            NSInteger indexOfShortestColumn = [self indexOfShortestColumnInSection:sectionIndex];
            FMMosaicCellSize mosaicCellSize = [self mosaicCellSizeForItemAtIndexPath:cellIndexPath];

            if (mosaicCellSize == FMMosaicCellSizeBig) {
                [self addLayoutAttributeForIndexPath:cellIndexPath inColumn:indexOfShortestColumn];
                
            } else if(mosaicCellSize == FMMosaicCellSizeSmall) {
                [smallMosaicCellIndexPathsBuffer addObject:cellIndexPath];
                if(smallMosaicCellIndexPathsBuffer.count >= 2) {
                    [self addLayoutAttributeForIndexPath:smallMosaicCellIndexPathsBuffer[0] inColumn:indexOfShortestColumn];
                    [self addLayoutAttributeForIndexPath:smallMosaicCellIndexPathsBuffer[1] inColumn:indexOfShortestColumn + 1];
                    
                    [smallMosaicCellIndexPathsBuffer removeAllObjects];
                }
            }
        }
        
        // Handle odd number of small mosaic cells
        if (smallMosaicCellIndexPathsBuffer.count > 0) {
            NSInteger indexOfShortestColumn = [self indexOfShortestColumnInSection:sectionIndex];
            [self addLayoutAttributeForIndexPath:smallMosaicCellIndexPathsBuffer[0] inColumn:indexOfShortestColumn];
            [smallMosaicCellIndexPathsBuffer removeAllObjects];
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
#warning Implement me
    return CGSizeMake(self.collectionView.bounds.size.width, 10000.0);
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
                [columnHeights addObject:@0.0];
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

- (void)addLayoutAttributeForIndexPath:(NSIndexPath *)cellIndexPath inColumn:(NSInteger)columnIndex {
    NSInteger sectionIndex = cellIndexPath.section;
    
    CGFloat cellHeight = [self cellHeightForMosaicSize:FMMosaicCellSizeBig section:sectionIndex];
    CGFloat columnHeight = [self.columnHeightsInSection[sectionIndex][columnIndex] floatValue];
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
    CGPoint origin = CGPointMake(columnIndex * [self columnWidthInSection:sectionIndex], columnHeight);
    layoutAttributes.frame = CGRectMake(origin.x, origin.y, cellHeight, cellHeight);
    [self.layoutAttributes setObject:layoutAttributes forKey:cellIndexPath];
    
    self.columnHeightsInSection[sectionIndex][columnIndex] = @(columnHeight + cellHeight);
}

- (CGFloat)cellHeightForMosaicSize:(FMMosaicCellSize)mosaicCellSize section:(NSInteger)section {
    CGFloat bigCellSize = self.collectionViewContentSize.width / [self numberOfColumnsInSection:section];
    return mosaicCellSize == FMMosaicCellSizeBig ? bigCellSize : bigCellSize / 2.0;
}

- (NSInteger)indexOfShortestColumnInSection:(NSInteger)section {
    NSArray *columnHeights = [self.columnHeightsInSection objectAtIndex:section];

    NSInteger indexOfShortestColumn = 0;
    for(int i = 1; i < columnHeights.count; i++) {
        if([columnHeights[i] floatValue] < [columnHeights[indexOfShortestColumn] floatValue])
            indexOfShortestColumn = i;
    }
    
    return indexOfShortestColumn;
}

- (NSInteger)numberOfColumnsInSection:(NSInteger)section {
    NSInteger columnCount = kFMDefaultNumberOfColumnsInSection;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:numberOfColumnsInSection:)]) {
        columnCount = [self.delegate collectionView:self.collectionView layout:self numberOfColumnsInSection:section];
    }
    return columnCount;
}

- (CGFloat)columnWidthInSection:(NSInteger)section {
    return self.collectionViewContentSize.width / [self numberOfColumnsInSection:section];
}

- (FMMosaicCellSize)mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCellSize cellSize = kFMDefaultCellSize;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:mosaicCellSizeForItemAtIndexPath:)]) {
        cellSize = [self.delegate collectionView:self.collectionView layout:self mosaicCellSizeForItemAtIndexPath:indexPath];
    }
    return cellSize;
}

@end
