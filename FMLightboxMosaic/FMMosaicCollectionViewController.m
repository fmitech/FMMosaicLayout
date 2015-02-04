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

@property (nonatomic, strong) NSArray *stockImages;

@end

@implementation FMMosaicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];

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
    return 7;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arc4random_uniform(11) + 10; // [10, 20]
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FMMosaicCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
    cell.titleLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.item];
    cell.imageView.image = self.stockImages[indexPath.item % self.stockImages.count];
    
//    if (indexPath.section % 2 == 0) {
//        cell.backgroundColor = @[[UIColor orangeColor], [UIColor blueColor]][indexPath.item % 2];
//    } else {
//        cell.backgroundColor = @[[UIColor redColor], [UIColor greenColor]][indexPath.item % 2];
//    }

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
    return 2;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return arc4random_uniform(2) == 0 ? FMMosaicCellSizeSmall : FMMosaicCellSizeBig;
}

#pragma mark - Accessors

- (NSArray *)stockImages {
    if (!_stockImages) {
        _stockImages = @[
            [UIImage imageNamed:@"balcony"],
            [UIImage imageNamed:@"birds"],
            [UIImage imageNamed:@"bridge"],
            [UIImage imageNamed:@"bridge2"],
            [UIImage imageNamed:@"city"],
            [UIImage imageNamed:@"forest"],
            [UIImage imageNamed:@"houses"],
            [UIImage imageNamed:@"mountains"]
        ];
    }
    return _stockImages;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
