//
//  SettingsController.m
//  Kiosk
//
//  Created by ovlesser on 16/09/2016.
//  Copyright © 2016 ovlesser. All rights reserved.
//

#import "SettingsController.h"
#import "ProgressViewController.h"

@interface SettingsController ()

@property UIBarButtonItem *signIn;
@property UIBarButtonItem *actions;
@property (strong, nonatomic) void(^itemSaveCompletion)(ODItem *item);
@property ProgressViewController *progressController;

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableDictionary dictionary];
    self.itemsLookup = [NSMutableArray array];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.progressController = [[ProgressViewController alloc] initWithParentViewController:self];

    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.alwaysBounceVertical = YES;
    
    self.actions = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectActionButton:)];
    if (!self.client){
        self.client = [ODClient loadCurrentClient];
    }
    if (!self.currentItem){
        self.title = @"OneDrive";
    }
    
    self.signIn = [[UIBarButtonItem alloc] initWithTitle:@"Sign in" style:UIBarButtonItemStylePlain target:self action:@selector(signInAction)];
    self.navigationItem.rightBarButtonItem = self.signIn;
    if (self.client){
        self.navigationItem.rightBarButtonItem = self.actions;
        [self loadChildren];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [self loadChildren];
}

- (void)signInAction
{
    [ODClient authenticatedClientWithCompletion:^(ODClient *client, NSError *error){
        if (!error){
            self.client = client;
            [self loadChildren];
            dispatch_async(dispatch_get_main_queue(), ^(){
                self.navigationItem.rightBarButtonItem = self.actions;
            });
        }
        else{
            [self showErrorAlert:error];
        }
    }];
}

- (void)signOutAction
{
    [self.client signOutWithCompletion:^(NSError *signOutError){
        self.items = nil;
        self.items = [NSMutableDictionary dictionary];
        self.itemsLookup = nil;
        self.itemsLookup = [NSMutableArray array];
        self.client = nil;
        self.currentItem = nil;
        self.title = @"OneDrive";
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.navigationItem.hidesBackButton = YES;
            self.navigationItem.rightBarButtonItem = self.signIn;
            // Reload from main thread
            [self.tableView reloadData];
        });
    }];
}

- (void)loadChildren
{
    NSString *itemId = (self.currentItem) ? self.currentItem.id : @"root";
    ODChildrenCollectionRequest *childrenRequest = [[[[self.client drive] items:itemId] children] request];
    if (![self.client serviceFlags][@"NoThumbnails"]){
        [childrenRequest expand:@"thumbnails"];
    }
    [self loadChildrenWithRequest:childrenRequest];
}

- (void)onLoadedChildren:(NSArray *)children
{
    if (self.refreshControl.isRefreshing){
        [self.refreshControl endRefreshing];
    }
    [children enumerateObjectsUsingBlock:^(ODItem *item, NSUInteger index, BOOL *stop){
        if (![self.itemsLookup containsObject:item.id]){
            [self.itemsLookup addObject:item.id];
        }
        self.items[item.id] = item;
    }];
    //    [self loadThumbnails:children];
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.tableView reloadData];
    });
}

- (void)loadChildrenWithRequest:(ODChildrenCollectionRequest*)childrenRequests
{
    [childrenRequests getWithCompletion:^(ODCollection *response, ODChildrenCollectionRequest *nextRequest, NSError *error){
        if (!error){
            if (response.value){
                [self onLoadedChildren:response.value];
            }
            if (nextRequest){
                [self loadChildrenWithRequest:nextRequest];
            }
        }
        else if ([error isAuthenticationError]){
            [self showErrorAlert:error];
            [self onLoadedChildren:@[]];
        }
    }];
}

- (ODItem *)itemForIndex:(NSIndexPath *)indexPath
{
    NSString *itemId = self.itemsLookup[indexPath.row];
    return self.items[itemId];
}

#pragma mark - Table view data source

