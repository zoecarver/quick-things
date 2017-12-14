//
//  ViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/11/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "ViewController.h"
#import "FetchRembinders.h"
#import "AddReminder.h"
#import "TableViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addReminderButton:(id)sender {
    NSLog(@"Add button pressed");
    
    //init classes
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    AddReminder *addRemindersAction = [[AddReminder alloc] init];
//    TableViewController *cellHandlerClass = [[TableViewController alloc] init];
    
    //create reminder
    [addRemindersAction reminderToAdd:_reminderInputField.text];
    
    //log out reminders
    NSMutableArray *recivedReminders = [fetchRemindersAction fetchRembinders];
    NSLog(@"logging %lu reminders", [recivedReminders count]);
    
    for (NSString *reminder in recivedReminders) {
        NSLog(@"Reminder: %@", reminder);
    }
}

@end
