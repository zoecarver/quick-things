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
#import <UserNotifications/UserNotifications.h>

@implementation CompleteReminder

- (void) reminderToComplete:(NSInteger) reminderToComplete {
    NSLog(@"Completing reminder %lu", reminderToComplete);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
//    FetchCompleted *fetchCompletedAction = [[FetchCompleted alloc] init];
//    NSMutableArray *completedReminder = [fetchCompletedAction fetchRembinders];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
//    re implement me later
//    [completedReminder addObject:[[currentReminders objectAtIndex:reminderToComplete] title]];
//    [userDefaults setObject:completedReminder forKey:@"completed"];

    [currentReminders removeObjectAtIndex:reminderToComplete];
    
    NSMutableArray *newReminders = [[NSMutableArray alloc] init];
    for (Reminder *notArchivedReminder in currentReminders) {
        [newReminders addObject:[NSKeyedArchiver archivedDataWithRootObject:notArchivedReminder]];
    }
    
    [userDefaults setObject:newReminders forKey:@"reminders"];
    [userDefaults synchronize];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    for (NSInteger i = 0; i<10; i++) {
        [center removePendingNotificationRequestsWithIdentifiers:@[[NSString stringWithFormat:@"%lu_%lu", reminderToComplete, i]]];
    }
}

@end
