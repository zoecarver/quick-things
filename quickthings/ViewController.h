//
//  ViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/11/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)addReminderButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *reminderInputField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

