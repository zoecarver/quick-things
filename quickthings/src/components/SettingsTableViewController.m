//
//  SettingsTableViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/25/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "TableViewCell.h"
#import "FetchSmallUserSettings.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)


@interface SettingsTableViewController () {
    NSMutableArray *options;
    FetchSmallUserSettings *smallUserSettings;
}

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    NSLog(@"Log loading Settings");
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    smallUserSettings = [[FetchSmallUserSettings alloc] init];
    
    options = [[NSMutableArray alloc] init];
    
    [options addObject:@"Done"];
//    [options addObject:@"Swipe Options"];
//    [options addObject:@"Theme"];
    [options addObject:@"Repeat Notification For"];
    [options addObject:@"Default Snooz"];
    [options addObject:@"Highlight done button"];
    [options addObject:@"Set Icon: "];
    [options addObject:@"Default"];
    [options addObject:@"Blue"];
    [options addObject:@"Grey"];
    [options addObject:@"Stacked"];
//    [options addObject:@"Simple"]; //needs white background
    [options addObject:@"Simple Blue"];
    [options addObject:@"Inverted Blue With Box"];
//    [options addObject:@"Circle"]; //needs white background
    [options addObject:@"Blue Circle"];
    [options addObject:@"Blue Circle With Check"];
//    [options addObject:@"Circle with Check"]; //needs white background
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
    NSString *item = options[indexPath.row];

    if ([item isEqualToString:@"Repeat Notification For"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Repeat Notification %lu times", [smallUserSettings fetchNumberOfNotificationsToSchedule]];
    } else if ([item isEqualToString:@"Default Snooz"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Default Snooz %lu", [smallUserSettings fetchDefaultSnooz]];
    } else if ([item isEqualToString:@"Highlight done button"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSwitch"];
        cell.cellSwitch.on = [smallUserSettings fetchDoneColor];
    } else if ([item isEqualToString:@"Set Icon: "]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellHeader"];
    } else if ([item isEqualToString:@"Done"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellDone"];
    } else {
        cell.textLabel.text = options[indexPath.row];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.cellButton.accessibilityAttributedLabel = [[NSMutableAttributedString alloc] initWithString:options[indexPath.row]];
    cell.cellButton.tag = indexPath.row;
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEvent: (UIButton *) sender {
    NSString *item = options[sender.tag];
    if ([item isEqualToString:@"Done"]) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else if ([item isEqualToString:@"Repeat Notification For"]) {
        [self prompt:@"Enter new number to repeat for" handler:@selector(setNewNotificationRepeat:) fromObject:self];
    } else if ([item isEqualToString:@"Default"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Blue"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_blue" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Clear"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_clear.png" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Grey"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_grey" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Stacked"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_stack" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Simple"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_black_simple" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Simple Blue"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_blue_simple" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Inverted Blue With Box"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_blue_check_inverted" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Circle"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_circle_black" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Blue Circle"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_circle_blue" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Blue Circle With Check"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_circle_check_blue" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Circle with Check"]) {
        [[UIApplication sharedApplication] setAlternateIconName:@"icon_circle_check_black" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error... %@", error.localizedDescription);
        }];
    } else if ([item isEqualToString:@"Default Snooz"]) {
        [self prompt:@"Enter new default snooz" handler:@selector(setNewSnooz:) fromObject:self];
    }
}

- (void) setNewNotificationRepeat:(NSString *)repeatFor {
    [smallUserSettings setNumberOfNotificationsToSchedule:[repeatFor integerValue]];
}

- (void) setNewSnooz:(NSString *) snooz {
    [smallUserSettings setDefaultSnooz:[snooz integerValue]];
}

- (void) prompt:(NSString *) prompt handler:(SEL)handler fromObject:(id) object {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SuppressPerformSelectorLeakWarning([object performSelector:handler withObject:[[alertController textFields][0] text]]);
        
        [self.tableView reloadData];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
