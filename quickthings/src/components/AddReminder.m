//
//  AddReminder.m
//  quickThings
//
//  Created by Zoe IAMZOE.io on 12/11/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "AddReminder.h"
#import "FetchRembinders.h"

@implementation AddReminder

- (void) reminderToAdd:(NSString*) _reminderToAdd {
    NSLog(@"Adding reminder %@", _reminderToAdd);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
    
    if (currentReminders.count < 1) {
        currentReminders = [[NSMutableArray alloc] init];
    }
    
    [currentReminders addObject:_reminderToAdd];
    [userDefaults setObject:currentReminders forKey:@"reminders"];
    [userDefaults synchronize];
}

@end
