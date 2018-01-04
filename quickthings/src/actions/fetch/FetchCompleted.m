//
//  FetchCompleted.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "FetchCompleted.h"

@implementation FetchCompleted

- (NSMutableArray *) fetchRembinders {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *reminders = [[NSMutableArray alloc] init];
    
    if (userDefaults != nil) {
        reminders = [[userDefaults objectForKey:@"completed"] mutableCopy];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    
    return reminders;
}

@end
