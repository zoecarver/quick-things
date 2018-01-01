//
//  FetchSettings.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "FetchSettings.h"

@implementation FetchSettings

- (NSMutableArray *) fetchSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    if (userDefaults != nil) {
        settings = [[userDefaults objectForKey:@"settings"] mutableCopy];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    if (settings.count < 1) {
        settings = [[NSMutableArray alloc] init];
        
        [settings addObject: [NSNumber numberWithInteger:10]];
        [settings addObject: [NSNumber numberWithInteger:5]];
        [settings addObject: [NSNumber numberWithInteger:2]];
        [settings addObject: [NSNumber numberWithInteger:1]];
        [settings addObject: [self dateWithDay:0 dateWithHour:6 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:7 minute:30]];
        [settings addObject: [self dateWithDay:0 dateWithHour:8 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:10 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:12 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:14 minute:30]];
        [settings addObject: [self dateWithDay:0 dateWithHour:15 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:17 minute:30]];
        [settings addObject: [self dateWithDay:0 dateWithHour:18 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:19 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:20 minute:0]];
        [settings addObject: [self dateWithDay:0 dateWithHour:21 minute:0]];
        [settings addObject: [NSNumber numberWithInteger:-10]];
        [settings addObject: [NSNumber numberWithInteger:-15]];
        [settings addObject: [NSNumber numberWithInteger:-30]];
        [settings addObject: [NSNumber numberWithInteger:-45]];

//        [settings addObject:@"Todoist"];
//        [settings addObject:@"Done"];
//        [settings addObject:@"Complete"];
//        [settings addObject:@"Cancel"];
//        [settings addObject:@"Snooz"];
//        [settings addObject:@"Repeat"];
        
        [userDefaults setObject:settings forKey:@"settings"];
        [userDefaults synchronize];
    }
    
    return settings;
}

-(NSDate *) dateWithDay:(NSInteger)day dateWithHour:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setYear:[calendar component:NSCalendarUnitYear fromDate:NSDate.date]];
    [dateComponents setMonth:[calendar component:NSCalendarUnitMonth fromDate:NSDate.date]];
    [dateComponents setDay:day];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    
    return [calendar dateFromComponents:dateComponents];
}

@end
