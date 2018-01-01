//
//  CollectionViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CollectionViewController.h"
#import "FetchSettings.h"
#import "CollectionViewCell.h"
#import "UpdateReminder.h"
#import "FetchRembinders.h"
#import "CellEditViewController.h"
#import "CellActions.h"
#import "CompleteReminder.h"
#import "TableViewController.h"
#import "FetchWebHook.h"
#import "FetchSmallUserSettings.h"
#import "ApplyDarkTheme.h"
#import <UserNotifications/UserNotifications.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CollectionViewController () {
    FetchSettings *fetchSettingsAction;
    FetchSmallUserSettings *smallUserSettings;
    NSMutableArray *settings;
    UIGestureRecognizer *gestureRecognizer;
    CellActions *cellActionsClass;
    NSDateFormatter *timeFormatter;
    NSDateFormatter *dayFormatter;
    ApplyDarkTheme *applyTheme;
}

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"CollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme collectionViewController:self];
    [applyTheme view:self.view];
    
    [self initilizeFormaters];
    [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    
    fetchSettingsAction = [[FetchSettings alloc] init];
    smallUserSettings = [[FetchSmallUserSettings alloc] init];
    settings = [fetchSettingsAction fetchSettings];
    
    cellActionsClass = [[CellActions alloc] init];
    
    self.view.layer.cornerRadius = 25;
}

- (void) initilizeFormaters {
    timeFormatter = [[NSDateFormatter alloc] init];
    dayFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"hh:mm a"];
    [dayFormatter setDateFormat:@"EEEE"];
}

- (UIViewController *) previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:location];
    if (!index) { return nil; }
    CellEditViewController *CEVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    
    NSLog(@"Idex of: %lu", index.row);
    
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    DVC.delegate = self;
    DVC.cellIndexToPassDuringSegue = index.row;
    
    return CEVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    DVC.delegate = self;
    [DVC performSegueWithIdentifier:@"ShowCellEditMenu" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Pressed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Got it with %f", [[UIScreen mainScreen] bounds].size.width);
    const int iPhoneSE = 320.000000;
    const int iPhoneSix = 375.000000;
    
    switch ((int)[[UIScreen mainScreen] bounds].size.width) {
        case iPhoneSE:
            return 9;
            break;
        case iPhoneSix:
            return [settings count]; //FIXME
            break;
        default:
            return [settings count];
    }
}

- (void) processDoubleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Got tapped twice by: %lu", sender.view.tag);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"I was double tapped");
        AudioServicesPlaySystemSound(1519);

        DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
        DVC.delegate = self;
        DVC.cellIndexToPassDuringSegue = sender.view.tag;
        
        [DVC performSegueWithIdentifier:@"ShowCellEditMenu" sender:self];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    
    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [doubleTapFolderGesture setNumberOfTouchesRequired:1];
    [doubleTapFolderGesture setDelaysTouchesBegan:YES];
    [cell addGestureRecognizer:doubleTapFolderGesture];
    
    [cell setTag:[indexPath row]];
    
    NSLog(@"Giving it tag: %lu", indexPath.row);
    cell.index = indexPath.row;
    [cell.cellLabel setText:@"Test"];
    
    [applyTheme collectionViewCell:cell];
    [applyTheme label:cell.cellLabel];
    
    if ([settings[indexPath.row] isKindOfClass:[NSDate class]]) {
        return [self applyToSetTimeCell:cell index:indexPath];
    } else if ([settings[indexPath.row]  isEqual:@"Done"]) {
        return [self applyToDoneCell:cell index:indexPath];
    } else if ([settings[indexPath.row]  isEqual:@"Todoist"]) {
        return [self applyToTodoistCell:cell index:indexPath];
    } else if ([settings[indexPath.row]  isEqual:@"Cancel"]) {
        return [self applyToCancelCell:cell index:indexPath];
    } else if ([settings[indexPath.row]  isEqual:@"Complete"]) {
        return [self applyToCompleteCell:cell index:indexPath];
    } else if ([settings[indexPath.row]  isEqual:@"Repeat"]) {
        return [self applyToRepeatCell:cell index:indexPath];
    } else if ([settings[indexPath.row]  isEqual:@"Snooz"]) {
        return [self applyToSnoozCell:cell index:indexPath];
    } else {
        return [self applyToAddCell:cell index:indexPath];
    }
}

- (CollectionViewCell *) applyToRepeatCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = @"Repeat";
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventRepeat) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEventRepeat {
    NSLog(@"Repeat");
    
    [((DateModificationViewController *) self.parentViewController) performSegueWithIdentifier:@"ShowRepeatTableView" sender:self];
}

