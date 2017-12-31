//
//  ApplyDarkTheme.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/28/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//
#import "TableViewCell.h"
#import "CollectionViewCell.h"
#import "CollectionViewController.h"
#import "TableViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ApplyDarkTheme : NSObject

- (void) label:(UILabel *) label;
- (void) view:(UIView *) view;
- (void) viewController:(UIViewController *) VC;
- (void) textField:(UITextField *) textField;
- (void) tableViewCell:(TableViewCell *) TVC;
- (void) collectionViewCell:(CollectionViewCell *) cell;
- (void) collectionViewController:(CollectionViewController *) CVC;
- (void) tableViewController:(TableViewController *) TVC;
- (void) datePicker: (UIDatePicker *) DP;
- (void) toolBar: (UIToolbar *) toolBar;
- (UIColor *) picker:(UIPickerView *) picker;

@end
