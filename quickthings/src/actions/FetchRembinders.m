//
//  FetchRembinders.m
//  quickThings
//
//  Created by Zoe IAMZOE.io on 12/11/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "FetchRembinders.h"

@implementation FetchRembinders

- (NSMutableArray *) fetchRembinders {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *reminders = [[NSMutableArray alloc] init];
    
    if (userDefaults != nil) {
        reminders = [[userDefaults objectForKey:@"reminders"] mutableCopy];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    return reminders;
}

@end
