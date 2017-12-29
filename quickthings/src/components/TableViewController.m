
//
//  TableViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/12/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "TableViewController.h"
#import "FetchRembinders.h"
#import "CompleteReminder.h"
#import "TableViewCell.h"
#import "ViewController.h"
#import "Reminder.h"
#import "SortReminders.h"
#import <UserNotifications/UserNotifications.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TableViewController () {
    FetchRembinders *fetchRemindersAction;
    CompleteReminder *completeReminderAction;
    NSMutableArray *cells;
    NSMutableArray *cellsCheck;
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    SortReminders *sortRemindersAction;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    fetchRemindersAction = [[FetchRembinders alloc] init];
    completeReminderAction = [[CompleteReminder alloc] init];
    sortRemindersAction = [[SortReminders alloc] init];
//    cells = [sortRemindersAction sort];
    cellsCheck = cells;
    
    [self initilizeFormaters];
    [self updateTableView];
}

- (void) initilizeFormaters {
    timeFormatter = [[NSDateFormatter alloc] init];
    dayFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"hh:mm a"];
    [dayFormatter setDateFormat:@"EEEE"];
}

- (void) updateTableView {
    cells = [sortRemindersAction sort];
    
    [self updateSections];
    [self.tableView reloadData];
    
    cellsCheck = cells;

    NSLog(@"Finished updating successfully");
}

- (void) updateSections {
    BOOL hasDoneOverDue = NO;
    BOOL hasDoneToday = NO;
    BOOL hasDoneNextSevenDays = NO;
    BOOL hasDoneFuture = NO;
    
    for (NSInteger i = 0; i < cells.count; i++) {
        NSLog(@"Currently on %lu with max %lu", i, cells.count);
        [self logCells];
        if (i+1 == cells.count) {
            NSLog(@"Aborting!");
            return;
        }
        
        Reminder *reminderCell = cells[i];
        
        double diff = [self numberOfDaysBetween:[NSDate date] and:reminderCell.date];
        NSLog(@"Got days difforence: %f for reminder %@", diff, reminderCell.title);
        
        if (diff < 0) {
            if (hasDoneOverDue == NO) {
                [cells insertObject:@"Overdue" atIndex:i];
                hasDoneOverDue = YES;
                i++;
            }
        } else if (diff == 0) {
            if (hasDoneToday == NO) {
                [cells insertObject:@"Today" atIndex:i];
                hasDoneToday = YES;
                i++;
            }
        } else if (diff < 7) {
            if (hasDoneNextSevenDays == NO) {
                [cells insertObject:@"This Week" atIndex:i];
                hasDoneNextSevenDays = YES;
                i++;
            }
        } else {
            if (hasDoneFuture == NO) {
                [cells insertObject:@"Future" atIndex:i];
                hasDoneFuture = YES;
                i++;
            }
        }
    }
}
         
- (void) logCells {
    for (NSInteger i = 0; i < cells.count; i++) {
        if ([cells[i] isKindOfClass:[Reminder class]]) {
            NSLog(@"%lu: %@", i, [cells[i] title]);
        } else {
            NSLog(@"%lu: %@", i, cells[i]);
        }
    }
}

