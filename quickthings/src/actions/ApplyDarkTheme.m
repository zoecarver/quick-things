//
//  ApplyDarkTheme.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/28/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "ApplyDarkTheme.h"

@implementation ApplyDarkTheme

- (void)loopThroughViewHierarchy: (UIView *)view {
    view.backgroundColor = [self invertColor:view.backgroundColor];
    
    for (UIView *subview in view.subviews) {
        [self loopThroughViewHierarchy:subview];
    }
}

- (UIColor *) invertColor: (UIColor *)color {
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGFloat newRed = (1.0f - red);
    CGFloat newGreen = (1.0f - green);
    CGFloat newBlue = (1.0f - blue);
    
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];
}

@end
