//
//  CellActions.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/23/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionViewCell.h"

@interface CellActions : NSObject

- (CollectionViewCell *) applyToTodoistCell: (CollectionViewCell *) cell index: (NSIndexPath *) indexPath;

@end
