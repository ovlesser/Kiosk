//
//  OrderDetailViewController.m
//  Kiosk
//
//  Created by ovlesser on 15/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderMasterViewController.h"
#import "ItemMasterViewController.h"
#import "Order.h"
#import "Customer.h"
#import "AppDelegate.h"

#import "Product.h"
#import "Item.h"

extern NSString * const kCustomerEntityName;
extern NSString * const kOrderEntityName;

@interface OrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *customerField;
@property (weak, nonatomic) IBOutlet UITextField *postageField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *exchangeRateField;
@property (weak, nonatomic) IBOutlet UITextField *sumField;
@property (weak, nonatomic) IBOutlet UITextField *profitField;
@property (weak, nonatomic) IBOutlet UITableView *itemTable;

@end

@implementation OrderDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (super.detailItem != newDetailItem) {
        super.detailItem = newDetailItem;
        
        // Update the view.
        //[self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        Order *order = (Order *)self.detailItem;
//        NSLog(@"configureView %@", self.order);
        self.number = order.number;
        self.customer = order.customer;
        self.postage = order.postage;
        self.date = order.date;
        self.exchangeRate = order.exchangeRate ? order.exchangeRate : [NSDecimalNumber decimalNumberWithString:@"5.0"];
        self.itemViewController.items = [[order.item allObjects] mutableCopy];
        [self updateData];
        
        self.numberField.text = order.number;
        self.customerField.text = [NSString stringWithFormat:@"%@ %@", order.customer.name, order.customer.mobile];
        self.postageField.text = [order.postage stringValue];
        self.exchangeRateField.text = [order.exchangeRate stringValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.dateField.text = [dateFormatter stringFromDate:order.date];
        
        self.itemViewController.items = [[order.item allObjects] mutableCopy];
    }
    else {
        self.postage = [NSDecimalNumber decimalNumberWithString:@"0.0"];
        self.exchangeRate = [NSDecimalNumber decimalNumberWithString:@"5.0"];
    }
    self.itemViewController.orderDetailViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    { // init a date picker
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.dateField setInputView:self.datePicker];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(ShowSelectedDate)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.dateField setInputAccessoryView:toolBar];
    }
    
    ItemMasterViewController *controller = [[ItemMasterViewController alloc] init];
    controller.tableView = self.itemTable;
    self.itemViewController = controller;
    controller.managedObjectContext = self.masterViewController.managedObjectContext;
    [self.itemTable setDelegate:controller];
    [self.itemTable setDataSource:controller];

    { // init customer picker
        self.customerPicker = [[UIPickerView alloc] init];
        self.customerPicker.delegate = self;
        self.customerPicker.dataSource = self;
        [self.customerField setInputView:self.customerPicker];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(ShowSelectedCustomer)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.customerField setInputAccessoryView:toolBar];

        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kCustomerEntityName];
        self.customers = [context executeFetchRequest:request error:nil];
//        NSLog(@"%@", self.customers);
    }
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    NSManagedObjectContext *context = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kOrderEntityName inManagedObjectContext:context];
    Order *order = self.detailItem;
    if (!order) {
        order = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    order.number = self.numberField.text;
    order.postage = [NSDecimalNumber decimalNumberWithString:self.postageField.text];
    order.exchangeRate = [NSDecimalNumber decimalNumberWithString:self.exchangeRateField.text];
    order.customer = self.customer;
    order.date = self.date;
    order.item = [NSSet setWithArray:self.itemViewController.items ];
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.masterViewController save:order];
    self.detailItem = order;
    saveButton.tintColor = [UIColor blackColor];
}

- (IBAction)addPressed:(id)sender {
    [self.itemViewController insertNewObject:sender];
    saveButton.tintColor = [UIColor redColor];
}

-(void)ShowSelectedDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateField.text = [dateFormatter stringFromDate:self.datePicker.date];
    self.date = [self.datePicker.date copy];
    [self.dateField resignFirstResponder];
}

-(void)ShowSelectedCustomer
{
    self.customer = self.customers[[self.customerPicker selectedRowInComponent:0]];
    self.customerField.text = [NSString stringWithFormat:@"%@ %@",
                               self.customer.name,
                               self.customer.mobile];
    [self.customerField resignFirstResponder];
}

- (void)updateData
{
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    NSDecimalNumber *profit = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    for (Item *item in self.itemViewController.items) {
        //NSLog(@"%@", item);
        //NSLog(@"%@", item.product);
        if (![item.price isEqualToNumber:[NSDecimalNumber notANumber]]
            && ![item.count isEqualToNumber:[NSDecimalNumber notANumber]]
            && ![self.exchangeRate isEqualToNumber:[NSDecimalNumber notANumber]]
            && item.product && ![item.product.price isEqualToNumber:[NSDecimalNumber notANumber]]) {
            sum = [sum decimalNumberByAdding:[item.price decimalNumberByMultiplyingBy:item.count]];
            profit = [profit decimalNumberByAdding:[[[item.price decimalNumberByDividingBy:self.exchangeRate withBehavior:roundUp]
                                                     decimalNumberBySubtracting:item.product.price]
                                                    decimalNumberByMultiplyingBy:item.count]];
        }
    }
    if (_postage && ![_postage isEqualToNumber:[NSDecimalNumber notANumber]]) {
        profit = [profit decimalNumberBySubtracting:self.postage];
    }
    self.sumField.text = [sum stringValue];
    self.profitField.text = [profit stringValue];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.customers count];
    
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    self.customer = self.customers[row];
    return [NSString stringWithFormat:@"%@ %@", self.customers[row].name, self.customers[row].mobile];
}

- (IBAction)exchangeRateValueChanged:(id)sender {
    _exchangeRate = [NSDecimalNumber decimalNumberWithString:self.exchangeRateField.text];
    [self.itemTable reloadData];
    [self updateData];
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)postageValueChanged:(id)sender {
    _postage = [NSDecimalNumber decimalNumberWithString:self.postageField.text];
    [self updateData];
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)numberValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)customerValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)dateValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)productValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)priceValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)countValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
@end
