//
//  StudyViewCardsViewController.m
//  hci-flashcard-iPhone
//
//  Created by Jordan Sommers on 3/11/14.
//  Copyright (c) 2014 CMPE131. All rights reserved.
//

#import "StudyViewCardsViewController.h"
#import "Deck.h"
#import "Flashcard.h"
#import "FlashcardViewController.h"

@interface StudyViewCardsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *flashcardSet;
@end

@implementation StudyViewCardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flashcardSet.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyViewCards"];
    
    Flashcard *flashcard = self.flashcardSet[indexPath.row];
    cell.textLabel.text = flashcard.front;

    
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
        // Delete flashcard from set
        Flashcard *flashcard = self.flashcardSet[indexPath.row];
        [self.flashcardSet removeObjectAtIndex:indexPath.row];
        [flashcard deleteEntity];
        [tableView reloadData];
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewCardsFlashcardSegue"]) {
        FlashcardViewController *flashcardController = (FlashcardViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Flashcard *card = self.flashcardSet[indexPath.row];
        flashcardController.currentCard = card;
        flashcardController.deckref = self.deckref;
        flashcardController.group = self.group;
    }
}

#pragma mark Button Actions

- (void) editPressed {
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
}

- (void) doneEditing {
    [self.tableView setEditing:NO animated:YES];
    if (self.flashcardSet.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.deckref) {
        if (!self.group) {
            self.group = GROUP_ENTIRE_DECK;
            NSLog(@"Group wasn't passed to StudyViewCardsViewController");
        }
        NSPredicate *filterGroup;
        if ([self.group isEqualToString:GROUP_ENTIRE_DECK]) {
            // Don't filter, group is all cards
            self.flashcardSet = [[self.deckref.cards allObjects] mutableCopy];
        } else if ([self.group isEqualToString:GROUP_NOT_LEARNED]) {
            filterGroup = [NSPredicate predicateWithFormat:@"learned == NO"];
        } else {
            // Group learned
            filterGroup = [NSPredicate predicateWithFormat:@"learned == YES"];
        }
        // Use filtered card set for data
        if (filterGroup) {
            self.flashcardSet = [[[self.deckref.cards filteredSetUsingPredicate:filterGroup] allObjects] mutableCopy];
        }
        if (self.flashcardSet.count > 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
        }
    } else {
        NSLog(@"Deck wasn't passed to StudyViewCardsViewController");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