- (SettingsController *)settingsViewWithItem:(ODItem *)item;
{
    SettingsController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsController"];
    newController.title = item.name;
    newController.currentItem = item;
    newController.client = self.client;
    return newController;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsLookup count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block ODItem *item = [self itemForIndex:indexPath];
    if (item.folder){
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.navigationController pushViewController:[self settingsViewWithItem:item] animated:YES];
        });
    }
    else if (item.file){
        ODURLSessionDownloadTask *task = [[[[self.client drive] items:item.id] contentRequest] downloadWithCompletion:^(NSURL *filePath, NSURLResponse *response, NSError *error){
            [self.progressController hideProgress];
            if (!error) {
                if ([item.file.mimeType isEqualToString:@"application/octet-stream"]
                    && [[[NSURL URLWithString:item.name] pathExtension] isEqualToString:@"sqlite"]) {
                    NSString *documentUrl = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    NSString *newFileName = [NSString stringWithFormat:@"%@.sqlite", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
                    NSString* newFileUrl = [documentUrl stringByAppendingPathComponent:newFileName];
                    [[NSFileManager defaultManager] removeItemAtPath:newFileUrl error:nil];
                    [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:newFileUrl] error:nil];
                }
            }
            else{
                [self showErrorAlert:error];
            }
        }];
        task.progress.totalUnitCount = item.size;
        [self.progressController showProgressWithTitle:[NSString stringWithFormat:@"Downloading %@", item.name] progress:task.progress];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODItem *item = [self itemForIndex:indexPath];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell.textLabel setText:item.name];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Action Methods

- (IBAction)didSelectActionButton:(UIBarButtonItem*)actionButton
{
    UIAlertController *folderActions = [UIAlertController alertControllerWithTitle:@"Actions!"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *uploadFile = [UIAlertAction actionWithTitle:@"Upload Database File" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self uploadDatabase];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    
    [folderActions addAction:uploadFile];
    [folderActions addAction:cancel];
    [folderActions popoverPresentationController].barButtonItem = actionButton;
    [self presentViewController:folderActions animated:YES completion:nil];
}

- (void)uploadDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentURL = [fileManager URLForDirectory:NSDocumentDirectory
                                             inDomain:NSUserDomainMask
                                    appropriateForURL:nil
                                               create:NO
                                                error:nil];
    NSArray *fileUrls = [fileManager contentsOfDirectoryAtURL:documentURL
                                   includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey, NSURLIsDirectoryKey, NSURLContentModificationDateKey, nil]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (NSURL *fileUrl in fileUrls) {
        if ([[fileUrl pathExtension] isEqualToString:@"sqlite"]) {
            NSURL *backupUrl = fileUrl;
            NSString *itemId = (self.currentItem) ? self.currentItem.id : @"root";
            ODItemContentRequest *contentRequest = [[[[self.client drive] items:itemId] itemByPath:[backupUrl lastPathComponent]] contentRequest];
            NSLog(@"%@", backupUrl);
            [self uploadContentRequest:contentRequest fromFile:backupUrl];
            break;
        }
    }
    
}

- (void)uploadContentRequest:(ODItemContentRequest*)contentRequest fromFile:(NSURL *)url
{
    ODURLSessionUploadTask *task = [contentRequest uploadFromFile:url completion:^(ODItem *item, NSError *error){
        [self showUploadResponse:item contentRequest:contentRequest fromUrl:url error:error];
    }];
    [self.progressController showProgressWithTitle:[NSString stringWithFormat:@"Uploading!"] progress:task.progress];
}

- (void)showUploadResponse:(ODItem *)item
            contentRequest:(ODItemContentRequest*)request
                   fromUrl:(NSURL *)fileURL
                     error:(NSError *)error
{
    [self.progressController hideProgress];
    UIAlertController *responseController = nil;
    if (error){
        responseController = [UIAlertController alertControllerWithTitle:@"Failed To Upload item" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self uploadContentRequest:request fromFile:fileURL];
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        
        [responseController addAction:tryAgain];
        [responseController addAction:ok];
    }
    else {
        NSString *title = [NSString stringWithFormat:@"Uploaded %@ !", item.name];
        NSString *message = [NSString stringWithFormat:@"Item Id : %@", item.id];
        responseController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if (item) {
                if (![self.itemsLookup containsObject:item.id]){
                    [self.itemsLookup addObject:item.id];
                }
                self.items[item.id] = item;
                [self.tableView reloadData];
            }
        }];
        
        [responseController addAction:ok];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self presentViewController:responseController animated:YES completion:nil];
    });
}

#pragma mark Alert Methods

- (void)showErrorAlert:(NSError*)error
{
    NSString *errorMsg;
    if ([error isAuthCanceledError]) {
        errorMsg = @"Sign-in was canceled!";
    }
    else if ([error isAuthenticationError]) {
        errorMsg = @"There was an error in the sign-in flow!";
    }
    else if ([error isClientError]) {
        errorMsg = @"Oops, we sent a bad request!";
    }
    else {
        errorMsg = @"Uh oh, an error occurred!";
    }
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:errorMsg
                                                                        message:[NSString stringWithFormat:@"%@", error]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    [errorAlert addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:errorAlert animated:YES completion:nil];
    });
}

@end
