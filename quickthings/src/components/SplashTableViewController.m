//
//  SplashTableViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/31/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "SplashTableViewController.h"
#import "TableViewCell.h"
#import "FetchSmallUserSettings.h"
#import "ViewController.h"

@interface SplashTableViewController () {
    NSMutableArray *points;
}

@end

@implementation SplashTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Started");
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    points = [[NSMutableArray alloc] init];
    
    [points addObject:@"• Click ➕ to add reminders"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"Second passed");
        [points addObject:@"• Click the buttons to set time"];
        [self.tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSLog(@"Second passed");
            [points addObject:@"• Double click or 3d touch the buttons to customize them"];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"Second passed");
                [points addObject:@"• Swipe on reminders to complete them"];
                [self.tableView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSLog(@"Second passed");
                    [points addObject:@"Go"];
                    [self.tableView reloadData];
                });
            });
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [points count];
}

-(void) start {
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    [smallUserSettings setHasStartedBefore:YES];
    
    ViewController *parent = ((ViewController *) self.parentViewController);
    [parent performSegueWithIdentifier:@"start" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FetchSmallUserSettings *smallUserSettings = [[FetchSmallUserSettings alloc] init];
    
    if ([smallUserSettings fetchHasStartedBefore]) {
        ViewController *parent = ((ViewController *) self.parentViewController);
        [parent performSegueWithIdentifier:@"quickStart" sender:self];
    }
    
    TableViewCell *cell;
    NSString *item = points[indexPath.row];
    
    if ([item isEqualToString:@"Go"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellDone" forIndexPath:indexPath];
        [cell.cellButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.splashLabel.text = points[indexPath.row];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
@end
