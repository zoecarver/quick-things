//
//  CompleteReminder.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CompleteReminder.h"
#import "FetchRembinders.h"
#import "FetchCompleted.h"
#import "Reminder.h"
#import "UpdateReminder.h"
#import "FetchSmallUserSettings.h"
#import <UserNotifications/UserNotifications.h>

@implementation CompleteReminder

- (void) reminderToComplete:(NSInteger) reminderToComplete {
    NSLog(@"Completing reminder %lu", reminderToComplete);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
//    FetchCompleted *fetchCompletedAction = [[FetchCompleted alloc] init];
//    NSMutableArray *completedReminder = [fetchCompletedAction fetchRembinders];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
//    re implement me later
//    [completedReminder addObject:[[currentReminders objectAtIndex:reminderToComplete] title]];
//    [userDefaults setObject:completedReminder forKey:@"completed"];

    Reminder *reminderToPreformRepeatOn = currentReminders[reminderToComplete];
    NSLog(@"Got complete status %@", [reminderToPreformRepeatOn repeat]);
    if ([reminderToPreformRepeatOn repeat] != nil) {
        [self reScedule:reminderToPreformRepeatOn withIndex:reminderToComplete];
        return;
    }
    
    [currentReminders removeObjectAtIndex:reminderToComplete];
    
    NSMutableArray *newReminders = [[NSMutableArray alloc] init];
    for (Reminder *notArchivedReminder in currentReminders) {
        [newReminders addObject:[NSKeyedArchiver archivedDataWithRootObject:notArchivedReminder]];
    }
    
    [userDefaults setObject:newReminders forKey:@"reminders"];
    [userDefaults synchronize];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    for (NSInteger i = 0; i < [smallUserSettings fetchNumberOfNotificationsToSchedule]; i++) {
        [center removePendingNotificationRequestsWithIdentifiers:@[[NSString stringWithFormat:@"%lu_%lu", reminderToComplete, i]]];
    }
}

- (void) reScedule:(Reminder *) reminder withIndex:(NSInteger ) index {
    NSString *item = [reminder repeat];
    UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
    
    if ([item isEqualToString:@"Hourly"]) {
        reminder.date = [reminder.date dateByAddingTimeInterval:60*60];
    } else if ([item isEqualToString:@"Daily"]) {
        reminder.date = [reminder.date dateByAddingTimeInterval:60*60*24];
    } else if ([item isEqualToString:@"Weekly"]) {
        reminder.date = [reminder.date dateByAddingTimeInterval:60*60*24*7];
    } else if ([item isEqualToString:@"Monthly"]) {
        reminder.date = [reminder.date dateByAddingTimeInterval:60*60*42*7*4];
    }
    
    [updateReminderAction reminderToUpdate:reminder date:reminder.date notificationKey:reminder.notificationKey snooz:reminder.snooz indexToUpdateWith:index setRepeat:reminder.repeat];
}

@end
