//
//  CellEditView.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/31/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CellEditView.h"
#import "ApplyDarkTheme.h"

@implementation CellEditView {
    ApplyDarkTheme *applyTheme;
}

- (void)commonInit {
    self.layer.zPosition = 20;
    
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowRadius:5.0f];
    [self.layer setShadowOffset:CGSizeMake(0 , 0)];
    [self.layer setShadowOpacity:0.3f];
    
    self.layer.cornerRadius = 25;
    
    NSLog(@"Switched hight from %f to %f", self.frame.size.height * 2, self.frame.size.height);
    
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme view:self];
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
