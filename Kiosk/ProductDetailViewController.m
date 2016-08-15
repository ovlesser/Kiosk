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
extern NSString * const kName1Key;
extern NSString * const kBrandKey;
extern NSString * const kVendorKey;
extern NSString * const kPriceKey;
extern NSString * const kDateKey;
extern NSString * const kVolumeKey;

@interface ProductDetailViewController ()
@end

@implementation ProductDetailViewController

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
        self.nameField.text = [[self.detailItem valueForKey:kName1Key] description];
        self.brandField.text = [[self.detailItem valueForKey:kBrandKey] description];
        self.priceField.text = [[self.detailItem valueForKey:kPriceKey] stringValue];
        self.volumeField.text = [[self.detailItem valueForKey:kVolumeKey] stringValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.dateField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[self.detailItem valueForKey:kDateKey]]];

        self.vendorField.text = [[self.detailItem valueForKey:kVendorKey] description];
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
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateField setInputAccessoryView:toolBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(id)sender {
    [self.masterViewController save];
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

@end
