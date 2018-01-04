//
//  DoneHandler.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 1/3/18.
//  Copyright © 2018 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateModificationViewController.h"

@interface DoneHandler : NSObject

+ (void) done:(DateModificationViewController *)sender forDate:(NSDate *)date andIndex:(NSInteger) index;

@end
