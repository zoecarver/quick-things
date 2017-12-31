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
        
        [settings addObject: [NSNumber numberWithInteger:10]];
        [settings addObject: [NSNumber numberWithInteger:5]];
        [settings addObject: [NSNumber numberWithInteger:2]];
        [settings addObject: [NSNumber numberWithInteger:1]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*1]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*2]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*6]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*12]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*1]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*2]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*3]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*5]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*7*1]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*7*2]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*7*3]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*24*7*4]];
        [settings addObject: [NSNumber numberWithInteger:-10]];
        [settings addObject: [NSNumber numberWithInteger:-15]];
        [settings addObject: [NSNumber numberWithInteger:-30]];
        [settings addObject: [NSNumber numberWithInteger:-45]];

//        [settings addObject:@"Todoist"];
//        [settings addObject:@"Done"];
//        [settings addObject:@"Complete"];
//        [settings addObject:@"Cancel"];
//        [settings addObject:@"Snooz"];
//        [settings addObject:@"Repeat"];
        
        [userDefaults setObject:settings forKey:@"settings"];
        [userDefaults synchronize];
    }
    
    return settings;
}

@end