- (double)numberOfDaysBetween:(NSDate *)startDate and:(NSDate *)endDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return [components day];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self logCells];
    if (![cells isEqualToArray:cellsCheck]) {
        [self updateTableView];
    }

    TableViewCell *cell;
    
    if ([cells[indexPath.row] isKindOfClass:[Reminder class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
        cell = [self applyToCell:cell withIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellDateSeprator"];
        cell = [self applyToDivider:cell withIndexPath:indexPath];
    }
    
    return cell;
}

- (TableViewCell *) applyToDivider:(TableViewCell *) cell withIndexPath:(NSIndexPath *) indexPath {
    [cell.textLabel setText:cells[indexPath.row]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:24]];
    
    return cell;
}

- (TableViewCell *) applyToCell:(TableViewCell *) cell withIndexPath:(NSIndexPath *)indexPath {
    double diff = [self numberOfDaysBetween:[NSDate date] and:[cells[indexPath.row] date]];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"  ", [cells[indexPath.row] title]];
    
    cell.scheduledDateLabel.text = [self formatDateAsString:[cells[indexPath.row] date]];
    cell.diffLabel.text = [NSString stringWithFormat:@"Due in %.0f days", diff];
    
    cell.cellButton.accessibilityAttributedLabel = [[NSMutableAttributedString alloc] initWithString:[cells[indexPath.row] title]];
    cell.cellButton.tag = indexPath.row;
    NSLog(@"Adding actrion for index %lu repeat %@", indexPath.row, [cells[indexPath.row] repeat]);
    [cell.cellButton addTarget:self action:@selector(onLongPress:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([cells[indexPath.row] repeat] != nil) {
        NSLog(@"Adding repeat icon...");
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"icons8-sync-50.png"];
        CGRect bounds = attachment.bounds;
        bounds.size.height = 15;
        bounds.size.width = 15;
        attachment.bounds = bounds;
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@, %@", [self formatDateAsString:[cells[indexPath.row] date]], @"   "]];
        [myString appendAttributedString:attachmentString];
        
        cell.scheduledDateLabel.attributedText = myString;
    }
    
    return cell;
}

- (void) handleTouchUpEventCheckBox: (UIButton *) sender {
    [UIView animateWithDuration:.5 animations:^{
        sender.backgroundColor = [UIColor blueColor];
        
        [sender.layer setShadowColor:[[UIColor blueColor] CGColor]];
        [sender.layer setShadowRadius:5.0f];
        [sender.layer setShadowOffset:CGSizeMake(0, 0)];
        [sender.layer setShadowOpacity:0.8f];

        [sender.inputView setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.5f]];
    }
    completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            [sender.layer setShadowColor:[[UIColor clearColor] CGColor]];
        }];
    }];
}

- (NSString *) formatDateAsString: (NSDate *) date {
    return [NSString stringWithFormat:@"%@, %@", [dayFormatter stringFromDate:date], [timeFormatter stringFromDate:date]];
}

- (void) onLongPress: (UIButton *) sender {
    NSInteger actualCellIndex = [self getActuallIndexForIndex:sender.tag];

    [UIView animateWithDuration:1.0f
                     animations:^{
                         // Set the original frame back
                         self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         sender.backgroundColor = [UIColor grayColor];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                          animations:^{
                                              self.view.transform = CGAffineTransformIdentity;
                                              sender.backgroundColor = [UIColor whiteColor];
                                          }];
                     }];
    
    NSLog(@"Got the press");
    NSString *recivedValue = [sender.accessibilityAttributedLabel string];
    NSLog(@"Preforming Segue with value, %@", recivedValue);
    
    ViewController *VC =  ((ViewController *) self.parentViewController);
    [VC setDelegate:self];
    
    [VC setRecivedString:recivedValue];
    [VC setRecivedIndex:actualCellIndex];
    
    NSLog(@"seguing to tag %lu", [VC recivedIndex]);
    
    [VC performSegueWithIdentifier:@"ShowDatePickerView" sender:self];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"✅" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSInteger actualCellIndex = [self getActuallIndexForIndex:indexPath.row];
        NSLog(@"completing cell at %lu", actualCellIndex);
        
        [completeReminderAction reminderToComplete:actualCellIndex];
        
        [self updateTableView];
    }];
    button.backgroundColor = [UIColor greenColor];

    NSArray *returnArrayWithButtons = @[button];
    return returnArrayWithButtons;
}

- (NSInteger) getActuallIndexForIndex:(NSInteger)index {
    NSInteger nI = 0;
    BOOL breakOut = NO;
    
    for (NSInteger i = 0; i < [cells count] && !breakOut; i++) {
        if ([cells[i] isKindOfClass:[Reminder class]]) {
            if ([cells[i] isEqual:cells[index]]) {
                breakOut = YES;
            }
        } else {
            nI++;
        }
    }
    
    return index-nI;
}

@end
