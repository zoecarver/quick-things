//
//  SettingsParentView.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/26/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "SettingsParentView.h"
#import "ApplyDarkTheme.h"
#import "SettingsTableViewController.h"

@implementation SettingsParentView {
    ApplyDarkTheme *applyTheme;
}

- (void)commonInit {
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme view:self];
    
    UIView *blur = [[UIView alloc] init];
    
    blur.frame = CGRectMake(0, 0, self.frame.size.width*3, self.frame.size.height*2);
    blur.layer.zPosition = 10;
    blur.backgroundColor = [UIColor blackColor];
    blur.layer.opacity = 0.05f;
    blur.userInteractionEnabled = NO;
    
    [self addSubview:blur];
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
