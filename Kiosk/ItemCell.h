//
//  ItemCell.h
//  Kiosk
//
//  Created by ovlesser on 17/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;
@class Item;
@class ItemMasterViewController;

@interface ItemCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *productPicker;
@property (strong, nonatomic) UIPickerView *countPicker;
@property (strong, nonatomic) NSArray<Product *> *products;

@property (strong, nonatomic) Item *item;
@property (strong, nonatomic) NSDecimalNumber *profit;

@property (strong, nonatomic) ItemMasterViewController *itemViewController;
@end
