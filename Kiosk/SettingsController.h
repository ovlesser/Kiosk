//
//  SettingsController.h
//  Kiosk
//
//  Created by ovlesser on 16/09/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import <OneDriveSDK/OneDriveSDK.h>

@interface SettingsController : MasterViewController

@property NSMutableDictionary *items;
@property NSMutableArray *itemsLookup;
@property (strong, nonatomic) ODClient *client;
@property ODItem *currentItem;

@end
