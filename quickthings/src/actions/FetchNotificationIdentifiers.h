//
//  FetchNotificationIdentifiers.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/2/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchNotificationIdentifiers : NSObject

- (void) schedule:(NSDate *) date forInde:(NSInteger) index;
- (void) removeNotification:(NSString *) toRemove;

@end
