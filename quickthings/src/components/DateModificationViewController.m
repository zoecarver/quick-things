//
//  DateModificationViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/15/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "DateModificationViewController.h"
#import "CellEditViewController.h"
#import "CollectionViewController.h"
#import "RepeatTableViewController.h"
#import "FetchWebHook.h"
#import "RepeatViewController.h"
#import "FetchSmallUserSettings.h"
#import "CompleteReminder.h"
#import "UpdateReminder.h"
#import "FetchRembinders.h"
#import "Reminder.h"
#import "ApplyDarkTheme.h"
#import "DoneHandler.h"
#import "SnoozHandler.h"
#import "ScheduleNotifications.h"
#import "FetchNotificationIdentifiers.h"
#import "WebHookHandler.h"
#import <UserNotifications/UserNotifications.h>

@interface DateModificationViewController () {
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    NSString *labelText;
    NSData *timeToBeRemindedAt;
    ApplyDarkTheme *applyTheme;
    NSString *stringNotificationKeyFromIndex;
}
@end

@implementation DateModificationViewController {
    NSArray *stringWeAreGetting;
    UITapGestureRecognizer *tapRecognizer;
}

@synthesize largeTimeDisplayLabel = _largeTimeDisplayLabel;
@synthesize textPassedDuringSegue = _textPassedDuringSegue;
@synthesize indexPassedDuringSegue = _indexPassedDuringSegue;
@synthesize cellIndexToPassDuringSegue = _cellIndexToPassDuringSegue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initilizeFormaters];
    [self initSetDateTimePicker];
    [self applyThemeMethod];
    [self decideWhereToPutBar];
    [self createSwipeGesture];
    
    _largeTimeDisplayLabel.text = _textPassedDuringSegue; //[self formatDateAsString:[_datePickerAction date]];
}

- (void) createSwipeGesture {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
}

- (void) handleSwipe {
    [DoneHandler done:self forDate:[self.datePickerAction date] andIndex:_indexPassedDuringSegue];
}

- (void) applyThemeMethod {
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme viewController:self];
    [applyTheme view:self.view];
    [applyTheme label:self.largeTimeDisplayLabel];
    [applyTheme label:self.smallReminderDisplayLabel];
    [applyTheme datePicker:self.datePickerAction];
    [applyTheme toolBar:self.topToolbar];
    [applyTheme toolBar:self.bottomToolbar];
}

- (void) initSetDateTimePicker {
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    Reminder *reminder = reminders[self.indexPassedDuringSegue];
    
    if (reminder.date) {
        [_datePickerAction setDate:reminder.date];
    } else {
        NSDate *now = [NSDate date];
        [_datePickerAction setDate:now];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowRepeatTableView"]) {
        RepeatViewController *destViewController = segue.destinationViewController;
        destViewController.indexPassedDuringSegue = self.indexPassedDuringSegue;
    } else if ([segue.identifier isEqualToString:@"ShowCellEditMenu"]) {
        CellEditViewController *destViewController = segue.destinationViewController;
        destViewController.indexPassedDuringSegue = _cellIndexToPassDuringSegue;
    }
}

- (void)highlightLetter:(UITapGestureRecognizer *)sender {
    if (![[self.view viewWithTag:42] isHidden]) {
        [[self.view viewWithTag:12] removeFromSuperview];
        [[self.view viewWithTag:42] setHidden:YES];
        [[[self.view viewWithTag:42] layer] setZPosition:-100];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initilizeFormaters {
    timeFormatter = [[NSDateFormatter alloc] init];
    dayFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"hh:mm a"];
    [dayFormatter setDateFormat:@"EEEE"];
}

- (NSString *) formatDateAsString: (NSDate *) date {
    return [NSString stringWithFormat:@"%@, %@", [dayFormatter stringFromDate:date], [timeFormatter stringFromDate:date]];
}

- (void) test: (NSDate *) date {
    [_datePickerAction setDate:date];

    NSString *stringOfRecivedDate = [self formatDateAsString:date];
    _smallReminderDisplayLabel.text = stringOfRecivedDate;
    NSLog(@"Succesfully finished updating date picker time to: %@", stringOfRecivedDate);
}

- (IBAction)donePressed:(id)sender {
    [DoneHandler done:self forDate:[self.datePickerAction date] andIndex:_indexPassedDuringSegue];
}

- (IBAction)snoozPressed:(id)sender {
    [SnoozHandler snooz:self withIndex:self.indexPassedDuringSegue andDate:[self.datePickerAction date]];
}

- (IBAction)repeatPressed:(id)sender {
    [self performSegueWithIdentifier:@"ShowRepeatTableView" sender:self];
}

- (IBAction)webHookPressed:(id)sender {
    WebHookHandler *webhookHandler = [[WebHookHandler alloc] init];
    [webhookHandler webhook:self];
}

- (IBAction)checkPressed:(id)sender {
    CompleteReminder *completeReminderAction = [[CompleteReminder alloc] init];
    [completeReminderAction reminderToComplete:[self indexPassedDuringSegue]];
    NSLog(@"Completed reminder %lu", _indexPassedDuringSegue);
    
    [self performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
}

- (IBAction)datePickerActionChanged:(id)sender {
    NSDate *chosen = [_datePickerAction date];
    
    if ((int)[[UIScreen mainScreen] nativeBounds].size.height == 2436) {
        _smallReminderDisplayLabel.text = [self formatDateAsString:chosen];
    }
}

- (void) decideWhereToPutBar {
    switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
        case 1136:
            NSLog(@"iPhone 5 or 5S or 5C");
            self.bottomToolbar.hidden = YES;
            self.topToolbar.hidden = NO;
            self.collectionViewHeight.constant = (self.collectionViewHeight.constant/1.55);
            self.constraintBelowCollectionView.constant = (self.constraintBelowCollectionView.constant/3);
            break;
        case 1334:
            NSLog(@"iPhone 6/6S/7/8");
            self.bottomToolbar.hidden = YES;
            self.topToolbar.hidden = NO;
            self.constraintBelowCollectionView.constant = (self.constraintBelowCollectionView.constant/5);
            break;
        case 2208:
            NSLog(@"iPhone 6+/6S+/7+/8+");
            self.bottomToolbar.hidden = YES;
            self.topToolbar.hidden = NO;
            self.constraintBelowCollectionView.constant = (self.constraintBelowCollectionView.constant/3);
            break;
        case 2436:
            NSLog(@"iPhone X");
            self.bottomToolbar.hidden = NO;
            self.topToolbar.hidden = YES;
            _smallReminderDisplayLabel.text = [self formatDateAsString:[_datePickerAction date]];
            break;
        default:
            printf("unknown");
            self.bottomToolbar.hidden = YES;
            self.topToolbar.hidden = NO;
            break;
    }
}

@end
