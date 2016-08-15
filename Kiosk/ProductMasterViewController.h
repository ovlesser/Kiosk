//
//  ProductMasterViewCell.h
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ProductDetailViewController;


@interface ProductMasterViewController : UITableViewController
<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property (strong, nonatomic) ProductDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *searchFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)save;

@end
