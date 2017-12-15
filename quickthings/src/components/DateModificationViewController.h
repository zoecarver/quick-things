//
//  DateModificationViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/15/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateModificationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *largeTimeDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallReminderDisplayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerAction;

- (IBAction)datePickerActionChanged:(id)sender;

@end
