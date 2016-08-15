//
//  ProductMasterViewCell.m
//  Kiosk
//
//  Created by ovlesser on 12/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "ProductMasterViewController.h"
#import "ProductDetailViewController.h"
#import "ProductCell.h"
#import "AppDelegate.h"

NSString *productCellIdentifier = @"productCell";
NSString * const kProductEntityName = @"Product";
NSString * const kName1Key = @"name";
NSString * const kBrandKey = @"brand";
NSString * const kVendorKey = @"vendor";
NSString * const kPriceKey = @"price";
NSString * const kDateKey = @"date";
NSString * const kVolumeKey = @"volume";

@implementation ProductMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    //UITableView *tableView = (id)[self.view viewWithTag:1];
    //tableView.rowHeight = 94;
    
    //UIEdgeInsets contentInset = tableView.contentInset;
    //contentInset.top = 20;
    //[tableView setContentInset:contentInset];
    
    //self.searchDisplayController.searchResultsTableView.rowHeight = tableView.rowHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailNavigation"];
    self.detailViewController = (ProductDetailViewController *)[navigationController topViewController];
    self.detailViewController.masterViewController = self;
    [self.detailViewController setDetailItem:nil];
    [self.navigationController pushViewController:navigationController animated:YES];
}

- (void)save {
    NSManagedObjectContext *context = nil;
    NSEntityDescription *entity = nil;
    if ([self.searchDisplayController isActive]) {
        context = [self.searchFetchedResultsController managedObjectContext];
        entity = [[self.searchFetchedResultsController fetchRequest] entity];
    }
    else {
        context = [self.fetchedResultsController managedObjectContext];
        entity = [[self.fetchedResultsController fetchRequest] entity];
    }
    NSManagedObject *newManagedObject = self.detailViewController.detailItem;
    if (!newManagedObject) {
        newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:self.detailViewController.nameField.text forKey:kName1Key];
    [newManagedObject setValue:self.detailViewController.brandField.text forKey:kBrandKey];
    [newManagedObject setValue:[NSDecimalNumber decimalNumberWithString:self.detailViewController.priceField.text] forKey:kPriceKey];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [newManagedObject setValue:[f numberFromString:self.detailViewController.volumeField.text] forKey:kVolumeKey];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [newManagedObject setValue:[dateFormatter dateFromString:self.detailViewController.dateField.text] forKey:kDateKey];

    [newManagedObject setValue:self.detailViewController.vendorField.text forKey:kVendorKey];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (![self.searchDisplayController isActive]) {
        [self.tableView reloadData];
    }
    else {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = nil;
        NSManagedObject *object = nil;
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            object = [[self searchFetchedResultsController] objectAtIndexPath:indexPath];
        }
        else {
            indexPath = [self.tableView indexPathForSelectedRow];
            object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        }
        self.detailViewController = (ProductDetailViewController *)[[segue destinationViewController] topViewController];
        self.detailViewController.masterViewController =self;
        [self.detailViewController setDetailItem:object];
        self.detailViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.detailViewController.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.searchDisplayController isActive]) {
        return [[self.searchFetchedResultsController sections] count];
    }
    else {
        return [[self.fetchedResultsController sections] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchDisplayController isActive]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.searchFetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
    else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:productCellIdentifier];
    
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productCellIdentifier];
    }
    
    NSManagedObject *object = nil;
    if ([self.searchDisplayController isActive]) {
        object = [[self searchFetchedResultsController] objectAtIndexPath:indexPath];
    }
    else {
        object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    }
    [self configureCell:cell withObject:object];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.searchDisplayController isActive]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
            NSError *error = nil;
            if (![context save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}

- (void)configureCell:(ProductCell *)cell withObject:(NSManagedObject *)object {
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    cell.name = [object valueForKey:kName1Key];
    cell.brand = [object valueForKey:kBrandKey];
    cell.price = [NSString stringWithFormat:@"%@", [object valueForKey:kPriceKey]];
    cell.volume = [[object valueForKey:kVolumeKey] stringValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    cell.date = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[object valueForKey:kDateKey]]];
    
    cell.vendor = [object valueForKey:kVendorKey];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:kProductEntityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kName1Key ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Product"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (![self.searchDisplayController isActive]) {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (![self.searchDisplayController isActive]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            default:
                return;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (![self.searchDisplayController isActive]) {
        UITableView *tableView = self.tableView;
        
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (![self.searchDisplayController isActive]) {
        [self.tableView endUpdates];
    }
}

- (BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (self.searchFetchedResultsController) {
        self.searchFetchedResultsController = nil;
    }
    if (searchString.length > 0) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:kProductEntityName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kName1Key ascending:NO];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(name contains[cd] %@)", searchString];
        [fetchRequest setPredicate:predicate];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.searchFetchedResultsController = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.searchFetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return YES;
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */
@end