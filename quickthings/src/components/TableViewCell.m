//
//  TableViewCell.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/18/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "TableViewCell.h"
#import "FetchSmallUserSettings.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cellButton:(id)sender {
    NSLog(@"TableCellTouched");
}

- (IBAction)cellSwitchValChanged:(id)sender {
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    
    if (self.cellSwitch.isOn) {
        [smallUserSettings setDoneColor:YES];
    } else {
        [smallUserSettings setDoneColor:NO];
    }
}

@end
