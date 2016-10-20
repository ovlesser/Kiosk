//
//  SettingsViewController.h
//  Kiosk
//
//  Created by ovlesser on 17/10/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *sortTextField;
@property (weak, nonatomic) IBOutlet UISwitch *displaySoldOutProducts;
@property (strong, nonatomic) UIPickerView *sortPicker;
//@property (assign, nonatomic) BOOL isDisplaySoldOutProduct;

@property (nonatomic, strong) void (^onCompletion)(void);

@end
