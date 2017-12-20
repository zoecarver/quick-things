//
//  FetchSettings.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "FetchSettings.h"

@implementation FetchSettings

- (NSMutableArray *) fetchSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    if (userDefaults != nil) {
        settings = [[userDefaults objectForKey:@"settings"] mutableCopy];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    if (settings.count < 1) {
        settings = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 4; i++) {
            [settings addObject: [NSNumber numberWithInteger:5]];
        }
        for (NSInteger i = 0; i < 2; i++) {
            [settings addObject: [NSNumber numberWithInteger:1]];
        }
        for (NSInteger i = 0; i < 3; i++) {
            [settings addObject: [NSNumber numberWithInteger:2]];
        }
        [settings addObject:@"Done"];
    }
    return settings;
}

@end
