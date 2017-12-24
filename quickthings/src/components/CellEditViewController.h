//
//  CellEditViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/20/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellEditViewController : UIViewController

@property (nonatomic) NSInteger indexGotDuringSegue;

- (IBAction)onCancelPressed:(id)sender;

@end
