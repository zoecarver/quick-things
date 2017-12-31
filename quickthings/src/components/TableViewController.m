
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
#import "ApplyDarkTheme.h"
#import <AudioToolbox/AudioToolbox.h>
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
    ApplyDarkTheme *applyTheme;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme tableViewController:self];
    
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
        
        Reminder *reminderCell = cells[i];
        
        double diff = [self numberOfDaysBetween:[NSDate date] and:reminderCell.date];
        double diffMins = [self numberOfMinutesBetween:[NSDate date] and:reminderCell.date];
        NSLog(@"Got days difforence: %f or minutes %f for reminder %@", diff, diffMins, reminderCell.title);
        
        if (diffMins < 0) {
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

- (double)numberOfMinutesBetween:(NSDate *)startDate and:(NSDate *)endDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return [components minute];
}

- (double)numberOfHoursBetween:(NSDate *)startDate and:(NSDate *)endDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitHour
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return [components hour];
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
        cell.focusStyle = UITableViewCellEditingStyleNone;
    }
    
    [applyTheme tableViewCell:cell];
    [applyTheme label:cell.diffLabel];
    [applyTheme label:cell.scheduledDateLabel];
    [applyTheme label:cell.textLabel];
    
    return cell;
}

- (TableViewCell *) applyToDivider:(TableViewCell *) cell withIndexPath:(NSIndexPath *) indexPath {
    [cell.textLabel setText:cells[indexPath.row]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:24]];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    return cell;
}

- (TableViewCell *) applyToCell:(TableViewCell *) cell withIndexPath:(NSIndexPath *)indexPath {
    double diff = [self numberOfDaysBetween:[NSDate date] and:[cells[indexPath.row] date]];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"  ", [cells[indexPath.row] title]];
    
    cell.scheduledDateLabel.text = [self formatDateAsString:[cells[indexPath.row] date]];
    if (diff == 0) {
        double diffMins = [self numberOfMinutesBetween:[NSDate date] and:[cells[indexPath.row] date]];
        double diffHours = [self numberOfHoursBetween:[NSDate date] and:[cells[indexPath.row] date]];

        if (diffHours == 0) {
            [self setDiffLabelMinute:diffMins forCell:cell];
        } else {
            [self setDiffLabelHour:diffHours forCell:cell];
        }
    } else {
        [self setDiffLabelDay:diff forCell:cell];
    }
    
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

- (void) setDiffLabelMinute:(double) diff forCell:(TableViewCell *) cell {
    if (diff == 1 || diff == -1) {
        cell.diffLabel.text = [NSString stringWithFormat:@"Due in %.0f Min", diff];
    } else if (diff == 0) {
        cell.diffLabel.text = [NSString stringWithFormat:@"Due now"];
    } else {
        cell.diffLabel.text = [NSString stringWithFormat:@"Due in %.0f Mins", diff];
    }
}

- (void) setDiffLabelHour:(double) diff forCell:(TableViewCell *) cell {
    if (diff == 1 || diff == -1) {
        cell.diffLabel.text = [NSString stringWithFormat:@"Due in %.0f Hour", diff];
    } else {
        cell.diffLabel.text = [NSString stringWithFormat:@"Due in %.0f Hours", diff];
    }
}

- (void) setDiffLabelDay:(double) diff forCell:(TableViewCell *) cell {
    if (diff == 1 || diff == -1) {
        cell.diffLabel.text = [NSString stringWithFormat:@"Due in %.0f day", diff];
    } else {
        cell.diffLabel.text = [NSString stringWithFormat:@"Due in %.0f days", diff];
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cells[indexPath.row] class] != [Reminder class]) {
        return NO;
    }
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

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSLog(@"Got swipe");
    UIContextualAction *button = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"✅" handler:^(UIContextualAction *ca, UIView *view, void (^err)(BOOL)){
        NSLog(@"Full swipe - you should not be seeing this");
    }];
    button.backgroundColor = [UIColor colorWithRed:0.11 green:0.69 blue:0.97 alpha:1.0];
    
    UISwipeActionsConfiguration *action = [UISwipeActionsConfiguration configurationWithActions:@[button]];
    action.performsFirstActionWithFullSwipe = NO;
    
    AudioServicesPlaySystemSound(1519);
    
    [UIView animateWithDuration:5 //not working but thats okay cuz it doesnt need to
                     animations:^{
                         //do nothing
                     }
                     completion:^(BOOL completed){
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [tableView setEditing:NO animated:YES];
                             
                             [UIView animateWithDuration:0.4
                                              animations:^{
                                                  cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.69 blue:0.97 alpha:1.0];
                                              }];
                             
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                 NSInteger actualCellIndex = [self getActuallIndexForIndex:indexPath.row];
                                 NSLog(@"completing cell at %lu", actualCellIndex);
                                 
                                 [completeReminderAction reminderToComplete:actualCellIndex];
                                 
                                 [self updateTableView];
                                 
                                 for (TableViewCell *cellElement in tableView.visibleCells) {
                                     cellElement.backgroundColor = [UIColor whiteColor];
                                     [applyTheme tableViewCell:cellElement];
                                     [applyTheme label:cellElement.diffLabel];
                                     [applyTheme label:cellElement.scheduledDateLabel];
                                     [applyTheme label:cellElement.textLabel];
                                 }
                             });
                         });
                     }];
    
    return action;
}

@end
