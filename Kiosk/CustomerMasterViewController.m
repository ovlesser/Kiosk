//
//  MasterViewController.m
//  Kiosk
//
//  Created by ovlesser on 9/08/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "CustomerMasterViewController.h"
#import "CustomerDetailViewController.h"
#import "CustomerCell.h"
#import "AppDelegate.h"

NSString *customerCellIdentifier = @"customerCell";
NSString * const kCustomerEntityName = @"Customer";
NSString * const kNameKey = @"name";
NSString * const kMobileKey = @"mobile";
NSString * const kIdentificationKey = @"identification";
NSString * const kAddressKey = @"address";
NSString * const kNicknameKey = @"nickname";


@interface CustomerMasterViewController ()

@end

@implementation CustomerMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    

    UITableView *tableView = (id)[self.view viewWithTag:1];
//    [tableView registerClass:[CustomerCell class] forCellReuseIdentifier:customerCellIdentifier];
    tableView.rowHeight = 94;
    
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;
    [tableView setContentInset:contentInset];
    
    self.searchDisplayController.searchResultsTableView.rowHeight = tableView.rowHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [NSFetchedResultsController deleteCacheWithName:@"Customer"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"customerDetailNavigation"];
    self.detailViewController = (CustomerDetailViewController *)[navigationController topViewController];
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
    [newManagedObject setValue:self.detailViewController.nameField.text forKey:kNameKey];
    [newManagedObject setValue:self.detailViewController.mobileField.text forKey:kMobileKey];
    [newManagedObject setValue:self.detailViewController.addressField.text forKey:kAddressKey];
    [newManagedObject setValue:self.detailViewController.identificationField.text forKey:kIdentificationKey];
    [newManagedObject setValue:self.detailViewController.nicknameField.text forKey:kNicknameKey];
    
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
        self.detailViewController = (CustomerDetailViewController *)[[segue destinationViewController] topViewController];
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
//    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:customerCellIdentifier forIndexPath:indexPath];
    
    CustomerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:customerCellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customerCellIdentifier];
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

- (void)configureCell:(CustomerCell *)cell withObject:(NSManagedObject *)object {
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    cell.name = [object valueForKey:kNameKey];
    cell.mobile = [object valueForKey:kMobileKey];
    cell.identification = [object valueForKey:kIdentificationKey];
    cell.address = [object valueForKey:kAddressKey];
    cell.nickname = [object valueForKey:kNicknameKey];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (super.fetchedResultsController != nil) {
        return super.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:kCustomerEntityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kNameKey ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Customer"];
    aFetchedResultsController.delegate = self;
    super.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![super.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return super.fetchedResultsController;
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:kCustomerEntityName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kNameKey ascending:NO];
        
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
