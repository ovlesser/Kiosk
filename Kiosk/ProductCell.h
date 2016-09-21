//
//  ProductCellTableViewCell.h
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *brand;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *vendor;
@property (copy, nonatomic) NSString *volume;
@property (copy, nonatomic) NSString *count;
@property (copy, nonatomic) NSString *stock;

@end
