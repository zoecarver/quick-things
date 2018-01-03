//
//  ScheduleNotifications.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/2/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleNotifications : NSObject

- (void) scheduleNotificationWithTitle: (NSString *)title date:(NSDate *)date stringNotificationKeyFromIndex:(NSString *) identifierForRequest withSnoozFromReminder:(NSInteger) snooz;

@end
