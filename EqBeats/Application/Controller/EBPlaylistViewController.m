//
//  EBPlaylistViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBPlaylistViewController.h"
#import "EBSearchViewController.h"
#import "EBPlaylistOptionsCell.h"
#import "EBShadowedTextField.h"

@interface EBPlaylistViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet EBShadowedTextField *titleTextField;
@property (strong, nonatomic) EBSearchViewController *searchController;

@end

@implementation EBPlaylistViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (EBDeviceSystemMajorVersion() >= 7) {
        self.titleTextField.shadowOffset = CGSizeZero;
        self.titleTextField.textColor = [UIColor whiteColor];
        self.titleTextField.font = [UIFont boldSystemFontOfSize: 17.0f];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (self.editingPlaylist == nil) {
        self.editingPlaylist = [[EBPlaylist alloc] initWithEntity: [NSEntityDescription entityForName: @"EBPlaylist" inManagedObjectContext: EBModel.sharedModel.mainThreadObjectContext] insertIntoManagedObjectContext: nil];
        self.editingPlaylist.name = @"New Playlist";
    }
    self.titleTextField.text = self.editingPlaylist.name;
    [self.tableView reloadData];
    if (self.tableView.contentOffset.y == 0) {
        CGFloat tableHeight = self.tableView.frame.size.height - self.tableView.contentInset.top;
        if (EBDeviceSystemMajorVersion() >= 7) {
            tableHeight -= 64;
        }
        if (self.tableView.contentSize.height < tableHeight + 44) {
            self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, tableHeight + 44);
        }
        [self.tableView setContentOffset: CGPointMake(0, 44)];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    if ([self.editingPlaylist hasChanges]) {
        [EBModel.sharedModel.mainThreadObjectContext save: nil];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    if (self.editingPlaylist.managedObjectContext == nil) {
        self.titleTextField.text = nil;
        [self.titleTextField becomeFirstResponder];
    }
}

#pragma mark - Table View Crud

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editingPlaylist.tracks.count + 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self tableView: tableView numberOfRowsInSection: indexPath.section];
    if (indexPath.row == 0) {
        // Top options
        EBPlaylistOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EBPlaylistOptionsCellTop"];
        [cell.editButton addTarget: self action: @selector(editButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [cell.clearButton addTarget: self action: @selector(clearButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [cell.deleteButton addTarget: self action: @selector(deleteButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.row == count - 1) {
        // Add from search button
        EBPlaylistOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EBPlaylistOptionsCellBottom"];
        [cell.addButton addTarget: self action: @selector(addButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        return cell;
    } else {
        return [super tableView: tableView cellForRowAtIndexPath: indexPath];
    }
}

- (EBTrack*) trackForIndexPath:(NSIndexPath *)indexPath
{
    return self.editingPlaylist.tracks[indexPath.row-1];
}

- (NSArray*) tracksForQueueAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editingPlaylist.tracks.array;
}

#pragma mark - Actions

- (void) editButtonAction: (id) sender
{
    
}

- (void) clearButtonAction: (id) sender
{
    
}

- (void) deleteButtonAction: (id) sender
{
    
}

- (void) addButtonAction: (id) sender
{
    
}

- (IBAction)titleTextEditingChanged:(id)sender
{
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.editingPlaylist.name == nil) {
        textField.text = nil;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        textField.text = @"New Playlist";
    } else if (self.editingPlaylist.managedObjectContext == nil) {
        self.editingPlaylist.sortIndex = [[[EBModel allPlaylists] lastObject] sortIndex] + 1;
        [EBModel.sharedModel.mainThreadObjectContext insertObject: self.editingPlaylist];
    }
    self.editingPlaylist.name = textField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"AddFromSearchSegue"]) {
        self.searchController = [[segue.destinationViewController storyboard] instantiateViewControllerWithIdentifier: @"EBSearchViewController"];
        self.searchController.playlist = self.editingPlaylist;
        [segue.destinationViewController pushViewController: self.searchController animated: NO];
    }
}

@end
