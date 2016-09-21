//
//  ProductDetailViewController.m
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductMasterViewController.h"

extern NSString * const kProductEntityName;
extern NSString * const kNameKey;
extern NSString * const kBrandKey;
extern NSString * const kVendorKey;
extern NSString * const kPriceKey;
extern NSString * const kDateKey;
extern NSString * const kVolumeKey;
extern NSString * const kCountKey;
extern NSString * const kStockKey;

@interface ProductDetailViewController ()
@end

@implementation ProductDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (super.detailItem != newDetailItem) {
        super.detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.nameField.text = [[self.detailItem valueForKey:kNameKey] description];
        self.brandField.text = [[self.detailItem valueForKey:kBrandKey] description];
        self.priceField.text = [[self.detailItem valueForKey:kPriceKey] stringValue];
        self.volumeField.text = [[self.detailItem valueForKey:kVolumeKey] stringValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.dateField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[self.detailItem valueForKey:kDateKey]]];

        self.vendorField.text = [[self.detailItem valueForKey:kVendorKey] description];
        self.countField.text = [[self.detailItem valueForKey:kCountKey] stringValue];
        self.stockField.text = [[self.detailItem valueForKey:kStockKey] stringValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.dateField setInputView:datePicker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateField setInputAccessoryView:toolBar];
    
    { // init customer picker
        countPicker = [[UIPickerView alloc] init];
        countPicker.delegate = self;
        countPicker.dataSource = self;
        [self.countField setInputView:countPicker];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedCount)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.countField setInputAccessoryView:toolBar];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    [self.masterViewController save];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 100;
    
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", (long)row];
}

-(void)showSelectedDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"dd/MMM/YYYY"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateField.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePicker.date]];
    [self.dateField resignFirstResponder];
}

- (void)showSelectedCount
{
    self.countField.text = [NSString stringWithFormat:@"%ld", (long)[countPicker selectedRowInComponent:0]];
    [self countValueChange:NULL];
    [self.countField resignFirstResponder];
}

- (IBAction)countValueChange:(id)sender {
    NSDecimalNumber *newCount = [NSDecimalNumber decimalNumberWithString:self.countField.text];
    NSDecimalNumber *currentCount = self.detailItem && [self.detailItem valueForKey:kCountKey]? [self.detailItem valueForKey:kCountKey] : [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *currentStock = self.detailItem && [self.detailItem valueForKey:kStockKey]? [self.detailItem valueForKey:kStockKey] : [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *newStock = [[currentStock decimalNumberByAdding:newCount] decimalNumberBySubtracting:currentCount];
    self.stockField.text = [newStock stringValue];
}
@end
