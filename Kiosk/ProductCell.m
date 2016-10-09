//
//  ProductCellTableViewCell.m
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell ()

@end
@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name
{
    if (![name isEqualToString:_name]) {
        _name = [name copy];
    }
    self.nameLabel.text = _name;
}

-(void)setBrand:(NSString *)brand
{
    if (![brand isEqualToString:_brand]) {
        _brand = [brand copy];
    }
    self.brandLabel.text = _brand;
}

- (void)setVendor:(NSString *)vendor
{
    if (![vendor isEqualToString:_vendor]) {
        _vendor = [vendor copy];
    }
    self.vendorLabel.text = _vendor;
}

-(void)setPrice:(NSString *)price
{
    if (![price isEqualToString:_price]) {
        _price = [price copy];
    }
    self.priceLabel.text = _price;
}

-(void)setFormat:(NSString *)format
{
    if (![format isEqualToString:_format]) {
        _format = [format copy];
    }
    self.formatLabel.text = _format;
}

-(void)setDate:(NSString *)date
{
    if (![date isEqualToString:_date]) {
        _date = [date copy];
    }
    self.dateLabel.text = _date;
}

-(void)setCount:(NSString *)count
{
    if (![count isEqualToString:_count]) {
        _count = [count copy];
    }
    self.countLabel.text = _count;
}

-(void)setStock:(NSString *)stock
{
    if (![stock isEqualToString:_stock]) {
        _stock = [stock copy];
    }
    self.stockLabel.text = _stock;
}

@end
