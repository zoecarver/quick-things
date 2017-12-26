//
//  AddReminder.m
//  quickThings
//
//  Created by Zoe IAMZOE.io on 12/11/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "AddReminder.h"
#import "FetchRembinders.h"
#import "Reminder.h"
#import "FetchSmallUserSettings.h"

@implementation AddReminder

- (void) reminderToAdd:(NSString*) _reminderToAdd {
    NSLog(@"Adding reminder %@", _reminderToAdd);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
    Reminder *reminder = [[Reminder alloc] init];
    
    NSDate *now = [NSDate date];
    
    reminder.title = _reminderToAdd;
    reminder.date = now;
    reminder.notificationKey = @"";
    reminder.snooz = [smallUserSettings fetchDefaultSnooz];
    
    NSLog(@"saving with title %@", reminder.title);
    
    if (currentReminders.count < 1) {
        NSLog(@"Under 1");
        currentReminders = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *newReminders = [[NSMutableArray alloc] init];
    for (Reminder *notArchivedReminder in currentReminders) {
        [newReminders addObject:[NSKeyedArchiver archivedDataWithRootObject:notArchivedReminder]];
    }
    
    NSData *reminderToSave = [NSKeyedArchiver archivedDataWithRootObject:reminder];
    
    [newReminders addObject:reminderToSave];
    [userDefaults setObject:newReminders forKey:@"reminders"];
    [userDefaults synchronize];
}

@end
