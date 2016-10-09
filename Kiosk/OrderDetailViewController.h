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
@class Item;
@class Order;

@interface OrderDetailViewController : DetailViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIBarButtonItem *saveButton;
}
@property (copy, nonatomic) NSString *number;
@property (strong, nonatomic) Customer *customer;
@property (copy, nonatomic) NSDecimalNumber *postage;
@property (copy, nonatomic) NSDate *date;
@property (copy, nonatomic) NSDecimalNumber *exchangeRate;
@property (copy, nonatomic) NSDecimalNumber *sum;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *customerPicker;
@property (strong, nonatomic) NSArray<Customer *> *customers;

@property (strong, nonatomic) OrderMasterViewController *masterViewController;
@property (strong, nonatomic) ItemMasterViewController *itemViewController;

- (void)updateData;

@end
