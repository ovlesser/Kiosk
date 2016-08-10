//
//  CustomerCell.m
//  Mullet
//
//  Created by ovlesser on 7/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "CustomerCell.h"

@interface CustomerCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *identificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;

@end
@implementation CustomerCell

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

-(void)setMobile:(NSString *)mobile
{
    if (![mobile isEqualToString:_mobile]) {
        _mobile = [mobile copy];
    }
    self.mobileLabel.text = _mobile;
}

- (void)setAddress:(NSString *)address
{
    if (![address isEqualToString:_address]) {
        _address = [address copy];
    }
    self.addressLabel.text = _address;
}

-(void)setIdentification:(NSString *)identification
{
    if (![identification isEqualToString:_identification]) {
        _identification = [identification copy];
    }
    self.identificationLabel.text = _identification;
}

-(void)setNickname:(NSString *)nickname
{
    if (![nickname isEqualToString:_nickname]) {
        _nickname = [nickname copy];
    }
    self.nicknameLabel.text = _nickname;
}

@end
