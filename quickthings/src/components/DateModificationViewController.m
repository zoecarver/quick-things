//
//  DateModificationViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/15/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "DateModificationViewController.h"

@interface DateModificationViewController () {
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    NSString *labelText;
    NSData *timeToBeRemindedAt;
}
@end

@implementation DateModificationViewController {
    NSArray *stringWeAreGetting;
}

@synthesize largeTimeDisplayLabel = _largeTimeDisplayLabel;
@synthesize textPassedDuringSegue = _textPassedDuringSegue;
@synthesize indexPassedDuringSegue = _indexPassedDuringSegue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initilizeFormaters];
    
    NSDate *now = [NSDate date];
    [_datePickerAction setDate:now];
    
    _largeTimeDisplayLabel.text = [self formatDateAsString:now];
    _smallReminderDisplayLabel.text = _textPassedDuringSegue;
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
