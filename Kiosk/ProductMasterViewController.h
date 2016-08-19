//
//  ProductMasterViewCell.h
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class ProductDetailViewController;

@interface ProductMasterViewController : MasterViewController

@property (strong, nonatomic) ProductDetailViewController *detailViewController;

@end
