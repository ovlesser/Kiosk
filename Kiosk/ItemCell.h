//
//  ItemCell.h
//  Kiosk
//
//  Created by ovlesser on 17/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ItemCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (copy, nonatomic) NSString *product;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *count;

@property (strong, nonatomic) UIPickerView *productPicker;
@property (strong, nonatomic) NSArray<Product *> *productArray;
@property (strong, nonatomic) Product *productSelected;
@end
