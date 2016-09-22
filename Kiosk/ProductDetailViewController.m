//
//  ProductDetailViewController.m
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "ProductMasterViewController.h"
#import "Product.h"

extern NSString * const kProductEntityName;

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
        Product *product = self.detailItem;
        self.nameField.text = [product.name description];
        self.brandField.text = [product.brand description];
        self.priceField.text = [product.price stringValue];
        self.volumeField.text = [product.volume stringValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.dateField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:product.date]];

        self.vendorField.text = [product.vendor description];
        self.countField.text = [product.count stringValue];
        self.stockField.text = [product.stock stringValue];
    }
}

- (void)addLeftBarButton{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    NSArray *items = @[saveButton];
    self.navigationItem.rightBarButtonItems = items;
    
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

    NSManagedObjectContext *context = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kProductEntityName inManagedObjectContext:context];
    Product *product = self.detailItem;
    if (!product) {
        product = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    product.name = self.nameField.text;
    product.brand = self.brandField.text;
    product.price = [NSDecimalNumber decimalNumberWithString:self.priceField.text];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    product.volume = [f numberFromString:self.volumeField.text];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    product.date = [dateFormatter dateFromString:self.dateField.text];
    
    product.vendor = self.vendorField.text;
    product.count = [NSDecimalNumber decimalNumberWithString:self.countField.text];
    product.stock = [NSDecimalNumber decimalNumberWithString:self.stockField.text];
    // Save the context.
    //NSManagedObjectContext *context = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    //NSLog(@"%@", product);
    [self.masterViewController save:product];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    Product *product = self.detailItem;
    NSDecimalNumber *newCount = [NSDecimalNumber decimalNumberWithString:self.countField.text];
    NSDecimalNumber *currentCount = self.detailItem && product.count? product.count : [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *currentStock = self.detailItem && product.stock? product.stock : [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *newStock = [[currentStock decimalNumberByAdding:newCount] decimalNumberBySubtracting:currentCount];
    self.stockField.text = [newStock stringValue];
}
@end
