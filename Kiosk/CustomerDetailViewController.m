//
//  DetailViewController.m
//  Kiosk
//
//  Created by ovlesser on 9/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomerDetailViewController.h"
#import "CustomerMasterViewController.h"
#import "Customer.h"

extern NSString * const kCustomerEntityName;

@interface CustomerDetailViewController ()
@end

@implementation CustomerDetailViewController

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
        Customer *customer = self.detailItem;
        self.nameField.text = [customer.name description];
        self.addressField.text = [customer.address description];
        self.identificationField.text = [customer.identification description];
        self.nicknameField.text = [customer.nickname description];
        self.mobileField.text = [customer.mobile description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    NSManagedObjectContext *context = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kCustomerEntityName inManagedObjectContext:context];
    Customer *customer = self.detailItem;
    if (!customer) {
        customer = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    customer.name =  self.nameField.text;
    customer.mobile =  self.mobileField.text;
    customer.address = self.addressField.text;
    customer.identification = self.identificationField.text;
    customer.nickname = self.nicknameField.text;
    
    NSLog(@"%@", customer);
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.masterViewController save:customer];
    self.detailItem = customer;
    saveButton.tintColor = [UIColor blackColor];
}

- (IBAction)nameValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)mobileValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)identificationValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)addressValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
- (IBAction)nicknameValueChanged:(id)sender {
    saveButton.tintColor = [UIColor redColor];
}
@end
