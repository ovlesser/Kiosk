//
//  SettingsViewController.m
//  Kiosk
//
//  Created by ovlesser on 17/10/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (strong, nonatomic) NSArray *sortLists;
//@property (assign, nonatomic) NSInteger sortSelected;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sortLists = @[@"date", @"name", @"brand", @"count"];
    self.sortPicker = [[UIPickerView alloc] init];
    self.sortPicker.delegate = self;
    self.sortPicker.dataSource = self;
    [self.sortTextField setInputView:self.sortPicker];
    self.sortTextField.text = self.sortLists[0];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(showSelectedSort)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.sortTextField setInputAccessoryView:toolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)donePressed:(id)sender {
    if (self.onCompletion) {
        self.onCompletion();
    }
}
- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)displaySoldOutProductsValueChanged:(UISwitch*)sender {
//    self.isDisplaySoldOutProduct = sender.isOn;
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.sortLists count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    self.sortSelected = row;
    [self.sortTextField setText:self.sortLists[row]];
    return self.sortLists[row];
}

-(void)showSelectedSort
{
//    self.sortTextField.text = self.sortLists[self.sortSelected];
    [self.sortTextField resignFirstResponder];
}
@end
