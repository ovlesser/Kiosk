//
//  MasterViewController.h
//  Kiosk
//
//  Created by ovlesser on 9/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <OneDriveSDK/OneDriveSDK.h>
#import "MasterViewController.h"

@class CustomerDetailViewController;

@interface CustomerMasterViewController : MasterViewController

//@property (strong, nonatomic) ODClient *client;

@property (strong, nonatomic) CustomerDetailViewController *detailViewController;

@property NSMutableDictionary *items;

@property NSMutableArray *itemsLookup;

//@property ODItem *currentItem;

- (void)loadChildren;

@end

