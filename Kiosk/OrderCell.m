//
//  OrderCellTableViewCell.m
//  Kiosk
//
//  Created by ovlesser on 15/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "OrderCell.h"
#import "Customer.h"
#import "Item.h"
#import "Product.h"
#import "Order.h"

@interface OrderCell ()

@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UILabel *postageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
- (void)setNumber:(NSString *)number
{
    if (![number isEqualToString:_number]) {
        _number = [number copy];
    }
    self.numberLabel.text = _number;
}

-(void)setCustomer:(Customer *)customer
{
    if (![customer isEqual:_customer]) {
        _customer = customer;
    }
    self.customerLabel.text = [NSString stringWithFormat:@"%@ %@", _customer.name, _customer.mobile];
}

- (void)setItems:(NSSet<Item *> *)items
{
    if (![items isEqualToSet:_items]) {
        _items = items;
    }
    for (Item *item in items) {
        if (item.product && item.product.name) {
            self.itemLabel.text = [self.itemLabel.text stringByAppendingString:item.product.name];
            self.itemLabel.text = [self.itemLabel.text stringByAppendingString:@" "];
        }
    }
}

-(void)setPostage:(NSString *)postage
{
    if (![postage isEqual:_postage]) {
        _postage = [postage copy];
    }
    self.postageLabel.text = [_postage stringValue];
}

-(void)setDate:(NSString *)date
{
    if (![date isEqual:_date]) {
        _date = [date copy];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:_date];
}
*/
- (void)setOrder:(Order *)order
{
    if (![order isEqual:_order]) {
        _order = order;
    }
    self.numberLabel.text = _order.number;
    self.customerLabel.text = [NSString stringWithFormat:@"%@ %@", _order.customer.name, _order.customer.mobile];
    self.postageLabel.text = [_order.postage stringValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:_order.date];
    self.itemLabel.text = @"";
    for (Item *item in order.item) {
        if (item.product && item.product.name) {
            self.itemLabel.text = [self.itemLabel.text stringByAppendingString:item.product.name];
            self.itemLabel.text = [self.itemLabel.text stringByAppendingString:@" "];
        }
    }
}

@end
