//
//  CollectionViewCell.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CollectionViewCell.h"
#import "DateModificationViewController.h"
#import "AppDelegate.h"

@implementation CollectionViewCell

- (IBAction)cellButtonAction:(id)sender {
    NSLog(@"Adding 5 minutes");
    
    DateModificationViewController *DVC =  [UIApplication sharedApplication].keyWindow.rootViewController;
    
    DVC.delegate = self;
    
    NSLog(@"testing");
    
    NSDate *oldDate = [DVC.datePickerAction date];
    NSDate *newDate = [oldDate dateByAddingTimeInterval:5 * 60];
    
    [DVC test:newDate];
}

@end
