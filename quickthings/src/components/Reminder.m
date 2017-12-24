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
@synthesize snooz;
@synthesize repeat;

-(id) init {
    self = [super init];
    self.title = @"";
    self.date = [NSDate date];
    self.notificationKey = @"";
    self.snooz = 1;
    self.repeat = nil;
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
    self.snooz = [decoder decodeIntegerForKey:@"snooz"];
    self.repeat = [decoder decodeObjectForKey:@"repeat"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.notificationKey forKey:@"notificationKey"];
    [encoder encodeInteger:self.snooz forKey:@"snooz"];
    [encoder encodeObject:self.repeat forKey:@"repeat"];
}


@end
