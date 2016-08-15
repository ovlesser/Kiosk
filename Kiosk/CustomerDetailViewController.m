//
//  DetailViewController.m
//  Kiosk
//
//  Created by ovlesser on 9/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "CustomerMasterViewController.h"

extern NSString * const kCustomerEntityName;
extern NSString * const kNameKey;
extern NSString * const kMobileKey;
extern NSString * const kIdentificationKey;
extern NSString * const kAddressKey;
extern NSString * const kNicknameKey;

@interface CustomerDetailViewController ()
@end

@implementation CustomerDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.nameField.text = [[self.detailItem valueForKey:kNameKey] description];
        self.addressField.text = [[self.detailItem valueForKey:kAddressKey] description];
        self.identificationField.text = [[self.detailItem valueForKey:kIdentificationKey] description];
        self.nicknameField.text = [[self.detailItem valueForKey:kNicknameKey] description];
        self.mobileField.text = [[self.detailItem valueForKey:kMobileKey] description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    [self.masterViewController save];
}

@end
