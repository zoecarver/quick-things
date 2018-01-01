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
#import "ApplyDarkTheme.h"
#include <CoreImage/CoreImage.h>

@interface ViewController ()
@end

@implementation ViewController
@synthesize recivedString = _recivedString;
@synthesize recivedIndex = _recivedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ApplyDarkTheme *applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme viewController:self];
    [applyTheme toolBar:self.topToolBar];
    [applyTheme toolBar:self.middleToolBar];
    [applyTheme toolBar:self.inputToolBar];
    
    [self decideWhatBarsToHide];
    
    NSLog(@"Started");
    
    _recivedString = @"unchanged";
    _recivedIndex = 0;
    
    [self applyTextInputStyle];
    
    NSLog(@"Finished");
}

- (void) decideWhatBarsToHide {
    switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
        case 1136:
            NSLog(@"iPhone 5 or 5S or 5C");
            self.topToolBar.hidden = NO;
            self.middleToolBar.hidden = NO;
            self.inputToolBar.hidden = NO;
            break;
        case 1334:
            NSLog(@"iPhone 6/6S/7/8");
            self.topToolBar.hidden = NO;
            self.middleToolBar.hidden = NO;
            self.inputToolBar.hidden = NO;
            break;
        case 2208:
            NSLog(@"iPhone 6+/6S+/7+/8+");
            self.topToolBar.hidden = NO;
            self.middleToolBar.hidden = NO;
            self.inputToolBar.hidden = NO;
            break;
        case 2436:
            NSLog(@"iPhone X");
            self.topToolBar.hidden = NO;
            self.middleToolBar.hidden = NO;
            self.inputToolBar.hidden = NO;
            break;
        default:
            printf("unknown");
            self.topToolBar.hidden = YES;
            self.middleToolBar.hidden = YES;
            self.inputToolBar.hidden = NO;
            break;
    }
}

- (void) applyTextInputStyle {
    self.reminderInputField.placeholder = @"Type your reminder here...";
    self.reminderInputField.layer.zPosition = 20;
    
//    [self.reminderInputField.layer setShadowColor:[[UIColor blackColor] CGColor]];
//    [self.reminderInputField.layer setShadowRadius:5.0f];
//    [self.reminderInputField.layer setShadowOffset:CGSizeMake(0 , 0)];
//    [self.reminderInputField.layer setShadowOpacity:0.3f];
    
    [self.reminderInputField setReturnKeyType:UIReturnKeyDone];
    [self.reminderInputField addTarget:self
                       action:@selector(textFieldFinished)
             forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) textFieldFinished {
    NSLog(@"Done Pressed");
    [self add];
}

- (void) createBlur {
    UIView *blur = [[UIView alloc] init];
    
    blur.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*2);
    blur.layer.zPosition = 100;
    blur.backgroundColor = [UIColor blackColor];
    blur.layer.opacity = 0.5f;
    blur.userInteractionEnabled = NO;
    
    [self.view addSubview:blur];
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
    [self add];
}

- (void) add {
    if ([_reminderInputField.text isEqual: @""]) return;
    
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