- (void)showAnimate: (UIView *) view {
    view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        view.alpha = 1;
        view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

//these are here because they needs to be for the segue - otherwise we would need to have some more of the deligate vudo that I don't completely understand.

- (CollectionViewCell *) applyToTodoistCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = @"WebHook";
    [cell.cellLabel adjustsFontSizeToFitWidth];
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell.cellButton setTag:indexPath.row];
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventTodoist:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEventTodoist: (UIButton *) sender {
    NSLog(@"Todoist");
    
    FetchWebHook *fetchWebhookActions = [[FetchWebHook alloc] init];
    NSString *webHook = [fetchWebhookActions fetchWebHook];
    
    if (webHook && ![webHook isEqual: @""]) {
        [self sendToWebHook:webHook];
    } else {
        [self getWebHookWithAlert];
        [self alertHowToChangeWebHook];
    }
}

- (void) alertHowToChangeWebHook {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Editing webhooks" message:@"If you need to change a webhook, edit the button and create a new webhook - this will re-prompt the webhook url input." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) getWebHookWithAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter a webhook attached to a service like zapier" message:@"Click settings -> help for more info" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Ender webhook url";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FetchWebHook *fetchWebhookActions = [[FetchWebHook alloc] init];
        NSString *textRecivedFromInput = [[alertController textFields][0] text];
        
        [self sendToWebHook:textRecivedFromInput];
        [fetchWebhookActions setWebHook:textRecivedFromInput];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) sendToWebHook: (NSString *) webHookToSendTo {
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    DVC.delegate = self;
    
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:webHookToSendTo];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [reminders[DVC.indexPassedDuringSegue] title], @"reminder", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error! %@", error.description);
        } else {
            NSLog(@"Success!");
            
            CompleteReminder *completeReminderAction = [[CompleteReminder alloc] init];
            [completeReminderAction reminderToComplete:[DVC indexPassedDuringSegue]];
            
            [((DateModificationViewController *) self.parentViewController) performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
        }
    }];
    
    [postDataTask resume];
}

- (CollectionViewCell *) applyToSnoozCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = @"Snooz";
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventSnooz) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CollectionViewCell *) applyToCancelCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = @"Cancel";
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventCancel) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEventCancel {
    [self dismissViewControllerAnimated:true completion:nil];
    NSLog(@"Cancel");
}

- (void) handleTouchUpEventSnooz {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter new snooz" message:@"This will only be applied to the current reminder" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
        DVC.delegate = self;
        
        NSString *stringNotificationKeyFromIndex = [NSString stringWithFormat:@"%lu", [DVC indexPassedDuringSegue]];
        NSInteger valueGotFromAlert = [[[alertController textFields][0] text] integerValue];
        NSLog(@"Got val %lu", valueGotFromAlert);
        
        UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
        FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
        
        NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
        if (valueGotFromAlert) {
            [updateReminderAction reminderToUpdate:reminders[DVC.indexPassedDuringSegue] date:[DVC.datePickerAction date] notificationKey:stringNotificationKeyFromIndex snooz:valueGotFromAlert indexToUpdateWith:DVC.indexPassedDuringSegue setRepeat:nil];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CollectionViewCell *) applyToCompleteCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = @"Complete";
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventComplete) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEventComplete {
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    DVC.delegate = self;
    
    CompleteReminder *completeReminderAction = [[CompleteReminder alloc] init];
    [completeReminderAction reminderToComplete:[DVC indexPassedDuringSegue]];
    
    [((DateModificationViewController *) self.parentViewController) performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
}

- (void) handleTouchUpEventTimeCell: (UIButton *) sender {
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    DVC.delegate = self;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate: [[DVC datePickerAction] date]];
    NSDateComponents *dateInComponentFormat = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:settings[sender.tag]];
    [components setHour: [dateInComponentFormat hour]];
    [components setMinute: [dateInComponentFormat minute]];
    
    [DVC test:[calendar dateFromComponents:components]];
}

- (void) handleTouchUpEvent: (UIButton *) sender {
    NSLog(@"Pressed Here ------------------ ");
    UIView *parent = [sender superview];
    while (parent && ![parent isKindOfClass:[CollectionViewCell class]]) {
        parent = parent.superview;
    }
    
    CollectionViewCell *cell = (CollectionViewCell *)parent;
    
    NSLog(@"Adding %@ minutes", cell.addSubVal);

    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    
    DVC.delegate = self;
    
    NSDate *oldDate = [DVC.datePickerAction date];
    NSDate *newDate = [oldDate dateByAddingTimeInterval:cell.addSubVal.doubleValue * 60];
    
    [DVC test:newDate];
}

