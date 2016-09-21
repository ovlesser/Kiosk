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

@property (strong, nonatomic) Order *order;

@end
