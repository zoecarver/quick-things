//
//  RepeatTableViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/23/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "RepeatTableViewController.h"
#import "TableViewCell.h"
#import "TableViewController.h"
#import "UpdateReminder.h"
#import "FetchRembinders.h"
#import "RepeatViewController.h"
#import "ApplyDarkTheme.h"

@interface RepeatTableViewController () {
    NSMutableArray *options;
    ApplyDarkTheme *applyTheme;
}

@end

@implementation RepeatTableViewController
@synthesize indexPassedDuringSegue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    options = [[NSMutableArray alloc] init];
    
    [options addObject:@"Hourly"];
    [options addObject:@"Daily"];
    [options addObject:@"Weekly"];
    [options addObject:@"Monthly"];
    [options addObject:@"None"];
    
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme tableViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = options[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.cellButton.accessibilityAttributedLabel = [[NSMutableAttributedString alloc] initWithString:options[indexPath.row]];
    cell.cellButton.tag = indexPath.row;
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [applyTheme tableViewCell:cell];
    [applyTheme label:cell.textLabel];
    [applyTheme label:cell.largeTextLabel];
    
    return cell;
}

- (void) handleTouchUpEvent: (UIButton *) sender {
    RepeatViewController *RVC = ((RepeatViewController *) self.parentViewController);
    indexPassedDuringSegue = [RVC indexPassedDuringSegue];
    
    NSLog(@"index from RVC %lu", self.indexPassedDuringSegue);
    
    UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    Reminder *reminder = reminders[indexPassedDuringSegue];
    NSString *item = options[sender.tag];
    
    NSLog(@"Got %@", item);
    if ([item isEqual: @"None"]) {
        [updateReminderAction reminderToUpdate:reminder date:reminder.date notificationKey:reminder.notificationKey snooz:reminder.snooz indexToUpdateWith:indexPassedDuringSegue setRepeat:nil];
    } else {
        [updateReminderAction reminderToUpdate:reminder date:reminder.date notificationKey:reminder.notificationKey snooz:reminder.snooz indexToUpdateWith:indexPassedDuringSegue setRepeat:item];
        
        reminders = [fetchRemindersAction fetchRembinders];
        NSLog(@"Succesefully changed repeat to %@ for %@ with index %lu", [reminders[indexPassedDuringSegue] repeat],[reminders[indexPassedDuringSegue] title], indexPassedDuringSegue);
    }
    
    [self dismissViewControllerAnimated:true completion:nil];
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


@end
