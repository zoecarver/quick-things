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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DateModificationViewController *VC = (DateModificationViewController *) segue.destinationViewController;
    VC.delegate = self;
    
    NSLog(@"Prep...");
    
    [VC test];
}

- (IBAction)cellButtonAction:(id)sender {
    NSLog(@"Adding 5 minutes");
    
    DateModificationViewController *DVC =  [UIApplication sharedApplication].keyWindow.rootViewController;
    
    DVC.delegate = self;
    
    NSLog(@"testing");
    [DVC test];
    
//    NSDate *oldDate = [dateModificationViewControllerClass.datePickerAction date];
//    NSDate *newDate = [oldDate dateByAddingTimeInterval:5];
    
//    [dateModificationViewControllerClass.datePickerAction setDate:newDate];
//    dateModificationViewControllerClass.labelString = @"hello";
}

@end
