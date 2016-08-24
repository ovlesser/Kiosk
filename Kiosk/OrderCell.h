//
//  OrderCellTableViewCell.h
//  Kiosk
//
//  Created by ovlesser on 15/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Customer;
@class Order;
@class Item;

@interface OrderCell : UITableViewCell

//@property (copy, nonatomic) NSString *number;
//@property (strong, nonatomic) Customer *customer;
//@property (copy, nonatomic) NSDecimalNumber *postage;
//@property (copy, nonatomic) NSDate *date;
//@property (strong, nonatomic) NSSet<Item *> *items;
@property (strong, nonatomic) Order *order;

@end
