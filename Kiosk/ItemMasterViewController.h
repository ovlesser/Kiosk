//
//  ItemMasterViewController.h
//  Kiosk
//
//  Created by ovlesser on 17/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "MasterViewController.h"

@class ItemDetailViewController;

@interface ItemMasterViewController : MasterViewController

@property (strong, nonatomic) ItemDetailViewController *detailViewController;

- (void)insertNewObject:(id)sender;

@end
