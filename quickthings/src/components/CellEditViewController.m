//
//  CellEditViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/20/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CellEditViewController.h"
#import "CollectionViewController.h"

@interface CellEditViewController ()

@end

@implementation CellEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onCancelPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
