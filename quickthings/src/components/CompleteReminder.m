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
#import "FetchNotificationIdentifiers.h"
#import <UserNotifications/UserNotifications.h>

@implementation CompleteReminder

- (void) reminderToComplete:(NSInteger) reminderToComplete {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];

    Reminder *reminder = currentReminders[reminderToComplete];
    if ([reminder repeat] != nil) {
        [self reScedule:reminder withIndex:reminderToComplete];
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
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [smallUserSettings fetchNumberOfNotificationsToSchedule]; i++) {
        [toRemove addObject:[NSString stringWithFormat:@"%@_%lu", reminder.notificationKey, i]];
        NSLog(@"Add to list: %@", [NSString stringWithFormat:@"%@_%lu", reminder.notificationKey, i]);
    }
    
    [center removePendingNotificationRequestsWithIdentifiers:toRemove];
    
    FetchNotificationIdentifiers *notifications = [[FetchNotificationIdentifiers alloc] init];
    [notifications removeNotification:reminder.notificationKey];
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

//    FetchCompleted *fetchCompletedAction = [[FetchCompleted alloc] init];
//    NSMutableArray *completedReminder = [fetchCompletedAction fetchRembinders];
//    re implement me later
//    [completedReminder addObject:[[currentReminders objectAtIndex:reminderToComplete] title]];
//    [userDefaults setObject:completedReminder forKey:@"completed"];
