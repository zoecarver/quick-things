//
//  Reminder.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/19/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder:NSObject <NSCoding> {
    NSString *title;
    NSDate *date;
    NSString *notificationKey;
}

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, readwrite) NSString *notificationKey;

@end
