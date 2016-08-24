//
//  ItemCell.m
//  Kiosk
//
//  Created by ovlesser on 17/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "ItemCell.h"
#import "AppDelegate.h"
#import "Product.h"
#import "Item.h"

extern NSString * const kProductEntityName;

@interface ItemCell ()

@property (strong, nonatomic) IBOutlet UITextField *productField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UITextField *countField;

@end

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.productPicker = [[UIPickerView alloc] init];
    self.productPicker.delegate = self;
    self.productPicker.dataSource = self;
    [self.productField setInputView:self.productPicker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(ShowSelectedProduct)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.productField setInputAccessoryView:toolBar];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kProductEntityName];
    self.products = [context executeFetchRequest:request error:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(Item *)item
{
    if (![item isEqual:_item]) {
        _item = item;
    }
    if (item.product) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.productField.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  _item.product.brand,
                                  _item.product.name,
                                  _item.product.price,
                                  [dateFormatter stringFromDate:_item.product.date]];
    }
    if (item.price) {
        self.priceField.text = [_item.price stringValue];
    }
    if (item.count) {
        self.countField.text = [_item.count stringValue];
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.products count];

}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    _item.product = self.products[row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [NSString stringWithFormat:@"%@ %@ %@ %@",
            _item.product.brand,
            _item.product.name,
            _item.product.price,
            [dateFormatter stringFromDate:_item.product.date]];
}

-(void)ShowSelectedProduct
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.productField.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                              _item.product.brand,
                              _item.product.name,
                              _item.product.price,
                              [dateFormatter stringFromDate:_item.product.date]];
    [self.productField resignFirstResponder];
}

- (IBAction)priceValueChanged:(id)sender {
    _item.price = [NSDecimalNumber decimalNumberWithString:self.priceField.text];
}
- (IBAction)countValueChanged:(id)sender
{
    _item.count = @([self.countField.text intValue]);
}
@end