- (CollectionViewCell *) applyToSetTimeCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = [self formatDateAsString:settings[indexPath.row]];
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    
    [cell.cellButton setTag: [indexPath row]];
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventTimeCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CollectionViewCell *) applyToAddCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    NSNumber *tmpSettinsItem = settings[indexPath.row];
    double switchVal;
    
    if (tmpSettinsItem.doubleValue > 0) {
        switchVal = tmpSettinsItem.doubleValue;
    } else {
        switchVal = tmpSettinsItem.doubleValue * -1;
    }
    
    if (switchVal < 60) {
        if (tmpSettinsItem.doubleValue > 0) {
            cell.cellLabel.text = [NSString stringWithFormat:@"+%@ Min", tmpSettinsItem];
        } else {
            cell.cellLabel.text = [NSString stringWithFormat:@"%@ Min", tmpSettinsItem];
        }
    } else if (switchVal < 60 * 24) {
        if (tmpSettinsItem.doubleValue > 0) {
            cell.cellLabel.text = [NSString stringWithFormat:@"+%.0f Hour", tmpSettinsItem.doubleValue/60];
        } else {
            cell.cellLabel.text = [NSString stringWithFormat:@"%.0f Hour", tmpSettinsItem.doubleValue/60];
        }
    } else if (switchVal < 60 * 24 * 7) {
        if (tmpSettinsItem.doubleValue > 0) {
            cell.cellLabel.text = [NSString stringWithFormat:@"+%.0f Day", tmpSettinsItem.doubleValue/(60 * 24)];
        } else {
            cell.cellLabel.text = [NSString stringWithFormat:@"%.0f Day", tmpSettinsItem.doubleValue/(60 * 24)];
        }
    } else {
        if (tmpSettinsItem.doubleValue > 0) {
            cell.cellLabel.text = [NSString stringWithFormat:@"+%.0f Week", tmpSettinsItem.doubleValue/(60 * 24 * 7)];
        } else {
            cell.cellLabel.text = [NSString stringWithFormat:@"%.0f Week", tmpSettinsItem.doubleValue/(60 * 24 * 7)];
        }
    }
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell setAddSubVal:tmpSettinsItem];
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CollectionViewCell *) applyToDoneCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = @"Done";
    
    if ([smallUserSettings fetchDoneColor]) {
        cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.69 blue:0.97 alpha:1.0];
    }
    
    [self applyCollectionViewSettings:cell withIndex:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventDone) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEventDone {
    NSLog(@"Done pressed! ");
    
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    DVC.delegate = self;
    UpdateReminder *updateReminderAction = [[UpdateReminder alloc] init];
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    NSInteger index = [DVC indexPassedDuringSegue];
    
    NSLog(@"Index that we got for done was %lu", index);
    
    NSString *stringNotificationKeyFromIndex = [NSString stringWithFormat:@"%lu", index];
    
    [updateReminderAction reminderToUpdate:reminders[index] date:[DVC.datePickerAction date] notificationKey:stringNotificationKeyFromIndex snooz:[reminders[index] snooz] indexToUpdateWith:index setRepeat:[reminders[index] repeat]];
    
    [((DateModificationViewController *) self.parentViewController) performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
    
    [self scheduleNotificationWithTitle:[reminders[index] title] date:[DVC.datePickerAction date] stringNotificationKeyFromIndex:stringNotificationKeyFromIndex withSnoozFromReminder:[reminders[index] snooz]];
    
    NSLog(@"Done");
}

- (void) scheduleNotificationWithTitle: (NSString *)title date:(NSDate *)date stringNotificationKeyFromIndex:(NSString *) identifierForRequest withSnoozFromReminder:(NSInteger) snooz{
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.title = title;
    UNUserNotificationCenter *userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    NSCalendar *gorgianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponets;
    UNCalendarNotificationTrigger *trigger;
    UNNotificationRequest *request;
    
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    
    for (NSInteger i = 0; i < [smallUserSettings fetchNumberOfNotificationsToSchedule]; i++) {
        dateComponets = [gorgianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
        trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponets repeats:true];
        request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%@_%lu", identifierForRequest, i] content:notificationContent trigger:trigger];
        
        [userNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
        
        date = [date dateByAddingTimeInterval:60*snooz];
        NSLog(@"Next date will be %@ from snooz %lu", [self formatDateAsString:date], snooz);
    }
}

- (NSDateComponents *) createGorgianDateComponentsForDate:(NSDate *) date {
    NSCalendar *gorgianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [gorgianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (UNCalendarNotificationTrigger *) createNotificationTriggerWithDateCompontnet:(NSDateComponents *) dateComponets {
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponets repeats:true];
}

- (NSString *) formatDateAsString: (NSDate *) date {
    return [NSString stringWithFormat:@"%@", [timeFormatter stringFromDate:date]];
}

- (void) applyCollectionViewSettings:(CollectionViewCell *) cell withIndex:(NSInteger) index {
    cell.layer.cornerRadius = 5;
}

@end
