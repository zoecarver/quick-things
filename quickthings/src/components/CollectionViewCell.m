//
//  CollectionViewCell.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CollectionViewCell.h"
#import "DateModificationViewController.h"
#import "ViewController.h"
#import "CollectionViewController.h"
#import "CellEditViewController.h"

@implementation CollectionViewCell
@synthesize index = _index;

- (IBAction)cellButtonAction:(id)sender {
    NSLog(@"Button Pressed");
}

@end
