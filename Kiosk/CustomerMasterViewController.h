//
//  MasterViewController.h
//  Kiosk
//
//  Created by ovlesser on 9/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

static NSString * const kCustomerEntityName = @"Customer";
static NSString * const kNameKey = @"name";
static NSString * const kMobileKey = @"mobile";
static NSString * const kIdentificationKey = @"identification";
static NSString * const kAddressKey = @"address";
static NSString * const kNicknameKey = @"nickname";

@class CustomerDetailViewController;

@interface CustomerMasterViewController : UITableViewController
<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property (strong, nonatomic) CustomerDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *searchFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)save;

@end

