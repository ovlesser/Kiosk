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
#import "Product.h"
#import "SettingsViewController.h"

NSString *productCellIdentifier = @"productCell";
NSString * const kProductEntityName = @"Product";
extern NSString * const kDateKey;

@implementation ProductMasterViewController
{
    
    BOOL isDisplaySoldOutProduct;
    NSString *sortString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isDisplaySoldOutProduct = YES;
    sortString = kDateKey;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"setting" style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];;
    
    self.navigationItem.rightBarButtonItems = @[addButton, settingButton];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
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

- (void)settingsButtonPressed
{
    
    SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    controller.onCompletion = ^{
        isDisplaySoldOutProduct = controller.displaySoldOutProducts.isOn;
        sortString = controller.sortTextField.text;
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:^{
        [controller.displaySoldOutProducts setOn:isDisplaySoldOutProduct];
        [controller.sortTextField setText:sortString];
    }];
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.rightBarButtonItems[1];
//    popController.delegate = self;
}

- (void)save:(id)sender {
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
        //NSLog(@"%lu", (unsigned long)[sectionInfo numberOfObjects]);
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
#if 0
    cell.name = [object valueForKey:kName1Key];
    cell.brand = [object valueForKey:kBrandKey];
    cell.price = [NSString stringWithFormat:@"%@", [object valueForKey:kPriceKey]];
    cell.format = [[object valueForKey:kVolumeKey] stringValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    cell.date = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[object valueForKey:kDateKey]]];
    
    cell.vendor = [object valueForKey:kVendorKey];
    cell.count = [object valueForKey:kCountKey];
    cell.stock = [object valueForKey:kStockKey];
#else
    Product *product = (Product*)object;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    if (product.stock.integerValue < 0) {
        cell.nameLabel.textColor = [UIColor redColor];
    }
    else if (product.stock.integerValue == 0) {
        cell.nameLabel.textColor = [UIColor lightGrayColor];
    }
    else {
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    cell.name = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@",
                 product.name,
                 product.brand,
                 [product.price stringValue],
                 product.format,
                 [product.count stringValue],
                 [product.stock stringValue],
                 [dateFormatter stringFromDate:product.date],
                 product.vendor];
#endif
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (super.fetchedResultsController != nil) {
        return super.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    self.managedObjectContext = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:kProductEntityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kDateKey ascending:NO];
    if ([sortString isEqualToString:@"best selling"]) {
    }
    else {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortString ascending:NO];
    }
    
    if (!isDisplaySoldOutProduct) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(stock > 0)"];
        [fetchRequest setPredicate:predicate];
    }

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:kProductEntityName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kDateKey ascending:NO];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(name contains[cd] %@) OR (brand contains[cd] %@)", searchString, searchString];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:NO];
    [self.tableView reloadData];
}
@end
