//
//  ScheduleNotifications.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/2/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import "ScheduleNotifications.h"
#import "FetchSmallUserSettings.h"
#import <UserNotifications/UserNotifications.h>

@implementation ScheduleNotifications

- (void) scheduleNotificationWithTitle: (NSString *)title date:(NSDate *)date stringNotificationKeyFromIndex:(NSString *) identifierForRequest withSnoozFromReminder:(NSInteger) snooz{
    NSLog(@"Schedule got id request: %@", identifierForRequest);
    
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.title = title;
    notificationContent.sound = [UNNotificationSound defaultSound]; //TODO: test if this works
    UNUserNotificationCenter *userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    NSCalendar *gorgianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponets;
    UNCalendarNotificationTrigger *trigger;
    UNNotificationRequest *request;
    
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    
    for (NSInteger i = 0; i < [smallUserSettings fetchNumberOfNotificationsToSchedule]; i++) {
        dateComponets = [gorgianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
        trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponets repeats:true];
        request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%@_%lu", identifierForRequest, i] content:notificationContent trigger:trigger];
        
        [userNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                //Deal with success
                NSLog(@"Success Scheduling Reminder");
            }
        }];
        
        date = [date dateByAddingTimeInterval:60*snooz];
    }
}

- (NSDateComponents *) createGorgianDateComponentsForDate:(NSDate *) date {
    NSCalendar *gorgianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [gorgianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (UNCalendarNotificationTrigger *) createNotificationTriggerWithDateCompontnet:(NSDateComponents *) dateComponets {
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponets repeats:true];
}

@end
