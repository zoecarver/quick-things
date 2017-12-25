//
//  RepeatTableViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/23/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "RepeatTableViewController.h"
#import "TableViewCell.h"

@interface RepeatTableViewController () {
    NSMutableArray *options;
}

@end

@implementation RepeatTableViewController

- (void)viewDidLoad {
    NSLog(@"Log loading");
    [super viewDidLoad];
    
    options = [[NSMutableArray alloc] init];
    
    [options addObject:@"Hourly"];
    [options addObject:@"Daily"];
    [options addObject:@"Weekly"];
    [options addObject:@"Monthly"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = options[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.cellButton.accessibilityAttributedLabel = [[NSMutableAttributedString alloc] initWithString:options[indexPath.row]];
    cell.cellButton.tag = indexPath.row;
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEvent: (UIButton *) sender {
    NSLog(@"Got %@", options[sender.tag]);
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


@end
