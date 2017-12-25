//
//  CollectionViewCell.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateModificationViewController.h"
#import "CellEditViewController.h"

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (nonatomic) NSUInteger index;

- (IBAction)cellButtonAction:(id)sender;
- (void) processDoubleTap:(UITapGestureRecognizer *)sender;

@end
