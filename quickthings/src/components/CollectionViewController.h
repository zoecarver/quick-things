//
//  CollectionViewController.h
//  quickthings
//
//  Created by Zoe IAMZOE.io on 12/14/17.
//  Copyright © 2017 Zoe IAMZOE.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewController;

@protocol CollectionViewDelegate <NSObject>

-(void) sendTest;

@end
@interface CollectionViewController : UICollectionViewController

@property (nonatomic, weak) id<CollectionViewDelegate> deligate;

@end
