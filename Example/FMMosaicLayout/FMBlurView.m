//
// FMBlurView.m
// FMMosaicLayout
//
// Created by Julian Villella on 2015-04-01.
// Copyright (c) 2015 JVillella. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
