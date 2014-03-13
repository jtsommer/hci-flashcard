//
//  SecondViewController.m
//  hci-flashcard-iPhone
//
//  Created by jtsommer on 3/2/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "CreateEditListViewController.h"
#import "Deck.h"
#import "CreateChooseMethodViewController.h"

@interface CreateEditListViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *decks;
@end

NSInteger deletionRow = -1;

@implementation CreateEditListViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.decks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeckCell"];
    
    Deck *deck = self.decks[indexPath.row];
    cell.textLabel.text = deck.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Cards: %lu", (unsigned long)deck.cards.count];
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Deck *deck = self.decks[indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:[NSString stringWithFormat:@"Really delete deck %@?", deck.name] delegate:self cancelButtonTitle:@"Don't Delete" otherButtonTitles:@"Yes, Delete", nil];
        deletionRow = indexPath.row;
        [alert show];
    }
}

- (void) confirmDelete {
    if (deletionRow != -1) {
        Deck *deck = [self.decks objectAtIndex:deletionRow];
        [self.decks removeObjectAtIndex:deletionRow];
        [deck deleteEntity];
        [self.tableView reloadData];
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *selection = [alertView buttonTitleAtIndex:buttonIndex];
    if ([selection isEqualToString:@"Don't Delete"]) {
        return;
    }
    // No other buttons, do it hacky and confirm deletion
    [self confirmDelete];
}

#pragma mark Button Actions

- (void) editPressed {
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
}

- (void) doneEditing {
    [self.tableView setEditing:NO animated:YES];
    if (self.decks.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
    }
}

#pragma mark

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createDeckSelected"]) {
        CreateChooseMethodViewController *chooseMethodController = (CreateChooseMethodViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Deck *deck = self.decks[indexPath.row];
        chooseMethodController.deckref = deck;
    }
}

- (void)fetchDecks {
    self.decks = [[Deck findAllSortedBy:@"name" ascending:YES] mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self fetchDecks];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    if (parent) {
        // viewDidLoad doesn't get called when coming back off the navigation stack
        // Fetch decks and refresh the table here so if a new deck was created
        // it will load properly
        [self fetchDecks];
        [self.tableView reloadData];
    }
}

@end
