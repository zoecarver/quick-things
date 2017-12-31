//
//  ApplyDarkTheme.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/28/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "ApplyDarkTheme.h"
#import "FetchSmallUserSettings.h"
#import "TableViewCell.h"
#import "CollectionViewCell.h"
#import "CollectionViewController.h"
#import "TableViewController.h"

@implementation ApplyDarkTheme {
    NSInteger theme;
    FetchSmallUserSettings *smallUserSettings;
    UIColor *grayText;
    UIColor *grayBackground;
}

- (id)init {
    self = [super init];
    
    smallUserSettings = [[FetchSmallUserSettings alloc] init];
    theme = [smallUserSettings fetchTheme];
    
    grayText = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.0];
    grayBackground = [UIColor colorWithRed:0.29 green:0.32 blue:0.35 alpha:1.0];
    
    return self;
}

- (void) label:(UILabel *) label {
    switch (theme) {
        case 1:
            label.textColor = [self invertColor:label.textColor];
            break;
        case 2:
            label.textColor = grayText;
            break;
        default:
            break;
    }
}

- (void) view:(UIView *) view {
    switch (theme) {
        case 1:
            view.backgroundColor = [self invertColor:view.backgroundColor];
            [view.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            break;
        case 2:
            view.backgroundColor = grayBackground;
            [view.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            break;
        default:
            break;
    }
}

- (void) viewController:(UIViewController *) VC {
    switch (theme) {
        case 1:
            VC.view.backgroundColor = [self invertColor:VC.view.backgroundColor];
            [VC.view.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            break;
        case 2:
            VC.view.backgroundColor = grayBackground;
            [VC.view.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            break;
        default:
            break;
    }
}

- (void) textField:(UITextField *) textField {
    switch (theme) {
        case 1:
            textField.backgroundColor = [self invertColor:textField.backgroundColor];
            break;
        case 2:
            textField.backgroundColor = grayBackground;
            break;
        default:
            break;
    }
}

- (void) tableViewCell:(TableViewCell *) cell {
    switch (theme) {
        case 1:
            cell.backgroundColor = [self invertColor:cell.backgroundColor];
            break;
        case 2:
            cell.backgroundColor = grayBackground;
            break;
        default:
            break;
    }
}

- (void) collectionViewCell:(CollectionViewCell *) cell {
    switch (theme) {
        case 1:
            cell.backgroundColor = [self invertColor:cell.backgroundColor];
            break;
        case 2:
            cell.backgroundColor = grayBackground;
            break;
        default:
            break;
    }
}

- (void) collectionViewController:(CollectionViewController *) CVC {
    switch (theme) {
        case 1:
            CVC.collectionView.backgroundColor = [self invertColor:CVC.collectionView.backgroundColor];
            [CVC.view.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            break;
        case 2:
            CVC.collectionView.backgroundColor = grayBackground;
            [CVC.view.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            break;
        default:
            break;
    }
}

- (void) tableViewController:(TableViewController *) TVC {
    switch (theme) {
        case 1:
            TVC.tableView.backgroundColor = [self invertColor:TVC.tableView.backgroundColor];
            break;
        case 2:
            TVC.tableView.backgroundColor = grayBackground;
            break;
        default:
            break;
    }
}

- (void) datePicker: (UIDatePicker *) DP {
    switch (theme) {
        case 1:
            [DP setValue:[UIColor whiteColor] forKey:@"textColor"];
            break;
        case 2:
            [DP setValue:grayText forKey:@"textColor"];
            break;
        default:
            break;
    }
}

- (UIColor *) picker:(UIPickerView *) picker {
    switch (theme) {
        case 1:
            return [UIColor whiteColor];
            break;
        case 2:
            return grayText;
            break;
        default:
            return [UIColor whiteColor];
            break;
    }
}

- (void) toolBar: (UIToolbar *) toolBar {
    switch (theme) {
        case 1:
            toolBar.barTintColor = [self invertColor:toolBar.barTintColor];
            break;
        case 2:
            toolBar.barTintColor = grayBackground;
            break;
        default:
            break;
    }
}

- (UIColor *) invertColor: (UIColor *)color {
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGFloat newRed = (1.0f - red);
    CGFloat newGreen = (1.0f - green);
    CGFloat newBlue = (1.0f - blue);
    
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:alpha];
}

@end
