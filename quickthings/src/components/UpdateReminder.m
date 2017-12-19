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

- (void) reminderToUpdate:(Reminder *)reminderToUpdate date:(NSDate *) date notificationKey:(NSString *) notificationKey indexToUpdateWith:(NSInteger) index {
    NSLog(@"Updateing reminder %@", reminderToUpdate.title);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
    
    reminderToUpdate.date = date;
    reminderToUpdate.notificationKey = notificationKey;
    
    if (currentReminders.count < 1) {
        currentReminders = [[NSMutableArray alloc] init];
    }
    
    [currentReminders setObject:reminderToUpdate atIndexedSubscript:index];
    [userDefaults setObject:currentReminders forKey:@"reminders"];
    [userDefaults synchronize];
}

@end
