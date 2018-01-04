//
//  FetchWebHook.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/24/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "FetchWebHook.h"

@implementation FetchWebHook

- (NSString *) fetchWebHook {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *webHook = nil;
    
    if (userDefaults != nil) {
        webHook = [[userDefaults objectForKey:@"webhook"] mutableCopy];
    } else {
        NSLog(@"ERROR: user defaults is nil");
    }
    
    return webHook;
}

- (void) setWebHook: (NSString *) webhook {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        [userDefaults setObject:webhook forKey:@"webhook"];
        [userDefaults synchronize];
}

@end
