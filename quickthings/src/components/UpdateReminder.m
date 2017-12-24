//
//  UpdateReminder.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/19/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "UpdateReminder.h"
#import "Reminder.h"
#import "FetchRembinders.h"

@implementation UpdateReminder

- (void) reminderToUpdate:(Reminder *)reminderToUpdate date:(NSDate *) date notificationKey:(NSString *) notificationKey snooz:(NSInteger) snooz indexToUpdateWith:(NSInteger) index {
    NSLog(@"Updateing reminder %@", reminderToUpdate.title);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
    
    reminderToUpdate.date = date;
    reminderToUpdate.notificationKey = notificationKey;
    reminderToUpdate.snooz = snooz;
    
    [currentReminders setObject:reminderToUpdate atIndexedSubscript:index];
    
    NSMutableArray *newReminders = [[NSMutableArray alloc] init];
    for (Reminder *notArchivedReminder in currentReminders) {
        [newReminders addObject:[NSKeyedArchiver archivedDataWithRootObject:notArchivedReminder]];
    }
    
    [userDefaults setObject:newReminders forKey:@"reminders"];
    [userDefaults synchronize];
}

@end
