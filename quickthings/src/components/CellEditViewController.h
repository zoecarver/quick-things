//
//  CellEditViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/20/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellEditViewController : UIViewController

@property (nonatomic) NSInteger indexPassedDuringSegue;
@property (weak, nonatomic) IBOutlet UIDatePicker *cellEditDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *addSubInput;

//top level
- (IBAction)addPressed:(id)sender;
- (IBAction)subtractPressed:(id)sender;
- (IBAction)setTimePressed:(id)sender;
- (IBAction)preformActionPressed:(id)sender;

//actions (1)
@property (weak, nonatomic) IBOutlet UIToolbar *actionOne;
- (IBAction)markAsCompletePressed:(id)sender;
- (IBAction)createPressed:(id)sender;
- (IBAction)setCancelPressed:(id)sender;

//actions (2)
@property (weak, nonatomic) IBOutlet UIToolbar *actionTwo;
- (IBAction)donePressed:(id)sender;
- (IBAction)repeatPressed:(id)sender;
- (IBAction)snoozPressed:(id)sender;

//add/sub
@property (weak, nonatomic) IBOutlet UIToolbar *addSub;
- (IBAction)setPressed:(id)sender;
- (IBAction)setDatePickerTimePressed:(id)sender;

//set time
- (IBAction)cellEditTimeChanged:(id)sender;

// other
- (IBAction)onCancelPressed:(id)sender;

@end
