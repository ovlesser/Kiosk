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

@interface OrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *customerField;
@property (weak, nonatomic) IBOutlet UITextField *postageField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
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
        self.items = [[order.item allObjects] mutableCopy];
        
        self.numberField.text = order.number;
        self.customerField.text = [NSString stringWithFormat:@"%@ %@", order.customer.name, order.customer.mobile];
        self.postageField.text = [order.postage stringValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.dateField.text = [dateFormatter stringFromDate:order.date];
        
        self.itemViewController.items = [[order.item allObjects] mutableCopy];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    { // init a date picker
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.dateField setInputView:self.datePicker];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
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
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(ShowSelectedCustomer)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.customerField setInputAccessoryView:toolBar];

        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kCustomerEntityName];
        self.customers = [context executeFetchRequest:request error:nil];
        NSLog(@"%@", self.customers);
    }
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    self.number = [self.numberField.text copy];
    self.postage = [[NSDecimalNumber decimalNumberWithString:self.postageField.text] copy];
    self.items = [self.itemViewController.items mutableCopy];
//    NSLog(@"savePressed %@", self.order);
    [self.masterViewController save];
}

- (IBAction)addPressed:(id)sender {
    [self.itemViewController insertNewObject:sender];
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
    self.customerField.text = [NSString stringWithFormat:@"%@ %@",
                               self.customer.name,
                               self.customer.mobile];
    [self.customerField resignFirstResponder];
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
    self.customer = self.customers[row];
    return [NSString stringWithFormat:@"%@ %@", self.customer.name, self.customer.mobile];
}
@end
