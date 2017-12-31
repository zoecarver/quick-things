//
//  RepeatViewController.m
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/24/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import "RepeatViewController.h"
#import "ApplyDarkTheme.h"

@interface RepeatViewController () {
    ApplyDarkTheme *applyTheme;
}

@end

@implementation RepeatViewController
@synthesize indexPassedDuringSegue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    applyTheme = [[ApplyDarkTheme alloc] init];
    [applyTheme viewController:self];
    
    NSLog(@"Log loading with index %lu", self.indexPassedDuringSegue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
