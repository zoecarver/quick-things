//
//  CellEditViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/20/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CellEditViewController.h"
#import "CollectionViewController.h"
#import "FetchSettings.h"
#import "FetchWebHook.h"
#import "DateModificationViewController.h"

@interface CellEditViewController () {
    NSMutableArray *settings;
    NSInteger i;
    Boolean currentlyAdding;
}

@end

@implementation CellEditViewController
@synthesize indexPassedDuringSegue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FetchSettings *fetchSettingsAction = [[FetchSettings alloc] init];
    settings = [fetchSettingsAction fetchSettings];
    
    i = self.indexPassedDuringSegue;
    
    NSLog(@"Got index during segue: %lu", self.indexPassedDuringSegue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)addPressed:(id)sender {
    currentlyAdding = YES;
    [self hideAll];
    self.addSub.hidden = NO;
}

- (IBAction)subtractPressed:(id)sender {
    currentlyAdding = NO;
    [self hideAll];
    self.addSub.hidden = NO;
}

- (IBAction)setTimePressed:(id)sender {
    [self hideAll];
    self.cellEditDatePicker.hidden = NO;
    self.setDatePicker.hidden = NO;
}

- (IBAction)preformActionPressed:(id)sender {
    [self hideAll];
    self.actionTwo.hidden = NO;
    self.actionOne.hidden = NO;
}

- (IBAction)markAsCompletePressed:(id)sender {
    settings[i] = @"Complete";
    [self saveSettings];
}

- (IBAction)createPressed:(id)sender {
    settings[i] = @"Todoist";
    
    FetchWebHook *fetchWebhookActions = [[FetchWebHook alloc] init];
    [fetchWebhookActions setWebHook:@""];
    
    [self saveSettings];
}

- (IBAction)setCancelPressed:(id)sender {
    settings[i] = @"Cancel";
    [self saveSettings];
}

- (IBAction)donePressed:(id)sender {
    settings[i] = @"Done";
    [self saveSettings];
}

- (IBAction)repeatPressed:(id)sender {
    settings[i] = @"Repeat";
    [self saveSettings];
}

- (IBAction)snoozPressed:(id)sender {
    settings[i] = @"Snooz";
    [self saveSettings];
}

- (IBAction)setPressed:(id)sender {
    settings[i] = currentlyAdding ? @([self.addSubInput.text integerValue]) : @(-[self.addSubInput.text integerValue]);
    [self saveSettings];
}

- (IBAction)setDatePickerTimePressed:(id)sender {
    settings[i] = self.cellEditDatePicker.date;
    [self saveSettings];
}

- (IBAction)onCancelPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) hideAll {
    self.actionOne.hidden = YES;
    self.actionTwo.hidden = YES;
    self.addSub.hidden = YES;
    self.cellEditDatePicker.hidden = YES;
    self.setDatePicker.hidden = YES;
}

- (void) saveSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:settings forKey:@"settings"];
    [userDefaults synchronize];
    
//    [self dismissViewControllerAnimated:true completion:nil];
    [self performSegueWithIdentifier:@"cancelEdit" sender:self];
}

@end
