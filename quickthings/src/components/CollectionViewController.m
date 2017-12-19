//
//  CollectionViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "CollectionViewController.h"
#import "FetchSettings.h"
#import "CollectionViewCell.h"

@interface CollectionViewController () {
    FetchSettings *fetchSettingsAction;
    NSMutableArray *settings;
}

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    fetchSettingsAction = [[FetchSettings alloc] init];
    settings = [fetchSettingsAction fetchSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [settings count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    if ([settings[indexPath.row] intValue]) {
        return [self applyToAddCell:cell index:indexPath];
    } else {
        return [self applyToDoneCell:cell index:indexPath];
    }
}

- (CollectionViewCell *) applyToDoneCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    cell.cellLabel.text = @"Done";
    
    cell.layer.cornerRadius = 25;
    
    cell.backgroundColor = [UIColor grayColor];
    
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEventDone) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CollectionViewCell *) applyToAddCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath {
    NSNumber *tmpSettinsItem = settings[indexPath.row];
    NSInteger settingsItem = [tmpSettinsItem intValue];
    
    cell.cellLabel.text = [NSString stringWithFormat:@"+%lu", settingsItem];
    cell.layer.cornerRadius = 25;
    
    cell.backgroundColor = [UIColor grayColor];
    
    cell.layoutMargins = UIEdgeInsetsZero; // remove table cell separator margin
    [cell.cellButton setTag: settingsItem];
    [cell.cellButton addTarget:self action:@selector(handleTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) handleTouchUpEventDone {
    [((DateModificationViewController *) self.parentViewController) performSegueWithIdentifier:@"ShowAllRemindersView" sender:self];
    NSLog(@"Done");
}

- (void) handleTouchUpEvent: (UIButton *) sender {
    NSLog(@"Adding %lu minutes", sender.tag);
    
    DateModificationViewController *DVC = ((DateModificationViewController *) self.parentViewController);
    
    DVC.delegate = self;
        
    NSDate *oldDate = [DVC.datePickerAction date];
    NSDate *newDate = [oldDate dateByAddingTimeInterval:sender.tag * 60];
    
    [DVC test:newDate];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"Hello");
}

@end
