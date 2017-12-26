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

- (NSInteger) fetchNumberOfNotificationsToSchedule {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger notificationsNumber = 10;
    
    if (userDefaults != nil) {
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
