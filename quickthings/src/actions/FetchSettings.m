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
        
        [settings addObject: [NSNumber numberWithInteger:5]];
        [settings addObject: [NSNumber numberWithInteger:2]];
        [settings addObject: [NSNumber numberWithInteger:1]];
        [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*2]];
        [settings addObject:@"Todoist"];
        [settings addObject:@"Done"];
    }
    //~~do~~ dont it anyway for now
//    settings = [[NSMutableArray alloc] init];
//
//    [settings addObject: [NSNumber numberWithInteger:5]];
//    [settings addObject: [NSNumber numberWithInteger:2]];
//    [settings addObject: [NSNumber numberWithInteger:1]];
//    [settings addObject: [[NSDate date] dateByAddingTimeInterval:60*2]];
//    [settings addObject:@"Todoist"];
//    [settings addObject:@"Done"];
//    [settings addObject:@"Complete"];
//    [settings addObject:@"Cancel"];
//    [settings addObject:@"Snooz"];
//    [settings addObject:@"Repeat"];
    
    return settings;
}

@end
