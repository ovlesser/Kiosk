//
//  OrderMasterViewController.h
//  Kiosk
//
//  Created by ovlesser on 15/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "MasterViewController.h"

@class OrderDetailViewController;

@interface OrderMasterViewController : MasterViewController

@property (strong, nonatomic) OrderDetailViewController *detailViewController;

@end
