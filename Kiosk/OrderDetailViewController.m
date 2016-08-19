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
#import "Customer.h"
#import "AppDelegate.h"

extern NSString * const kCustomerEntityName;
extern NSString * const kOrderEntityName;
extern NSString * const kNumberKey;
extern NSString * const kCustomerKey;
extern NSString * const kItemKey;
extern NSString * const kPostageKey;
extern NSString * const kDate1Key;

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

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
        self.numberField.text = [[self.detailItem valueForKey:kNumberKey] description];
        self.customerField.text = [[self.detailItem valueForKey:kCustomerKey] description];
        self.postageField.text = [[self.detailItem valueForKey:kPostageKey] stringValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.dateField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[self.detailItem valueForKey:kDate1Key]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    { // init a date picker
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [self.dateField setInputView:datePicker];
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
    
//    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"itemMasterNavigation"];
//    MasterViewController *controller = (MasterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"itemMasterViewController"];
//    [navigationController addChildViewController:controller];
//    navigationController = controller;
//    navigationController.view.frame = CGRectMake(self.dateLabel.frame.origin.x,
//                                                 self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + 20,
//                                                 self.dateField.frame.origin.x + self.dateField.frame.size.width - self.dateLabel.frame.origin.x,
//                                                 self.view.frame.origin.y + self.view.frame.size.height - 20 - (self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + 20));
//    navigationController.view.backgroundColor = [UIColor blueColor];
//    [navigationController.view setNeedsLayout];
//    [self addChildViewController:navigationController];
//    [self.view addSubview:navigationController.view];

    ItemMasterViewController *controller = [[ItemMasterViewController alloc] init];
    controller.tableView = self.itemTable;
    self.itemViewController = controller;
    controller.managedObjectContext = self.masterViewController.managedObjectContext;
    [self.itemTable setDelegate:controller];
    [self.itemTable setDataSource:controller];

    { // init customer picker
        self.customerPicker = [[UIPickerView alloc] init];
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
        self.customerArray = [context executeFetchRequest:request error:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    [self.masterViewController save];
}

- (IBAction)addPressed:(id)sender {
    [self.itemViewController insertNewObject:sender];
}

-(void)ShowSelectedDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"dd/MMM/YYYY"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateField.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePicker.date]];
    [self.dateField resignFirstResponder];
}

-(void)ShowSelectedCustomer
{
    self.customerField.text = [NSString stringWithFormat:@"%@ %@",
                               self.customerSelected.name,
                               self.customerSelected.mobile];
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
    return [self.customerArray count];
    
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Customer *customer = self.customerArray[row];
    self.customerSelected = customer;
    return [NSString stringWithFormat:@"%@ %@", customer.name, customer.mobile];
}
@end
