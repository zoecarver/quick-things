//
//  Reminder.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/19/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@synthesize title;
@synthesize date;
@synthesize notificationKey;

-(id) init {
    self = [super init];
    self.title = @"";
    self.date = [NSDate date];
    self.notificationKey = @"";
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = [decoder decodeObjectForKey:@"title"];
    self.date = [decoder decodeObjectForKey:@"date"];
    self.notificationKey = [decoder decodeObjectForKey:@"notificationKey"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.notificationKey forKey:@"notificationKey"];
}


@end
