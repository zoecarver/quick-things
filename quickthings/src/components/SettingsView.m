//
//  SettingsView.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/26/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

- (void)commonInit {
    self.layer.zPosition = 20;
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowRadius:5.0f];
    [self.layer setShadowOffset:CGSizeMake(0 , 0)];
    [self.layer setShadowOpacity:0.3f];
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
