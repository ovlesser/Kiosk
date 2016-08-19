//
//  ProductDetailViewController.h
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@class ProductMasterViewController;

@interface ProductDetailViewController : DetailViewController {
    
    UIDatePicker *datePicker;
    
}

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *brandField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *volumeField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *vendorField;

@property (strong, nonatomic) ProductMasterViewController *masterViewController;

@end
