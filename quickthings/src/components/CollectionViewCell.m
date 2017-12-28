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
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         // Set the original frame back
                         self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f];
                         
                         [self.layer setShadowColor:[[UIColor grayColor] CGColor]];
                         [self.layer setShadowRadius:5.0f];
                         [self.layer setShadowOffset:CGSizeMake(0 , 0)];
                         [self.layer setShadowOpacity:0.3f];
                     }
                     completion:^(BOOL finished) {
//                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//
//                         });
                         self.backgroundColor = [UIColor clearColor];
                         [self.layer setShadowColor:[[UIColor clearColor] CGColor]];
                     }];
}

- (void) processDoubleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Got tapped twice by the cell with index: %lu", sender.view.tag);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"I was double tapped");
        [((DateModificationViewController *) self.inputViewController) performSegueWithIdentifier:@"ShowCellEditMenu" sender:self.inputViewController];
    }
}

@end
