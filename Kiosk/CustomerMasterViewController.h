//
//  MasterViewController.h
//  Kiosk
//
//  Created by ovlesser on 9/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class CustomerDetailViewController;

@interface CustomerMasterViewController : MasterViewController

@property (strong, nonatomic) CustomerDetailViewController *detailViewController;

@end

