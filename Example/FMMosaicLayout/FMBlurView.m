//
//  FMBlurView.m
//  FMMosaicLayout
//
//  Created by Julian Villella on 2015-04-01.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "FMBlurView.h"

@interface FMBlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation FMBlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self setClipsToBounds:YES]; // Removes toolbar shadow
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.toolbar];
    [self sendSubviewToBack:self.toolbar];
    
    [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                        toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
        
        [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                        toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
        
        [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                        toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
        
        [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                        toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]
    ]];
}

- (void)setTintColor:(UIColor *)tintColor {
    //    [super setTintColor:tintColor];
    [self.toolbar setBarTintColor:tintColor];
}

@end
