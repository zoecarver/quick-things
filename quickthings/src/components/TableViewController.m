
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
#import <UserNotifications/UserNotifications.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        [self.tableView reloadData];
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
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"  ", [cells[indexPath.row] title]];
    
    cell.scheduledDateLabel.text = [self formatDateAsString:[cells[indexPath.row] date]];
    
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
    
//    UIButton *checkBox = [[UIButton alloc] initWithFrame:CGRectMake(15, 18, 10, 10)];
//    checkBox.layer.borderWidth = 2;
//    checkBox.layer.borderColor = [UIColor grayColor].CGColor;
//    checkBox.layer.cornerRadius = 5;
//
//    CGRect checkBoxBounds = checkBox.bounds;
//    checkBoxBounds.size.height = 15;
//    checkBoxBounds.size.width = 15;
//    checkBox.bounds = checkBoxBounds;
//
//    [checkBox setTag:indexPath.row];
//    [checkBox addTarget:self action:@selector(handleTouchUpEventCheckBox:) forControlEvents:UIControlEventTouchUpInside];
//
//    [cell addSubview:checkBox];
    
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
    [VC setRecivedIndex:sender.tag];
    
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
        [completeReminderAction reminderToComplete:indexPath.row];

        [self updateTableView];
        [self.tableView reloadData];
    }];
    button.backgroundColor = [UIColor greenColor];

    NSArray *returnArrayWithButtons = @[button];
    return returnArrayWithButtons;
}

//- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    NSLog(@"Got trailing");
//
//    return [UISwipeActionsConfiguration configurationWithActions:@[[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"✔" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//        NSLog(@"You got me");
//
//        [tableView setEditing:NO animated:YES];
//
//        [UIView animateWithDuration:0.5f
//                         animations:^{
//                             TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                             cell.backgroundColor = [UIColor blueColor]; //UIColorFromRGB(0x28311FD)
//                         }
//                         completion:^(BOOL finished) {
//                             [completeReminderAction reminderToComplete:indexPath.row];
//
//                             [self updateTableView];
//                             [self.tableView reloadData];
//                         }];
//    }]]];
//}

@end
