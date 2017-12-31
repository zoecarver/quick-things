//
//  FetchSmallUserSettings.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/25/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchSmallUserSettings : NSObject

- (void) setNumberOfNotificationsToSchedule:(NSInteger ) notificationsNumber;
- (NSInteger) fetchNumberOfNotificationsToSchedule;
- (void) setDefaultSnooz:(NSInteger ) snooz;
- (NSInteger) fetchDefaultSnooz;
- (void) setDoneColor:(BOOL ) color;
- (NSInteger) fetchDoneColor;
- (void) setTheme:(NSInteger ) theme;
- (NSInteger) fetchTheme;

@end
