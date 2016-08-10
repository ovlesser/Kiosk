//
//  DetailViewController.h
//  Kiosk
//
//  Created by ovlesser on 9/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerMasterViewController;

@interface CustomerDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *identificationField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameField;

@property (strong, nonatomic) CustomerMasterViewController *masterViewController;

@end

