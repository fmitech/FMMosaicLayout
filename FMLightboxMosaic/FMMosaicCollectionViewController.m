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

static const NSInteger kFMMosaicColumnCount = 2;

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
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FMMosaicCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
    cell.titleLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.item];
    cell.imageView.image = self.stockImages[indexPath.item % self.stockImages.count];
    
    return cell;
}

#pragma mark <FMMosaicLayoutDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section {
    return kFMMosaicColumnCount;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMLightboxMosaicLayout *)collectionViewLayout mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.item % 4 == 0) ? FMMosaicCellSizeBig : FMMosaicCellSizeSmall;
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
