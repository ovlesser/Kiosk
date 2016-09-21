//
//  ItemMasterViewController.h
//  Kiosk
//
//  Created by ovlesser on 17/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "MasterViewController.h"

@class Item;
@class OrderDetailViewController;

@interface ItemMasterViewController : MasterViewController

@property (strong, nonatomic) NSMutableArray<Item*> *items;

- (void)insertNewObject:(id)sender;

@property (strong, nonatomic) OrderDetailViewController *orderDetailViewController;
@end
