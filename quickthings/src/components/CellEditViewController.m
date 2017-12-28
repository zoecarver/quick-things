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
    NSMutableArray *add;
    NSMutableArray *value;
    NSMutableArray *type;
}

@end

@implementation CellEditViewController
@synthesize indexPassedDuringSegue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FetchSettings *fetchSettingsAction = [[FetchSettings alloc] init];
    settings = [fetchSettingsAction fetchSettings];
    
    i = self.indexPassedDuringSegue;
    
    add = [[NSMutableArray alloc] initWithObjects:@"Add", @"Sub", nil];
    value = [[NSMutableArray alloc] init];
    type = [[NSMutableArray alloc] initWithObjects:@"Minute", @"Hour", @"Day", @"Week", nil];
    
    for (NSInteger i = 0; i < 60; i++) {
        [value addObject:[NSNumber numberWithInteger:i]];
    }
    
    self.AddSubPicker.delegate = self;
    self.AddSubPicker.showsSelectionIndicator = YES;
    
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
    self.AddSubPicker.hidden = NO;
    self.setAddSubPressed.hidden = NO;
}

- (IBAction)subtractPressed:(id)sender {
    currentlyAdding = NO;
    [self hideAll];
    self.AddSubPicker.hidden = NO;
    self.setAddSubPressed.hidden = NO;
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
    BOOL shouldBeAdding = [self.AddSubPicker selectedRowInComponent:0] == 0;
    NSInteger valueSelected = [self.AddSubPicker selectedRowInComponent:1];
    NSString *typeToMultiplyValueBy = type[[self.AddSubPicker selectedRowInComponent:2]];
    NSInteger returnValue = 0;
    
    if ([typeToMultiplyValueBy  isEqual: @"Minute"]) {
        returnValue = valueSelected;
    } else if ([typeToMultiplyValueBy  isEqual:  @"Hour"]) {
        returnValue = valueSelected * 60;
    } else if ([typeToMultiplyValueBy  isEqual: @"Day"]) {
        returnValue = valueSelected * 60 * 24;
    } else if ([typeToMultiplyValueBy  isEqual: @"Week"]) {
        returnValue = valueSelected * 60 * 24 * 7;
    }
    
    NSNumber *numberReturnValue = @(returnValue);
    
    if (shouldBeAdding) {
        settings[i] = numberReturnValue;
    } else {
        settings[i] = @(-numberReturnValue.doubleValue);
    }
    
    NSLog(@"Updating with %f", [settings[i] doubleValue]);
    
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
    self.AddSubPicker.hidden = YES;
    self.setAddSubPressed.hidden = YES;
}

- (void) saveSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:settings forKey:@"settings"];
    [userDefaults synchronize];
    
//    [self dismissViewControllerAnimated:true completion:nil];
    [self performSegueWithIdentifier:@"cancelEdit" sender:self];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    const int addCompontentInt = 0;
    const int valueComponentInt = 1;
    const int typeComponentInt = 2;
    
    switch (component) {
        case addCompontentInt:
            return [add count];
            break;
        case valueComponentInt:
            return [value count];
            break;
        case typeComponentInt:
            return [type count];
            break;
        default:
            return 0;
            break;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    const int addCompontentInt = 0;
    const int valueComponentInt = 1;
    const int typeComponentInt = 2;
    
    switch (component) {
        case addCompontentInt:
            return add[row];
            break;
        case valueComponentInt:
            return [NSString stringWithFormat:@"%lu", [value[row] integerValue]];
            break;
        case typeComponentInt:
            return type[row];
            break;
        default:
            return nil;
            break;
    }
}

@end
