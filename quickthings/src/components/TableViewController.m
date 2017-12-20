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
#import <UserNotifications/UserNotifications.h>

@interface TableViewController () {
    FetchRembinders *fetchRemindersAction;
    CompleteReminder *completeReminderAction;
    NSMutableArray *cells;
    NSInteger cellsCount;
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fetchRemindersAction = [[FetchRembinders alloc] init];
    completeReminderAction = [[CompleteReminder alloc] init];
    cells = [fetchRemindersAction fetchRembinders];
    cellsCount = [cells count];
    
    [self initilizeFormaters];
}

- (void) initilizeFormaters {
    timeFormatter = [[NSDateFormatter alloc] init];
    dayFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"hh:mm a"];
    [dayFormatter setDateFormat:@"EEEE"];
}

- (void) updateTableView {
    cells = [fetchRemindersAction fetchRembinders];
    if ([cells count] > cellsCount) {
        [_tableViewElement reloadData];
    }
    cellsCount = [cells count];
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
    [self updateTableView];
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [cells[indexPath.row] title];
    cell.scheduledDateLabel.text = [self formatDateAsString:[cells[indexPath.row] date]];
    
    cell.backgroundColor = [UIColor grayColor];
    
    cell.cellButton.accessibilityAttributedLabel = [[NSMutableAttributedString alloc] initWithString:[cells[indexPath.row] title]];
    cell.cellButton.tag = indexPath.row;
    [cell.cellButton addTarget:self action:@selector(onLongPress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSString *) formatDateAsString: (NSDate *) date {
    return [NSString stringWithFormat:@"%@, %@", [dayFormatter stringFromDate:date], [timeFormatter stringFromDate:date]];
}

- (void) onLongPress: (UIButton *) sender {
    NSString *recivedValue = [sender.accessibilityAttributedLabel string];
    NSLog(@"Preforming Segue with value, %@", recivedValue);
    
    ViewController *VC =  ((ViewController *) self.parentViewController);
    [VC setDelegate:self];
    
    [VC setRecivedString:recivedValue];
    [VC setRecivedIndex:sender.tag];
    
    [((ViewController *) self.parentViewController) performSegueWithIdentifier:@"ShowDatePickerView" sender:self];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

void (^reminderCompleteHandler)(UITableViewRowAction*, NSIndexPath*, NSMutableArray*, UITableView*, CompleteReminder*) = ^(UITableViewRowAction *action, NSIndexPath *indexPath, NSMutableArray *cells, UITableView *tableView, CompleteReminder *completeReminderAction){
    NSLog(@"Handler called");
    [completeReminderAction reminderToComplete:indexPath.row];
    [cells removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
};

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"✅" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        reminderCompleteHandler(action, indexPath, cells, tableView, completeReminderAction);
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:@[[NSString stringWithFormat:@"%lu", indexPath.row]]];
    }];
    button.backgroundColor = [UIColor greenColor];
    NSArray *returnArrayWithButtons = @[button];
    return returnArrayWithButtons;
}

@end
