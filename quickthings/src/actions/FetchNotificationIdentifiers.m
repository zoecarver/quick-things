//
//  FetchNotificationIdentifiers.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/2/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import "FetchNotificationIdentifiers.h"
#import "ScheduleNotifications.h"
#import "FetchRembinders.h"
#import "UpdateReminder.h"

@implementation FetchNotificationIdentifiers

- (NSString *) addNotification {
    NSMutableArray *ids = [self fetchIdentifiers];
    if (ids.count < 1) ids = [[NSMutableArray alloc] init];
    
    NSInteger i = 0;
    
    for (NSString *identifier in ids) { //FIXME: if we can find a better way to do this that would be great
        i += ([identifier integerValue] + 1);
        NSLog(@"i is now %lu", i);
    }
    
    NSString *stringIdentifier = [NSString stringWithFormat:@"%lu", i];
    NSLog(@"About to save string notification id %@", stringIdentifier);
    
    [ids addObject:stringIdentifier];
    
    [self setIdentifiers:ids];
    
    return stringIdentifier;
}

- (void) schedule:(NSDate *) date forInde:(NSInteger) index {
    UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    NSString *identifier = [self addNotification];
    
    NSLog(@"Scheduling notificaitoin with id %@", identifier);
    for (NSString *s in [self fetchIdentifiers]) {
        NSLog(@"All reminders include %@", s);
    }
    
    [updateReminderAction reminderToUpdate:reminders[index] date:date notificationKey:identifier snooz:[reminders[index] snooz] indexToUpdateWith:index setRepeat:[reminders[index] repeat]];
    
    ScheduleNotifications *scheduleNotifications = [[ScheduleNotifications alloc] init];
    [scheduleNotifications scheduleNotificationWithTitle:[reminders[index] title] date:date stringNotificationKeyFromIndex:identifier withSnoozFromReminder:[reminders[index] snooz]];
}

- (void) removeNotification:(NSString *) toRemove {
    NSMutableArray *ids = [self fetchIdentifiers];
    
    [ids removeObject:toRemove];
    
    [self setIdentifiers:ids];
}

- (NSMutableArray *) fetchIdentifiers {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    
    if (userDefaults != nil) {
        ids = [[userDefaults objectForKey:@"ids"] mutableCopy];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    
    return ids;
}

- (void) setIdentifiers:(NSMutableArray *) ids {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (userDefaults != nil) {
        [userDefaults setObject:ids forKey:@"ids"];
        [userDefaults synchronize];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
}

@end
