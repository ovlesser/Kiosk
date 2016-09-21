//
//  ProductCellTableViewCell.m
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *vendorLabel;
@property (strong, nonatomic) IBOutlet UILabel *volumeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockLabel;

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

-(void)setVolume:(NSString *)volume
{
    if (![volume isEqualToString:_volume]) {
        _volume = [volume copy];
    }
    self.volumeLabel.text = _volume;
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
