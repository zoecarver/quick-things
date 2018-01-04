//
//  SnoozHandler.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/3/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import "SnoozHandler.h"
#import "DateModificationViewController.h"
#import "UpdateReminder.h"
#import "FetchRembinders.h"

@implementation SnoozHandler

+ (void) snooz:(DateModificationViewController *) sender withIndex:(NSInteger) index andDate:(NSDate *) date {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter new snooz" message:@"This will only be applied to the current reminder" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *stringNotificationKeyFromIndex = [NSString stringWithFormat:@"%lu", index];
        NSInteger valueGotFromAlert = [[[alertController textFields][0] text] integerValue];
        NSLog(@"Alert produced value: %lu", valueGotFromAlert);
        
        UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
        FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
        
        NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
        if (valueGotFromAlert) {
            [updateReminderAction reminderToUpdate:reminders[index] date:date notificationKey:stringNotificationKeyFromIndex snooz:valueGotFromAlert indexToUpdateWith:index setRepeat:nil];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Alert Canelled");
    }];
    [alertController addAction:cancelAction];
    [sender presentViewController:alertController animated:YES completion:nil];
}

@end
