//
//  SnoozHandler.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/3/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DateModificationViewController.h"

@interface SnoozHandler : NSObject

+ (void) snooz:(DateModificationViewController *) sender withIndex:(NSInteger) index andDate:(NSDate *) date;

@end
