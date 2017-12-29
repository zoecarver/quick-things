//
//  SortReminders.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/28/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "SortReminders.h"
#import "FetchRembinders.h"
#import "Reminder.h"

@implementation SortReminders

- (NSMutableArray *) sort {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
    
    if (currentReminders.count < 1) {
        NSLog(@"Under 1");
        currentReminders = [[NSMutableArray alloc] init];
    }
    
    NSArray *sorted = [currentReminders sortedArrayUsingFunction:dateSort context:nil];
    
    NSMutableArray *newReminders = [[NSMutableArray alloc] init];
    for (Reminder *notArchivedReminder in sorted) {
        [newReminders addObject:[NSKeyedArchiver archivedDataWithRootObject:notArchivedReminder]];
    }
    
    [userDefaults setObject:newReminders forKey:@"reminders"];
    [userDefaults synchronize];
    
    return [NSMutableArray arrayWithArray:sorted];
}

NSComparisonResult dateSort(Reminder *s1, Reminder *s2, void *context) {
    NSDate *d1 = [s1 date];
    NSDate *d2 = [s2 date];
    return [d1 compare:d2];
}

@end
