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

- (void) processDoubleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Got tapped twice by the cell with index: %lu", sender.view.tag);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"I was double tapped");
        [((DateModificationViewController *) self.inputViewController) performSegueWithIdentifier:@"ShowCellEditMenu" sender:self.inputViewController];
    }
}

@end
