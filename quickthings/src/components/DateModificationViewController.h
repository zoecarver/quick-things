//
//  DateModificationViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/15/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateModificationViewControllerDelegate <NSObject>
@end
@interface DateModificationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    id <DateModificationViewControllerDelegate> _delegate;
}
@property (nonatomic, strong) id delegate;

@property (weak, nonatomic) IBOutlet UILabel *largeTimeDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallReminderDisplayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerAction;

@property (strong, nonatomic) NSString *textPassedDuringSegue;
@property (nonatomic) NSInteger indexPassedDuringSegue;
@property (nonatomic) NSInteger cellIndexToPassDuringSegue;

//toolbar
@property (weak, nonatomic) IBOutlet UIToolbar *topToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

- (IBAction)donePressed:(id)sender;
- (IBAction)snoozPressed:(id)sender;
- (IBAction)repeatPressed:(id)sender;
- (IBAction)webHookPressed:(id)sender;
- (IBAction)checkPressed:(id)sender;

- (IBAction)datePickerActionChanged:(id)sender;
- (void) test: (NSDate *) date;

@end
