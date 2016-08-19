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
    [self.productField setInputView:self.productPicker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedProduct)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.productField setInputAccessoryView:toolBar];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kProductEntityName];
    self.productArray = [context executeFetchRequest:request error:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(NSString *)product
{
    if (![product isEqualToString:_product]) {
        _product = [product copy];
    }
    self.productField.text = _product;
}

-(void)setPrice:(NSString *)price
{
    if (![price isEqualToString:_price]) {
        _price = [price copy];
    }
    self.priceField.text = _price;
}

- (void)setCount:(NSString *)count
{
    if (![count isEqualToString:_count]) {
        _count = [count copy];
    }
    self.countField.text = _count;
}

-(void)ShowSelectedProduct
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.productField.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                              self.productSelected.brand,
                              self.productSelected.name,
                              self.productSelected.price,
                              [dateFormatter stringFromDate:self.productSelected.date]];
    [self.productField resignFirstResponder];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.productArray count];

}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.productSelected = self.productArray[row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [NSString stringWithFormat:@"%@ %@ %@ %@",
            self.productSelected.brand,
            self.productSelected.name,
            self.productSelected.price,
            [dateFormatter stringFromDate:self.productSelected.date]];
}
@end
