//
//  UpdateReminder.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/19/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@interface UpdateReminder : NSObject

- (void) reminderToUpdate:(Reminder *)reminderToUpdate date:(NSDate *) date notificationKey:(NSString *) notificationKey indexToUpdateWith:(NSInteger) index;
@end
