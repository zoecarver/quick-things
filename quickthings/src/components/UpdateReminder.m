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

- (void) reminderToUpdate:(Reminder *)reminderToUpdate date:(NSDate *) date notificationKey:(NSString *) notificationKey snooz:(NSInteger) snooz indexToUpdateWith:(NSInteger) index setRepeat:(NSString *)repeat {
    NSLog(@"Updateing reminder %@", reminderToUpdate.title);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
    
    reminderToUpdate.date = date;
    reminderToUpdate.notificationKey = notificationKey;
    reminderToUpdate.snooz = snooz;
    reminderToUpdate.repeat = repeat;

    //This may be an issue - we will see
//    if (repeat != nil) {
//        reminderToUpdate.repeat = repeat;
//    }
    
    [currentReminders setObject:reminderToUpdate atIndexedSubscript:index];
    
    NSMutableArray *newReminders = [[NSMutableArray alloc] init];
    for (Reminder *notArchivedReminder in currentReminders) {
        [newReminders addObject:[NSKeyedArchiver archivedDataWithRootObject:notArchivedReminder]];
    }
    
    [userDefaults setObject:newReminders forKey:@"reminders"];
    [userDefaults synchronize];
}

@end
