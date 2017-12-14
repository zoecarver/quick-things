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

@implementation CompleteReminder

- (void) reminderToComplete:(NSInteger) reminderToComplete {
    NSLog(@"Completing reminder %lu", reminderToComplete);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    FetchCompleted *fetchCompletedAction = [[FetchCompleted alloc] init];
    NSMutableArray *completedReminder = [fetchCompletedAction fetchRembinders];
    NSMutableArray *currentReminders = [fetchRemindersAction fetchRembinders];
    
    [completedReminder addObject:[currentReminders objectAtIndex:reminderToComplete]];
    [userDefaults setObject:completedReminder forKey:@"completed"];

    [currentReminders removeObjectAtIndex:reminderToComplete];
    [userDefaults setObject:currentReminders forKey:@"reminders"];
    [userDefaults synchronize];
}

@end
