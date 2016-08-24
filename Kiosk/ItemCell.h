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

@interface ItemCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

//@property (strong, nonatomic) Product *product;
//@property (copy, nonatomic) NSDecimalNumber *price;
//@property (copy, nonatomic) NSNumber *count;

@property (strong, nonatomic) UIPickerView *productPicker;
@property (strong, nonatomic) NSArray<Product *> *products;

@property (strong, nonatomic) Item *item;

@end
