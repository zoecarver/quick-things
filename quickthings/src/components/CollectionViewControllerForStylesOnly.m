//
//  CollectionViewControllerForStylesOnly.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/27/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CollectionViewControllerForStylesOnly.h"

@interface CollectionViewControllerForStylesOnly ()

@end

@implementation CollectionViewControllerForStylesOnly

- (void)commonInit {
    self.layer.cornerRadius = 25;
}

- (id)initWithFrame:(CGRect)aRect {
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

@end
