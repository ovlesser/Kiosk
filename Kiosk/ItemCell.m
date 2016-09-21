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
#import "ItemMasterViewController.h"
#import "OrderDetailViewController.h"

extern NSString * const kProductEntityName;

@interface ItemCell ()

@property (strong, nonatomic) IBOutlet UITextField *productField;
@property (strong, nonatomic) IBOutlet UITextField *costField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UITextField *countField;
@property (weak, nonatomic) IBOutlet UITextField *profitField;

@end

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    { // init product picker
        self.productPicker = [[UIPickerView alloc] init];
        self.productPicker.delegate = self;
        self.productPicker.dataSource = self;
        [self.productField setInputView:self.productPicker];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showSelectedProduct)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.productField setInputAccessoryView:toolBar];
        
    }
    { //init count picker
        self.countPicker = [[UIPickerView alloc] init];
        self.countPicker.delegate = self;
        self.countPicker.dataSource = self;
        [self.countField setInputView:self.countPicker];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showSelectedCount)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.countField setInputAccessoryView:toolBar];
    }
    
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
    [self updateData];
}

- (void)updateData
{
    NSLog(@"%@", _item);
    NSLog(@"%@", _item.product);
    if (![_item.price isEqualToNumber:[NSDecimalNumber notANumber]]
        && ![_item.count isEqualToNumber:[NSDecimalNumber notANumber]]
        && ![self.itemViewController.orderDetailViewController.exchangeRate isEqualToNumber:[NSDecimalNumber notANumber]]
        && _item.product
        && ![_item.product.price isEqualToNumber:[NSDecimalNumber notANumber]]) {
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           decimalNumberHandlerWithRoundingMode:NSRoundUp
                                           scale:2
                                           raiseOnExactness:NO
                                           raiseOnOverflow:NO
                                           raiseOnUnderflow:NO
                                           raiseOnDivideByZero:YES];
        self.profit =[[[_item.price decimalNumberByDividingBy:self.itemViewController.orderDetailViewController.exchangeRate withBehavior:roundUp]
                       decimalNumberBySubtracting:_item.product.price]
                      decimalNumberByMultiplyingBy:_item.count];
        self.profitField.text = [self.profit stringValue];
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
    if (pickerView == self.productPicker) {
        return [self.products count];
    }
    else if (pickerView == self.countPicker) {
        return self.item.product.stock.unsignedIntegerValue + self.item.count.unsignedIntegerValue;
    }
    else {
        return 0;
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.productPicker) {
        Product *product = self.products[row];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        return [NSString stringWithFormat:@"%@ %@ %@ %@",
                product.brand,
                product.name,
                product.price,
                [dateFormatter stringFromDate:product.date]];
    }
    else if (pickerView == self.countPicker) {
        return [NSString stringWithFormat:@"%ld", (long)row+1];
    }
    else {
        return @"";
    }
}

-(void)showSelectedProduct
{
    NSLog(@"%@", _item.product);
    NSLog(@"%@", self.products[[self.productPicker selectedRowInComponent:0]]);
    if (_item.product != self.products[[self.productPicker selectedRowInComponent:0]]) {
        _item.product.stock = [_item.product.stock decimalNumberByAdding:_item.count];
        _item.count = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.countField.text = [_item.count stringValue];
        _item.price = [NSDecimalNumber decimalNumberWithString:@"0.0"];
        self.priceField.text = [_item.price stringValue];
        _item.product = self.products[[self.productPicker selectedRowInComponent:0]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.productField.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  _item.product.brand,
                                  _item.product.name,
                                  _item.product.price,
                                  [dateFormatter stringFromDate:_item.product.date]];
        [self updateData];
        [self.itemViewController.orderDetailViewController updateData];
    }
    [self.productField resignFirstResponder];
}

- (void)showSelectedCount
{
    self.countField.text = [NSString stringWithFormat:@"%ld", (long)[self.countPicker selectedRowInComponent:0]+1];
    [self countValueChanged:NULL];
    [self.countField resignFirstResponder];
}

- (IBAction)priceValueChanged:(id)sender {
    _item.price = [NSDecimalNumber decimalNumberWithString:self.priceField.text];
    [self updateData];
    [self.itemViewController.orderDetailViewController updateData];
}
- (IBAction)countValueChanged:(id)sender
{
    NSLog(@"%@, %@", _item.product.stock, _item.count);
    _item.product.stock = [_item.product.stock decimalNumberByAdding:_item.count];
    _item.count = [NSDecimalNumber decimalNumberWithString:self.countField.text];
    [self updateData];
    [self.itemViewController.orderDetailViewController updateData];
    NSLog(@"%@, %@", _item.product.stock, _item.count);
    _item.product.stock = [_item.product.stock decimalNumberBySubtracting:_item.count];
}
@end
