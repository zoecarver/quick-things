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
#import "DateModificationViewController.h"
#include <CoreImage/CoreImage.h>

@interface ViewController ()
@end

@implementation ViewController
@synthesize recivedString = _recivedString;
@synthesize recivedIndex = _recivedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Started");
    
    _recivedString = @"unchanged";
    _recivedIndex = 0;
    
    NSLog(@"Finished");
    
    static CIColorKernel *kernel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        kernel = [CIColorKernel kernelWithString:
                  @"kernel vec4 swapRedAndGreenAmount(__sample s) { return s.grba; }"];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDatePickerView"]) {
        DateModificationViewController *destViewController = segue.destinationViewController;
        destViewController.textPassedDuringSegue = _recivedString;
        
        NSLog(@"Giving DVC %lu", self.recivedIndex);
        
        destViewController.indexPassedDuringSegue = self.recivedIndex;
    }
}

- (IBAction)addReminderButton:(id)sender {
    NSLog(@"Add button pressed");
    
    //init classes
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    AddReminder *addRemindersAction = [[AddReminder alloc] init];
    
    //create reminder
    [addRemindersAction reminderToAdd:_reminderInputField.text];
    
    //log out reminders
    NSMutableArray *recivedReminders = [fetchRemindersAction fetchRembinders];
    NSLog(@"logging %lu reminders", [recivedReminders count]);
    
    for (NSString *reminder in recivedReminders) {
        NSLog(@"Reminder: %@", reminder);
    }
    
    NSLog(@"Sending to date picker");
    _recivedString = _reminderInputField.text;
    self.recivedIndex = [recivedReminders count] - 1;
    [self performSegueWithIdentifier:@"ShowDatePickerView" sender:self];
}

- (IBAction)settingsButton:(id)sender {
    NSLog(@"Settings pressed");
    
    [self performSegueWithIdentifier:@"ShowUserSettings" sender:self];
}

@end
