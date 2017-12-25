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
    NSInteger snooz;
}

@property (nonatomic, readwrite) NSString * _Nonnull title;
@property (nonatomic, readwrite) NSDate * _Nonnull date;
@property (nonatomic, readwrite) NSString * _Nonnull notificationKey;
@property (nonatomic, readwrite) NSInteger snooz;
@property (nullable, nonatomic, readwrite) NSString *repeat;

@end
