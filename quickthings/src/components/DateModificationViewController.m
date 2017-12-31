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
#import "RepeatViewController.h"
#import "FetchRembinders.h"
#import "Reminder.h"
#import "ApplyDarkTheme.h"

@interface DateModificationViewController () {
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    NSString *labelText;
    NSData *timeToBeRemindedAt;
    ApplyDarkTheme *applyTheme;
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
    
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme viewController:self];
    [applyTheme view:self.view];
    [applyTheme label:self.largeTimeDisplayLabel];
    [applyTheme label:self.smallReminderDisplayLabel];
    [applyTheme datePicker:self.datePickerAction];
        
    NSLog(@"I was called with tag %lu", self.indexPassedDuringSegue);
    
    [self initilizeFormaters];
    [self initSetDateTimePicker];
    
    _largeTimeDisplayLabel.text = [self formatDateAsString:[_datePickerAction date]];
    _smallReminderDisplayLabel.text = _textPassedDuringSegue;
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
    
    NSLog(@"Receved time, %@", stringOfRecivedDate);
    _largeTimeDisplayLabel.text = stringOfRecivedDate;
}

- (IBAction)datePickerActionChanged:(id)sender {
    NSDate *chosen = [_datePickerAction date];
    
    _largeTimeDisplayLabel.text = [self formatDateAsString:chosen];
}

@end
