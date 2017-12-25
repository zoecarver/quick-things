//
//  RepeatTableViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/23/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepeatTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UITableView *tableViewElement;
@property (nonatomic) NSInteger indexPassedDuringSegue;

@end
