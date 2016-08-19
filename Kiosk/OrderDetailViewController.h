//
//  OrderDetailViewController.h
//  Kiosk
//
//  Created by ovlesser on 15/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "DetailViewController.h"

@class OrderMasterViewController;
@class ItemMasterViewController;
@class Customer;

@interface OrderDetailViewController : DetailViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    UIDatePicker *datePicker;
    
}

@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *customerField;
@property (weak, nonatomic) IBOutlet UITextField *postageField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITableView *itemTable;

@property (strong, nonatomic) UIPickerView *customerPicker;
@property (strong, nonatomic) NSArray<Customer *> *customerArray;
@property (strong, nonatomic) Customer *customerSelected;

@property (strong, nonatomic) OrderMasterViewController *masterViewController;
@property (strong, nonatomic) ItemMasterViewController *itemViewController;

@end
