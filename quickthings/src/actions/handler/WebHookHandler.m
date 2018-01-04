//
//  WebHookHandler.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/3/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import "WebHookHandler.h"
#import "FetchWebHook.h"
#import "FetchRembinders.h"
#import "CompleteReminder.h"
#import "DateModificationViewController.h"

@implementation WebHookHandler

- (void) webhook:(DateModificationViewController *) sender {
    FetchWebHook *fetchWebhookActions = [[FetchWebHook alloc] init];
    NSString *webHook = [fetchWebhookActions fetchWebHook];
    
    if (webHook && ![webHook isEqual: @""]) {
        [self sendToWebHook:webHook withSender:sender];
    } else {
        [self getWebHookWithAlert:sender];
//        [self alertHowToChangeWebHook];
    }
}

//- (void) alertHowToChangeWebHook {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Editing webhooks" message:@"If you need to change a webhook, edit the button and create a new webhook - this will re-prompt the webhook url input." preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:confirmAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

- (void) getWebHookWithAlert:(DateModificationViewController *) sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter the webhook attached to your zapier or ifttt recipy" message:@"Click help for more info" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Ender webhook url";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FetchWebHook *fetchWebhookActions = [[FetchWebHook alloc] init];
        NSString *textRecivedFromInput = [[alertController textFields][0] text];
        
        [self sendToWebHook:textRecivedFromInput withSender:sender];
        [fetchWebhookActions setWebHook:textRecivedFromInput];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Alert Canelled");
    }];
    [alertController addAction:cancelAction];
    [sender presentViewController:alertController animated:YES completion:nil];
}

- (void) sendToWebHook: (NSString *) webHookToSendTo withSender:(DateModificationViewController *) sender {
    FetchRembinders *fetchRemindersAction = [[FetchRembinders alloc] init];
    NSMutableArray *reminders = [fetchRemindersAction fetchRembinders];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:sender delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:webHookToSendTo];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [reminders[sender.indexPassedDuringSegue] title], @"reminder", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error! %@", error.description);
            return;
        } else {
            NSLog(@"Success suploading reminder!");
            
            CompleteReminder *completeReminderAction = [[CompleteReminder alloc] init];
            [completeReminderAction reminderToComplete:[sender indexPassedDuringSegue]];
            
            [sender performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
        }
    }];
    
    [postDataTask resume];
}

@end
