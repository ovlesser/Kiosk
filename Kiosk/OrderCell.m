//
//  OrderCellTableViewCell.m
//  Kiosk
//
//  Created by ovlesser on 15/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "OrderCell.h"

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

- (void)setNumber:(NSString *)number
{
    if (![number isEqualToString:_number]) {
        _number = [number copy];
    }
    self.numberLabel.text = _number;
}

-(void)setCustomer:(NSString *)customer
{
    if (![customer isEqualToString:_customer]) {
        _customer = [customer copy];
    }
    self.customerLabel.text = _customer;
}

- (void)setItem:(NSString *)item
{
    if (![item isEqualToString:_item]) {
        _item = [item copy];
    }
    self.itemLabel.text = _item;
}

-(void)setPostage:(NSString *)postage
{
    if (![postage isEqualToString:_postage]) {
        _postage = [postage copy];
    }
    self.postageLabel.text = _postage;
}

-(void)setDate:(NSString *)date
{
    if (![date isEqualToString:_date]) {
        _date = [date copy];
    }
    self.dateLabel.text = _date;
}

@end
