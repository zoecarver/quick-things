//
//  FetchSmallUserSettings.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/25/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "FetchSmallUserSettings.h"

@implementation FetchSmallUserSettings

- (NSInteger) fetchDefaultSnooz {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger snooz = 1;
    
    if (userDefaults != nil) {
        if(![[[userDefaults dictionaryRepresentation] allKeys] containsObject:@"defaultsnooz"]){
            [self setDefaultSnooz:5];
        }
        snooz = [userDefaults integerForKey:@"defaultsnooz"];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    
    return snooz;
}

- (void) setDefaultSnooz:(NSInteger ) snooz {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (userDefaults != nil) {
        [userDefaults setInteger:snooz forKey:@"defaultsnooz"];
        [userDefaults synchronize];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
}

- (NSInteger) fetchTheme {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger theme = 1;
    
    if (userDefaults != nil) {
        if(![[[userDefaults dictionaryRepresentation] allKeys] containsObject:@"theme"]){
            [self setTheme:1];
        }
        theme = [userDefaults integerForKey:@"theme"];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    
    return theme;
}

- (void) setTheme:(NSInteger ) theme {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (userDefaults != nil) {
        [userDefaults setInteger:theme forKey:@"theme"];
        [userDefaults synchronize];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
}

- (NSInteger) fetchDoneColor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL done = NO;
    
    if (userDefaults != nil) {
        done = [userDefaults integerForKey:@"donecolor"];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    
    return done;
}

- (void) setDoneColor:(BOOL ) color {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (userDefaults != nil) {
        [userDefaults setBool:color forKey:@"donecolor"];
        [userDefaults synchronize];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
}

- (NSInteger) fetchNumberOfNotificationsToSchedule {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger notificationsNumber = 10;
    
    if (userDefaults != nil) {
        if(![[[userDefaults dictionaryRepresentation] allKeys] containsObject:@"notificationsnumber"]){
            [self setNumberOfNotificationsToSchedule:10];
        }
        notificationsNumber = [userDefaults integerForKey:@"notificationsnumber"];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    
    return notificationsNumber;
}

- (void) setNumberOfNotificationsToSchedule:(NSInteger ) notificationsNumber {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (userDefaults != nil) {
        [userDefaults setInteger:notificationsNumber forKey:@"notificationsnumber"];
        [userDefaults synchronize];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
}



@end
