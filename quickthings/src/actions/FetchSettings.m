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
        return [[NSMutableArray alloc] init];
    }
    return settings;
}

@end
