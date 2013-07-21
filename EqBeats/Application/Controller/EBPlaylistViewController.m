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
    if (self.playlist == nil) {
        self.playlist = [[EBPlaylist alloc] initWithEntity: [NSEntityDescription entityForName: @"EBPlaylist" inManagedObjectContext: EBModel.sharedModel.mainThreadObjectContext] insertIntoManagedObjectContext: nil];
        self.playlist.name = @"New Playlist";
    }
    self.titleTextField.text = self.playlist.name;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    if ([self.playlist hasChanges]) {
        [EBModel.sharedModel.mainThreadObjectContext save: nil];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    if (self.playlist.managedObjectContext == nil) {
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
    return self.playlist.tracks.count + 2;
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
    return self.playlist.tracks[indexPath.row-1];
}

- (NSArray*) tracksForQueueAtIndexPath:(NSIndexPath *)indexPath
{
    return self.playlist.tracks.array;
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
    if (self.playlist.name == nil) {
        textField.text = nil;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        textField.text = @"New Playlist";
    } else if (![self.playlist isInserted]) {
        self.playlist.sortIndex = [[[EBModel allPlaylists] lastObject] sortIndex] + 1;
        [EBModel.sharedModel.mainThreadObjectContext insertObject: self.playlist];
    }
    self.playlist.name = textField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"AddFromSearchSegue"]) {
        EBSearchViewController *searchVC = [[segue.destinationViewController storyboard] instantiateViewControllerWithIdentifier: @"EBSearchViewController"];
        searchVC.playlist = self.playlist;
        [segue.destinationViewController pushViewController: searchVC animated: NO];
    }
}

@end
