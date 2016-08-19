//
//  OrderCellTableViewCell.h
//  Kiosk
//
//  Created by ovlesser on 15/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *customer;
@property (copy, nonatomic) NSString *item;
@property (copy, nonatomic) NSString *postage;
@property (copy, nonatomic) NSString *date;

@end
