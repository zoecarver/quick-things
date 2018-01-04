//
//  DoneHandler.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/3/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import "DoneHandler.h"
#import "FetchNotificationIdentifiers.h"
#import "DateModificationViewController.h"

@implementation DoneHandler

+ (void) done:(DateModificationViewController *)sender forDate:(NSDate *)date andIndex:(NSInteger) index {
    FetchNotificationIdentifiers *notifications = [[FetchNotificationIdentifiers alloc] init];
    [notifications schedule:date forInde:index];
    
    [sender performSegueWithIdentifier:@"ShowAllRemindersView" sender:sender];
}

@end
