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

@interface DateModificationViewController () {
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    NSString *labelText;
    NSData *timeToBeRemindedAt;
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
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLog(@"I was called");
    
    [self initilizeFormaters];
    
    NSDate *now = [NSDate date];
    [_datePickerAction setDate:now];
    
    _largeTimeDisplayLabel.text = [self formatDateAsString:now];
    _smallReminderDisplayLabel.text = _textPassedDuringSegue;
    
//    UIView *blur = [[UIView alloc] init];
//
//    blur.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*2);
//    blur.layer.zPosition = 10;
//    blur.backgroundColor = [UIColor blackColor];
//    blur.layer.opacity = 0.05f;
//    blur.userInteractionEnabled = NO;
//
//    [self.view addSubview:blur];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowRepeatTableView"]) {
        RepeatTableViewController *destViewController = segue.destinationViewController;
        destViewController.indexPassedDuringSegue = _indexPassedDuringSegue;
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
